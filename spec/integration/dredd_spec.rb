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

  let(:template) { File.read('config/template.md.erb') }
  let(:github_client) do
    Octokit::Client.new(
        login: config.username,
        oauth_token: config.token
    )
  end

  let(:allowed_usernames) { [] }
  let(:allowed_domains) { [] }
  let(:allowed_emails) { [] }

  let(:config_hash) do
    {
        'credentials' => {
            'username' => 'github-username',
            'token' => 'github-token'
        },
        'callback_url' => 'http://example.com/callback_url',
        'callback_secret' => 'asdfasdfasdf',
        'allowed_usernames' => allowed_usernames,
        'allowed_emails' => allowed_emails,
        'allowed_domains' => allowed_domains,
        'repositories' => %w(username/repository 'username/other-repository')
    }
  end
  let(:config) { Dredd::Config.new(config_hash) }
  let(:commenter) { Dredd::PullRequestCommenter.new(github_client, template) }
  let(:filter) do
    Dredd::CompositeFilter.new([
        Dredd::UsernameFilter.new(config.allowed_usernames),
        Dredd::EmailFilter.new(github_client, config.allowed_emails),
        Dredd::DomainFilter.new(github_client, config.allowed_domains)
    ])
  end
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

  def stub_email_fetching
    stub_request(:get, 'https://api.github.com/users/xoebus').to_return(
        body: JSON.dump(email: 'xoebus@xoeb.us'),
        headers: { 'Content-Type' => 'application/json' }
    )
  end

  describe 'commenting on pull requests' do
    before do
      app.set :commenter, filtered_commenter
      app.set :secret, secret

      stub_email_fetching
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

    describe 'allowed emails' do
      context 'when the user email is in the allowed emails' do
        let(:allowed_emails) { %w(xoebus@xoeb.us) }

        it 'does not make a comment' do
          github_calls_callback
          assert_comment_was_not_made
        end
      end

      context 'when the user email is not in the allowed emails' do
        let(:allowed_emails) { %w(random@xoeb.us) }

        it 'makes a comment' do
          github_calls_callback
          assert_comment_was_made
        end
      end
    end

    describe 'allowed domains' do
      context 'when the user email domain is in the allowed domains' do
        let(:allowed_domains) { %w(xoeb.us) }

        it 'does not make a comment' do
          github_calls_callback
          assert_comment_was_not_made
        end
      end

      context 'when the user email domain is not in the allowed domains' do
        let(:allowed_domains) { %w(google.com) }

        it 'makes a comment' do
          github_calls_callback
          assert_comment_was_made
        end
      end
    end
  end
end