module AppLab
  module Services
    module Practices
      class AutoVerifier
        attr_reader :item

        def initialize(item)
          @item = item
        end

        def verify
          rule = item.automation_rule
          return { passed: false, data: { error: "No automation rule" }, method: "none" } unless rule

          case rule["type"]
          when "file_exists"
            check_file_exists(rule)
          when "gem_present"
            check_gem_present(rule)
          when "config_value"
            check_config_value(rule)
          when "directory_exists"
            check_directory_exists(rule)
          when "pattern_match"
            check_pattern_match(rule)
          else
            { passed: false, data: { error: "Unknown rule type: #{rule['type']}" }, method: rule["type"] }
          end
        end

        private

        def check_file_exists(rule)
          path = File.join(Rails.root, rule["path"])
          exists = File.exist?(path)
          { passed: exists, data: { path: rule["path"], exists: exists }, method: "file_exists" }
        end

        def check_gem_present(rule)
          gemfile_path = File.join(Rails.root, "Gemfile")
          content = File.read(gemfile_path)
          present = content.match?(/gem\s+['"]#{Regexp.escape(rule["gem_name"])}['"]/)
          { passed: present, data: { gem: rule["gem_name"], present: present }, method: "gem_present" }
        end

        def check_config_value(rule)
          config_path = File.join(Rails.root, rule["file"])
          return { passed: false, data: { error: "File not found" }, method: "config_value" } unless File.exist?(config_path)

          content = File.read(config_path)
          matched = content.match?(Regexp.new(rule["pattern"]))
          { passed: matched, data: { pattern: rule["pattern"], matched: matched }, method: "config_value" }
        end

        def check_directory_exists(rule)
          path = File.join(Rails.root, rule["path"])
          exists = Dir.exist?(path)
          { passed: exists, data: { path: rule["path"], exists: exists }, method: "directory_exists" }
        end

        def check_pattern_match(rule)
          file_path = File.join(Rails.root, rule["file"])
          return { passed: false, data: { error: "File not found" }, method: "pattern_match" } unless File.exist?(file_path)

          content = File.read(file_path)
          matched = content.match?(Regexp.new(rule["pattern"]))
          { passed: matched, data: { pattern: rule["pattern"], matched: matched }, method: "pattern_match" }
        end
      end
    end
  end
end
