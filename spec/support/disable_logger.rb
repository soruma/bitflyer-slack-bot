# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    allow($stdout).to receive(:write) unless $LOADED_FEATURES.join.include? 'pry'
  end
end
