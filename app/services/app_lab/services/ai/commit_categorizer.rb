module AppLab
  module Services
    module Ai
      class CommitCategorizer
        SYSTEM_PROMPT = <<~PROMPT
          You categorize git commits into exactly one of these categories:
          - feature: New functionality
          - fix: Bug fix
          - refactor: Code improvement without behavior change
          - chore: Maintenance, CI/CD, documentation
          - dependency: Dependency updates
          - security: Security-related changes

          Respond with ONLY the category name, nothing else.
        PROMPT

        VALID_CATEGORIES = %w[feature fix refactor chore dependency security].freeze

        def initialize(client: nil)
          @client = client || BaseClient.new
        end

        def categorize(commit_entry)
          result = @client.chat(
            system: SYSTEM_PROMPT,
            messages: [
              { role: "user", content: "Categorize: #{commit_entry.message}" }
            ],
            max_tokens: 20
          )

          category = result&.strip&.downcase
          VALID_CATEGORIES.include?(category) ? category : "chore"
        end
      end
    end
  end
end
