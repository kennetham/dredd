require 'sinatra'
require 'json'
require 'openssl'

module Dredd
  class DreddApp < Sinatra::Base
    get '/status' do
      'OK'
    end

    post '/' do
      body = request.body.read
      check_hmac(body)
      comment(JSON.parse(body))
    end

    private

    def comment(json_hash)
      commenter = settings.commenter
      pull_request = json_hash.fetch('pull_request')
      repo = pull_request.fetch('base').fetch('repo').fetch('full_name')
      number = pull_request.fetch('number')
      user = pull_request.fetch('user').fetch('login')
      commenter.comment(repo, number, user)
    end

    def check_hmac(body)
      secret = settings.secret
      digest = OpenSSL::Digest::Digest.new('sha1')
      hmac = 'sha1=' + OpenSSL::HMAC.hexdigest(digest, secret, body)
      request_hmac = request.env['HTTP_X_HUB_SIGNATURE']

      halt 401, 'Not authorized' if hmac != request_hmac
    end
  end
end