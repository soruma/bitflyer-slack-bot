# frozen_string_literal: true

RSpec.describe SlackPostMessage::App do
  let(:event) do
    JSON.parse(File.read(File.join(File.dirname(__FILE__), '../../fixtures/slack_post_message.json')))
  end

  before do
    allow(ENV).to receive(:fetch).and_call_original
    allow(ENV).to receive(:fetch).with('SLACK_TARGET_CHANNEL', 'general').and_return('sandbox')
  end

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
    subject(:call) { described_class.new(event, nil).call }

    let(:mock_slack_web_client) { instance_double(Slack::Web::Client) }

    before do
      allow(Slack::Web::Client).to receive(:new).and_return(mock_slack_web_client)
      allow(mock_slack_web_client).to receive(:chat_postMessage)
    end

    it 'post message to slack' do
      call
      expect(mock_slack_web_client).to have_received(:chat_postMessage).once
    end
  end

  describe '#channel' do
    subject(:channel) { described_class.new(event, nil).channel }

    it 'return value of ENV SLACK_TARGET_CHANNEL' do
      expect(channel).to eq '#sandbox'
    end
  end

  describe '#message' do
    subject(:message) { described_class.new(event, nil).message }

    it 'return Sns.Message datum' do
      expect(message).to eq 'BTC_JPY: 3919359.0'
    end
  end
end
