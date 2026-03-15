module AppLab
  module Services
    module Insights
      class BaseDetector
        attr_reader :rule

        def initialize(rule)
          @rule = rule
        end

        def detect
          raise NotImplementedError, "#{self.class}#detect must be implemented"
        end

        private

        def app_path
          Rails.root.to_s
        end

        def ruby_files
          Dir.glob(File.join(app_path, "app", "**", "*.rb"))
        end

        def model_files
          Dir.glob(File.join(app_path, "app", "models", "**", "*.rb"))
        end

        def controller_files
          Dir.glob(File.join(app_path, "app", "controllers", "**", "*.rb"))
        end

        def read_file(path)
          File.read(path)
        rescue Errno::ENOENT
          nil
        end

        def relative_path(path)
          path.sub("#{app_path}/", "")
        end
      end
    end
  end
end
