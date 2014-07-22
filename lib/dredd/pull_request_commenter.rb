require 'erb'

module Dredd
  class PullRequestCommenter
    def initialize(client, logger, template)
      @client = client
      @logger = logger
      @template = ERB.new(template)
    end

    def comment(pull_request)
      username = pull_request.author
      id = pull_request.id
      repository = pull_request.repository

      @logger.info("commenting on #{repository}##{id}")
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

      # rubocop:disable AccessorMethodName
      def get_binding
        binding
      end
      # rubocop:enable AccessorMethodName
    end
  end
end
