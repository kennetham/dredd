module Dredd
  class CompositeFilter
    def initialize(logger, filters)
      @logger = logger
      @filters = filters
    end

    def filter?(pull_request)
      should_filter = @filters.any? do |filter|
        filter.filter?(pull_request)
      end

      if should_filter
        @logger.info 'allow: at least one of the above filters matched'
      else
        @logger.info 'deny: none of the above filters matched'
      end

      should_filter
    end
  end
end
