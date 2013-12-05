require 'dredd/pull_request'

module Dredd
  class OrganizationFilter
    def initialize(client, allowed_organizations)
      @client = client
      @allowed_organizations = allowed_organizations
    end

    def filter?(pull_request)
      username = pull_request.author
      organizations = organizations_for_user(username)
      ! (organizations.map(&:downcase) & @allowed_organizations.map(&:downcase)).empty?
    end

    private

    def organizations_for_user(username)
      user = @client.user(username)
      return [] unless user.organizations_url

      @client.get(user.organizations_url).map(&:login)
    end
  end
end
