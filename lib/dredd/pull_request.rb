module Dredd
  PullRequestAuthor = Struct.new(:username, :email)

  class PullRequest
    attr_reader :id
    attr_reader :repository
    attr_reader :author_username

    def self.from_hash(hash)
      repository = hash.fetch('base').fetch('repo').fetch('full_name')
      id = hash.fetch('number')
      user = hash.fetch('user').fetch('login')

      author = PullRequestAuthor.new(user)
      new(id, repository, author)
    end

    def initialize(id, repository, author)
      @id = id
      @repository = repository
      @author_username = author.username
    end
  end
end