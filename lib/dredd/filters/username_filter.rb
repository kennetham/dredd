require 'dredd/pull_request'

module Dredd
  class UsernameFilter
    def initialize(allowed_usernames)
      @allowed_usernames = allowed_usernames
    end

    def filter?(pull_request)
      username = pull_request.author
      @allowed_usernames.include?(username)
    end
  end
end
