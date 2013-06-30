module Dredd
  class CompositeFilter
    def initialize(filters)
      @filters = filters
    end

    def filter?(pull_request)
      @filters.any? do |filter|
        filter.filter?(pull_request)
      end
    end
  end
end