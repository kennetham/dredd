require 'dredd/pull_request'

module Dredd
  class DomainFilter
    def initialize(client, allowed_domains)
      @client = client
      @allowed_domains = allowed_domains
    end

    def filter?(pull_request)
      username = pull_request.author
      domain = domain_for_user(username)
      @allowed_domains.include?(domain)
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
