require 'spec_helper'
require 'dredd/callback'

describe Dredd::Callback do
  let(:url) { 'http://example.com/callback' }
  let(:secret) { 'a_very_secret_value' }
  let(:callback) { described_class.new(url, secret) }

  it 'allows retrieval of the constructor parameters' do
    expect(callback.url).to eq(url)
    expect(callback.secret).to eq(secret)
  end
end
