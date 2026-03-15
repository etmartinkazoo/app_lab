module AppLab
  module Services
    module Ai
      class BaseClient
        def initialize(provider: nil, api_key: nil, model: nil)
          @provider = provider || AppLab.configuration.ai_provider
          @api_key = api_key || AppLab.configuration.ai_api_key
          @model = model || AppLab.configuration.ai_model
        end

        def chat(messages:, system: nil, max_tokens: 4096)
          case @provider
          when :anthropic
            anthropic_chat(messages: messages, system: system, max_tokens: max_tokens)
          when :kimi
            kimi_chat(messages: messages, system: system, max_tokens: max_tokens)
          else
            raise "Unsupported AI provider: #{@provider}"
          end
        end

        private

        def anthropic_chat(messages:, system:, max_tokens:)
          uri = URI("https://api.anthropic.com/v1/messages")
          body = {
            model: @model,
            max_tokens: max_tokens,
            messages: messages
          }
          body[:system] = system if system

          request = Net::HTTP::Post.new(uri)
          request["x-api-key"] = @api_key
          request["anthropic-version"] = "2023-06-01"
          request["content-type"] = "application/json"
          request.body = body.to_json

          response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(request)
          end

          result = JSON.parse(response.body, symbolize_names: true)
          result.dig(:content, 0, :text)
        end

        def kimi_chat(messages:, system:, max_tokens:)
          uri = URI("https://api.moonshot.cn/v1/chat/completions")
          msgs = []
          msgs << { role: "system", content: system } if system
          msgs.concat(messages)

          body = {
            model: @model,
            messages: msgs,
            max_tokens: max_tokens
          }

          request = Net::HTTP::Post.new(uri)
          request["Authorization"] = "Bearer #{@api_key}"
          request["content-type"] = "application/json"
          request.body = body.to_json

          response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(request)
          end

          result = JSON.parse(response.body, symbolize_names: true)
          result.dig(:choices, 0, :message, :content)
        end
      end
    end
  end
end
