module Dredd
  class PullRequest
    attr_reader :id
    attr_reader :repository
    attr_reader :author

    def self.from_hash(hash)
      repository = hash.fetch('base').fetch('repo').fetch('full_name')
      id = hash.fetch('number')
      author = hash.fetch('user').fetch('login')

      new(id, repository, author)
    end

    def initialize(id, repository, author)
      @id = id
      @repository = repository
      @author = author
    end
  end
end