require 'octokit'

$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')
require 'dredd'

config = Dredd::Config.from_file('config/config.yml')
template = File.read('config/template.md.erb')

github_client = Octokit::Client.new(login: config.username,
    oauth_token: config.token)

bootstrapper = Dredd::HookBootstrapper.new(github_client,
                                           config.callback_url,
                                           config.callback_secret)
config.repositories.each do |repo|
  bootstrapper.bootstrap_repository(repo)
end

commenter = Dredd::PullRequestCommenter.new(github_client, template)
filterer = Dredd::UsernameFilterer.new(commenter, config.allowed_usernames)

Dredd::DreddApp.set :commenter, filterer
Dredd::DreddApp.set :secret, config.callback_secret

run Dredd::DreddApp
