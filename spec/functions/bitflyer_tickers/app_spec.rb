# frozen_string_literal: true

RSpec.describe BitflyerTickers::App do
  describe '.lambda_handler' do
    subject(:lambda_handler) do
      described_class.lambda_handler({ event: 'event', context: 'context' })
    end

    let(:mock_described_class) { instance_double(described_class) }

    before { allow(described_class).to receive(:new).and_return(mock_described_class) }

    context 'when success' do
      before do
        allow(mock_described_class).to receive(:call).and_return('dummy value')
      end

      it 'return value for call method' do
        expect(lambda_handler).to match({ statusCode: 200, message: 'dummy value' })
      end
    end

    context 'when faild' do
      before do
        allow(mock_described_class).to receive(:call).and_raise(StandardError)
      end

      it 'return Faild' do
        expect(lambda_handler).to match({ statusCode: 500, message: 'StandardError' })
      end
    end
  end

  describe '#call' do
    subject(:call) do
      described_class.new({ 'ProductCodes' => product_codes }, nil).call
    end

    context 'with exists product code' do
      let(:product_codes) { %w[BTC_JPY ETH_JPY] }
      let(:message) do
        <<~PRICE.chomp
          BTC_JPY: 3727840.0
          ETH_JPY: 219425.0
        PRICE
      end

      it 'return product codes and current prices' do
        VCR.use_cassette 'functions/bitflyer_tickers/app/exists_product_code' do
          expect(call).to eq message
        end
      end
    end

    context 'with not exists product code' do
      let(:product_codes) { %w[UNDEFIND] }

      it do
        VCR.use_cassette 'functions/bitflyer_tickers/app/not_exists_product_code' do
          expect { call }.to raise_error(BitflyerTickers::BitflyerError, 'Invalid product')
        end
      end
    end
  end

  describe '#product_codes' do
    subject(:product_codes) { described_class.new({ 'ProductCodes' => %w[BTC_JPY] }, nil).product_codes }

    it 'return ProductCodes' do
      expect(product_codes).to match %w[BTC_JPY]
    end
  end
end
