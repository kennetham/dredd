require 'dredd/pull_request'

module Dredd
  class ActionFilter
    def initialize(client, enabled_actions)
      @client = client
      @enabled_actions = enabled_actions
    end

    def filter?(pull_request)
      ! (@enabled_actions.empty? || @enabled_actions.include?(pull_request.action))
    end
  end
end