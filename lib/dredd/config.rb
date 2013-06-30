require 'psych'

module Dredd
  class Config
    def self.from_file(file_path)
      hash = Psych.load_file(file_path)
      new(hash)
    end

    def initialize(hash)
      @hash = hash
    end

    def username
      get('credentials').fetch('username')
    end

    def token
      get('credentials').fetch('token')
    end

    def callback_url
      get('callback_url')
    end

    def callback_secret
      get('callback_secret')
    end

    def repositories
      get('repositories')
    end

    def allowed_usernames
      get('allowed_usernames', [])
    end

    def allowed_emails
      get('allowed_emails', [])
    end

    def allowed_domains
      get('allowed_domains', [])
    end

    private

    def get(key, default = nil)
      @hash.fetch(key, default) || default
    end
  end
end