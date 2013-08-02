module Dredd
  class PullRequest
    attr_reader :id
    attr_reader :repository
    attr_reader :author
    attr_reader :action

    def self.from_hash(hash)
      repository = hash.fetch('pull_request').fetch('base').fetch('repo').fetch('full_name')
      id = hash.fetch('pull_request').fetch('number')
      author = hash.fetch('pull_request').fetch('user').fetch('login')
      action = hash.fetch('action')

      new(id, repository, author, action)
    end

    def initialize(id, repository, author, action)
      @id = id
      @repository = repository
      @author = author
      @action = action
    end
  end
end