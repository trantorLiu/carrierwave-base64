module Carrierwave
  module Base64
    module Adapter
      def mount_base64_uploader(attribute, uploader_class, options = {})
        mount_uploader attribute, uploader_class, options

        define_method "#{attribute}=" do |data|
          if data.present? && data.is_a?(String) && data.strip.start_with?("data")
            super(Carrierwave::Base64::Base64StringIO.new(data.strip))
          else
            super(data)
          end
        end
      end

      def mount_base64_uploaders(attribute, uploader_class, options = {})
        mount_uploaders attribute, uploader_class, options

        define_method "images=" do |data|
          if data.present? && data.is_a?(Array)
            files = []
            data.map do |d|
              if d.is_a?(String)&& d.strip.start_with?("data")
                files << Carrierwave::Base64::Base64StringIO.new(d.strip)
              else
                files << d
              end
            end
            super(files)
          else
            super([data])
          end
        end
      end
    end
  end
end
