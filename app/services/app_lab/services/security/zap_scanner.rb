module AppLab
  module Services
    module Security
      class ZapScanner
        def run
          AppLab.logger.warn("OWASP ZAP scanner is not yet implemented")
          { findings: [], raw_output: {}, summary: "ZAP scanner not yet implemented" }
        end
      end
    end
  end
end
