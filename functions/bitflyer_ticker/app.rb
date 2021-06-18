# frozen_string_literal: true

require 'bitflyer'

module BitflyerTicker
  class BitflyerError < StandardError
    def initialize(msg='Bitflyer error')
      super
    end
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
      @logger.info("product code for which ticker was request: #{product_code}")
      public_client = Bitflyer.http_public_client
      result = public_client.ticker(product_code: product_code)
      raise BitflyerError.new(result['error_message']) unless result.key?('state')

      <<~MSG
      #{product_code}: #{result['ltp']}
      MSG
    end

    def product_code
      @event['ProductCode']
    end
  end
end
