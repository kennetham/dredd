require 'spec_helper'

require 'octokit'
require 'dredd'

describe 'dredd application lifecycle' do
  include Rack::Test::Methods

  before(:all) do
    WebMock.disable_net_connect!
  end

  after(:all) do
    WebMock.allow_net_connect!
  end

  let(:allowed_usernames) { %w(xoebus) }
  let(:allowed_emails) { %w(chris@xoeb.us) }

  let(:config_hash) do
    {
        'credentials' => {
            'username' => 'github-username',
            'token' => 'github-token'
        },
        'callback_url' => 'http://example.com/callback_url',
        'callback_secret' => 'asdfasdfasdf',
        'allowed_usernames' => allowed_usernames,
        'repositories' => %w(username/repository 'username/other-repository')
    }
  end
  let(:config) { Dredd::Config.new(config_hash) }
  let(:template) { File.read('config/template.md.erb') }
  let(:github_client) do
    Octokit::Client.new(
        login: config.username,
        oauth_token: config.token
    )
  end
  let(:commenter) { Dredd::PullRequestCommenter.new(github_client, template) }
  let(:filter) { Dredd::UsernameFilter.new(config.allowed_usernames) }
  let(:filtered_commenter) { Dredd::FilteredCommenter.new(commenter, filter) }

  let(:secret) { config.callback_secret }
  let(:payload) { asset_contents('pull_request_opened.json') }
  let(:digest) { OpenSSL::Digest::Digest.new('sha1') }
  let(:hmac) { OpenSSL::HMAC.hexdigest(digest, secret, payload) }

  def app
    Dredd::DreddApp
  end

  def github_calls_callback
    post '/', payload, 'HTTP_X_HUB_SIGNATURE' => "sha1=#{hmac}"
  end

  def assert_comment_was_not_made
    assert_not_requested(
        :post,
        'https://api.github.com/repos/xoebus/dredd/issues/10/comments'
    )
  end

  def assert_comment_was_made
    assert_requested(
        :post,
        'https://api.github.com/repos/xoebus/dredd/issues/10/comments'
    )
  end

  describe 'commenting on pull requests' do
    before do
      app.set :commenter, filtered_commenter
      app.set :secret, secret
    end

    describe 'allowed usernames' do
      context 'when the user is in the allowed usernames' do
        let(:allowed_usernames) { %w(xoebus) }

        it 'does not make a comment' do
          github_calls_callback
          assert_comment_was_not_made
        end
      end

      context 'when the user is not in the allowed usernames' do
        let(:allowed_usernames) { %w(seadowg tissarah) }

        it 'makes a comment' do
          github_calls_callback
          assert_comment_was_made
        end
      end
    end
  end
end