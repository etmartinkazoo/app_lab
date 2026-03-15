module AppLab
  module Services
    module Ai
      class SummaryGenerator
        SYSTEM_PROMPT = <<~PROMPT
          You are a technical writer summarizing daily code changes for a development team.
          Provide a clear, concise summary that groups commits by category:
          - Features: New functionality added
          - Fixes: Bug fixes and corrections
          - Refactors: Code improvements without behavior changes
          - Dependencies: Dependency updates
          - Security: Security-related changes
          - Chores: Maintenance, CI/CD, documentation

          Highlight any breaking changes prominently.
          Identify key contributors.
          Keep the summary under 500 words.
          Use markdown formatting.
        PROMPT

        def initialize(client: nil)
          @client = client || BaseClient.new
        end

        def generate(report)
          commits_text = report.commit_entries.map { |c|
            "#{c.sha[0..7]} by #{c.author}: #{c.message}"
          }.join("\n")

          @client.chat(
            system: SYSTEM_PROMPT,
            messages: [
              { role: "user", content: "Summarize these commits from #{report.date}:\n\n#{commits_text}" }
            ]
          )
        end
      end
    end
  end
end
