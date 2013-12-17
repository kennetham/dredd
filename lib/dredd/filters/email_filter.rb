require 'dredd/pull_request'

module Dredd
  class EmailFilter
    def initialize(client, logger, allowed_emails)
      @client = client
      @logger = logger
      @allowed_emails = allowed_emails
    end

    def filter?(pull_request)
      username = pull_request.author
      email = email_for_user(username)

      if (filter = @allowed_emails.include?(email))
        @logger.info("allow: email '#{email}' in allowed emails list")
      else
        @logger.info("deny: email '#{email}' not in allowed emails list")
      end

      filter
    end

    private

    def email_for_user(username)
      @client.user(username).email
    end
  end
end
