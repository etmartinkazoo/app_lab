module AppLab
  module Services
    module Ai
      class RemediationGenerator
        SYSTEM_PROMPT = <<~PROMPT
          You are a security expert providing remediation advice for vulnerabilities found in Rails applications.
          For each finding, provide:
          1. A clear explanation of the vulnerability
          2. The risk if left unpatched
          3. Step-by-step remediation instructions
          4. A code example showing the fix
          5. Links to relevant documentation (OWASP, Rails guides, CWE)
          6. Estimated effort (quick/medium/large)

          Use markdown formatting. Be specific and actionable.
        PROMPT

        def initialize(client: nil)
          @client = client || BaseClient.new
        end

        def generate(finding)
          context = [
            "Severity: #{finding.severity}",
            "Category: #{finding.category}",
            "File: #{finding.file_path}:#{finding.line_number}",
            "Description: #{finding.description}",
            ("CWE: #{finding.cwe_id}" if finding.cwe_id),
            ("OWASP: #{finding.owasp_category}" if finding.owasp_category)
          ].compact.join("\n")

          @client.chat(
            system: SYSTEM_PROMPT,
            messages: [
              { role: "user", content: "Provide remediation for this security finding:\n\n#{context}" }
            ]
          )
        end
      end
    end
  end
end
