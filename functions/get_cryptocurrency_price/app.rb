# frozen_string_literal: true

require 'bitflyer'

module GetCryptocurrencyPrice
  class BitflyerError < StandardError
    def initialize(msg = 'Bitflyer error')
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
      @logger.info("product code for which ticker was request: #{product_codes}")
      product_code_per_ltps = product_codes.map do |product_code|
        result = public_client.ticker(product_code: product_code)
        raise BitflyerError, result['error_message'] unless result.key?('state')

        "#{product_code}: #{result['ltp']}"
      end

      product_code_per_ltps.join("\n")
    end

    def product_codes
      @event['Input']['ProductCodes']
    end

    private

    def public_client
      @public_client ||= Bitflyer.http_public_client
    end
  end
end
