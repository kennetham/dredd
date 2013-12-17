module Dredd
  class HookBootstrapper
    def initialize(client, callback, skip_bootstrap)
      @client = client
      @callback = callback
      @skip_bootstrap = skip_bootstrap
    end

    def bootstrap_repository(repository)
      return if @skip_bootstrap || hook_already_created?(repository)
      create_hook(repository)
    end

    private

    def create_hook(repository)
      @client.create_hook(
          repository, 'web',
          { url: @callback.url, secret: @callback.secret,
            content_type: 'json' },
          events: %w(pull_request), active: true
      )
    end

    def hook_already_created?(repository)
      @client.hooks(repository).any? do |hook|
        hook_config = hook.config
        hook_config.url == @callback.url
      end
    end
  end
end
