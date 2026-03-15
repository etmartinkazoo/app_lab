module AppLab
  module Services
    module Security
      class ScannerFactory
        def self.build(scanner_type)
          case scanner_type.to_sym
          when :brakeman
            BrakemanScanner.new
          when :bundle_audit
            BundleAuditScanner.new
          when :semgrep
            SemgrepScanner.new
          when :zap
            ZapScanner.new
          else
            raise ArgumentError, "Unknown scanner type: #{scanner_type}"
          end
        end
      end
    end
  end
end
