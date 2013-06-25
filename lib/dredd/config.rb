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
      @hash.fetch('credentials').fetch('username')
    end

    def token
      @hash.fetch('credentials').fetch('token')
    end

    def callback_url
      @hash.fetch('callback_url')
    end

    def callback_secret
      @hash.fetch('callback_secret')
    end

    def repositories
      @hash.fetch('repositories')
    end

    def allowed_usernames
      @hash.fetch('allowed_usernames')
    end
  end
end