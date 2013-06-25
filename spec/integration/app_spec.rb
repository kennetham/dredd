require 'spec_helper'

require 'rack/test'

require 'dredd/app'

set :environment, :test

describe Dredd::DreddApp do
  include Rack::Test::Methods

  let(:commenter) { double('Commenter') }

  def app
    described_class
  end

  before do
    app.set :commenter, commenter
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

    it 'tells the commenter to comment' do
      commenter.should_receive(:comment).with('xoebus/dredd', 10, 'xoebus')
      post '/', payload
      expect(last_response).to be_ok
    end
  end
end