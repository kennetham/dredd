require 'erb'

module Dredd
  class PullRequestCommenter
    def initialize(client, template)
      @client = client
      @template = ERB.new(template)
    end

    def comment(repository, pull_request_number, username)
      comment_text = render_comment(username)
      @client.add_comment(repository, pull_request_number, comment_text)
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