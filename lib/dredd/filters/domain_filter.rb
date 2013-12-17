require 'dredd/pull_request'

module Dredd
  class DomainFilter
    def initialize(client, logger, allowed_domains)
      @client = client
      @logger = logger
      @allowed_domains = allowed_domains
    end

    def filter?(pull_request)
      username = pull_request.author
      domain = domain_for_user(username)

      if (filter = @allowed_domains.include?(domain))
        @logger.info("allow: domain '#{domain}' in allowed domains list")
      else
        @logger.info("deny: domain '#{domain}' not in allowed domains list")
      end

      filter
    end

    private

    def domain_for_user(username)
      email = email_for_user(username)
      email.split('@')[1]
    end

    def email_for_user(username)
      @client.user(username).email || ''
    end
  end
end
