module Dredd
  class WhitelistedCommenter
    def initialize(commenter, action_whitelist, composite_whitelist, templates)
      @commenter = commenter
      @action_whitelist = action_whitelist
      @composite_whitelist = composite_whitelist
      @whitelisted_template = templates[:whitelisted_template]
      @non_whitelisted_template = templates[:non_whitelisted_template]
    end

    def comment(pull_request)
      if @action_whitelist.whitelisted?(pull_request)
        if @composite_whitelist.whitelisted?(pull_request)
          @commenter.comment(pull_request, @whitelisted_template) if @whitelisted_template
        else
          @commenter.comment(pull_request, @non_whitelisted_template)
        end
      end
    end
  end
end
