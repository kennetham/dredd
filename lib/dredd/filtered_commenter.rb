module Dredd
  class FilteredCommenter
    def initialize(commenter, filter)
      @commenter = commenter
      @filter = filter
    end

    def comment(pull_request)
      return if filter?(pull_request)
      @commenter.comment(pull_request)
    end

    private

    def filter?(pull_request)
      @filter.filter?(pull_request)
    end
  end
end
