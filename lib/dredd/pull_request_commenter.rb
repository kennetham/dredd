require 'erb'

module Dredd
  class PullRequestCommenter
    def initialize(client, template)
      @client = client
      @template = ERB.new(template)
    end

    def comment(pull_request)
      username = pull_request.author_username
      id = pull_request.id
      repository = pull_request.repository

      comment_text = render_comment(username)
      @client.add_comment(repository, id, comment_text)
    end

    private

    def render_comment(username)
      context = RenderingContext.new(username)
      @template.result(context.get_binding)
    end

    class RenderingContext
      attr_reader :username

      def initialize(username)
        @username = username
      end

      def get_binding
        binding
      end
    end
  end
end