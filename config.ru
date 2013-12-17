require 'octokit'
require 'logging'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'dredd'

config = Dredd::Config.from_file('config/config.yml')
template = File.read('config/template.md.erb')

github_client = Octokit::Client.new(login: config.username,
    oauth_token: config.token)

logger = Logging.logger('dredd')
logger.level = :all
logger.add_appenders(
    Logging.appenders.stdout,
)

callback = Dredd::Callback.new(config.callback_url, config.callback_secret)
bootstrapper = Dredd::HookBootstrapper.new(github_client,
                                           logger,
                                           callback,
                                           config.skip_bootstrap)
config.repositories.each do |repo|
  bootstrapper.bootstrap_repository(repo)
end

composite_filter = Dredd::CompositeFilter.new(logger, [
    Dredd::EmailFilter.new(github_client, logger, config.allowed_emails),
    Dredd::UsernameFilter.new(logger, config.allowed_usernames),
    Dredd::DomainFilter.new(github_client, logger, config.allowed_domains),
    Dredd::OrganizationFilter.new(github_client, logger, config.allowed_organizations),
    Dredd::ActionFilter.new(github_client, logger, config.enabled_actions)
])

commenter = Dredd::PullRequestCommenter.new(github_client, logger, template)
filtered_commenter = Dredd::FilteredCommenter.new(commenter, composite_filter)

Dredd::DreddApp.set :commenter, filtered_commenter
Dredd::DreddApp.set :secret, config.callback_secret

run Dredd::DreddApp
