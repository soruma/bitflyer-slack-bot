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
        body: App.new(event, context).call
      }
    rescue => e
      {
        statusCode: 500,
        body: e.message
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
      "##{ENV['SLACK_TARGET_CHANNEL']}"
    end

    def message
      message = JSON.parse(@event['Records'][0]['Sns']['Message'])
      message['Input']['message']
    end
  end
end
