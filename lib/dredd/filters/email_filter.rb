require 'dredd/pull_request'

module Dredd
  class EmailFilter
    def initialize(client, allowed_emails)
      @client = client
      @allowed_emails = allowed_emails
    end

    def filter?(pull_request)
      username = pull_request.author
      email = email_for_user(username)
      @allowed_emails.include?(email)
    end

    private

    def email_for_user(username)
      @client.user(username).email
    end
  end
end
