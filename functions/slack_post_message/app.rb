# frozen_string_literal: true

require 'slack-ruby-client'
require 'json'

module SlackPostMessage
  Slack.configure do |config|
    config.token = ENV['SLACK_API_TOKEN']
  end

  class App
    def self.lambda_handler(event:, context:)
      {
        statusCode: 200,
        message: App.new(event, context).call
      }
    rescue StandardError => e
      {
        statusCode: 500,
        message: e.message
      }
    end

    def initialize(event, _context)
      @logger = Logger.new($stdout)
      @event = event
    end

    def call
      @logger.info("Post message to workspace : channel: #{channel} message: #{message}")
      Slack::Web::Client.new.chat_postMessage(channel: channel, text: message, as_user: true)
    end

    def channel
      "##{ENV.fetch('SLACK_TARGET_CHANNEL', 'general')}"
    end

    def message
      JSON.parse(@event['Records'][0]['Sns']['Message'])['message']
    end
  end
end
