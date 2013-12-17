require 'spec_helper'

require 'dredd/pull_request'
require 'dredd/app'

set :environment, :test

describe Dredd::DreddApp do
  include Rack::Test::Methods

  let(:commenter) { double('Commenter') }
  let(:secret) { 'this-is-a-secret' }

  def app
    described_class
  end

  before do
    app.set :commenter, commenter
    app.set :secret, secret
  end

  describe 'reporting its status' do
    it 'responds with "OK"' do
      get '/status'

      expect(last_response).to be_ok
      expect(last_response.body).to eq('OK')
    end
  end

  describe 'receiving a pull request notification' do
    let(:payload) { asset_contents('pull_request_opened.json') }
    let(:digest) { OpenSSL::Digest::Digest.new('sha1') }
    let(:hmac) { OpenSSL::HMAC.hexdigest(digest, secret, payload) }
    let(:pull_request) { double(Dredd::PullRequest) }

    it 'tells the commenter to comment' do
      Dredd::PullRequest.stub(:from_hash) { pull_request }
      commenter.should_receive(:comment).with(pull_request)
      post '/', payload, 'HTTP_X_HUB_SIGNATURE' => "sha1=#{hmac}"
      expect(last_response).to be_ok
    end

    it 'rejects requests that do not come from github' do
      commenter.should_not_receive(:comment)
      post '/', payload
      expect(last_response.status).to eq 401
    end
  end
end
