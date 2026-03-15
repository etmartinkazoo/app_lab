require "net/http"
require "json"

module AppLab
  module Services
    module Github
      class CommitFetcher
        GITHUB_API_BASE = "https://api.github.com"

        def initialize(token: nil, repository: nil, branch: nil)
          @token = token || AppLab.configuration.github_access_token
          @repository = repository || AppLab.configuration.github_repository
          @branch = branch || AppLab.configuration.github_branch
        end

        def fetch(date:)
          since_time = date.beginning_of_day.iso8601
          until_time = date.end_of_day.iso8601

          commits = []
          page = 1

          loop do
            response = get_commits(since: since_time, until_time: until_time, page: page)
            break if response.empty?

            commits.concat(response.map { |c| parse_commit(c) })
            break if response.size < 100

            page += 1
          end

          commits
        end

        private

        def get_commits(since:, until_time:, page: 1)
          uri = URI("#{GITHUB_API_BASE}/repos/#{@repository}/commits")
          uri.query = URI.encode_www_form(
            sha: @branch,
            since: since,
            until: until_time,
            per_page: 100,
            page: page
          )

          request = Net::HTTP::Get.new(uri)
          request["Authorization"] = "Bearer #{@token}"
          request["Accept"] = "application/vnd.github+json"
          request["X-GitHub-Api-Version"] = "2022-11-28"

          response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(request)
          end

          if response.code.to_i == 200
            JSON.parse(response.body, symbolize_names: true)
          else
            AppLab.logger.error("GitHub API error: #{response.code} - #{response.body}")
            []
          end
        end

        def parse_commit(data)
          {
            sha: data[:sha],
            message: data.dig(:commit, :message),
            author: data.dig(:commit, :author, :name),
            author_email: data.dig(:commit, :author, :email),
            date: data.dig(:commit, :author, :date),
            url: data[:html_url]
          }
        end
      end
    end
  end
end
