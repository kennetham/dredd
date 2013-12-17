require 'dredd/pull_request'

module Dredd
  class ActionFilter
    def initialize(client, logger, enabled_actions)
      @client = client
      @logger = logger
      @enabled_actions = enabled_actions
    end

    def filter?(pull_request)
      action = pull_request.action
      filter = ! (@enabled_actions.empty? ||
         @enabled_actions.include?(action))

      if filter
        @logger.info "allow: action '#{action}' not in enabled actions list"
      else
        @logger.info "deny: action '#{action}' in enabled actions list"
      end

      filter
    end
  end
end
