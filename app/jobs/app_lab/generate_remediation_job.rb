module AppLab
  class GenerateRemediationJob < ApplicationJob
    queue_as :app_lab

    def perform(finding_id)
      finding = SecurityFinding.find(finding_id)
      remediation = Services::Ai::RemediationGenerator.new.generate(finding)
      finding.update!(ai_remediation: remediation)
    end
  end
end
