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
      pull_request = PullRequest.from_hash(json_hash)
      commenter.comment(pull_request)
    end

    def check_hmac(body)
      secret = settings.secret
      digest = OpenSSL::Digest::Digest.new('sha1')
      hmac = 'sha1=' + OpenSSL::HMAC.hexdigest(digest, secret, body)
      request_hmac = request.env['HTTP_X_HUB_SIGNATURE']

      halt 401, 'Not authorized' if hmac != request_hmac
    end

    def commenter
      settings.commenter
    end
  end
end
