module Dredd
  class HookBootstrapper
    def initialize(client, callback_url, callback_secret, skip_bootstrap)
      @client = client
      @callback_url = callback_url
      @callback_secret = callback_secret
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
          { url: @callback_url, secret: @callback_secret,
              content_type: 'json' },
          { events: %w(pull_request), active: true }
      )
    end

    def hook_already_created?(repository)
      @client.hooks(repository).any? do |hook|
        hook_config = hook.config
        hook_config.url == @callback_url
      end
    end
  end
end