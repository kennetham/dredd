require 'dredd/pull_request'
require 'dredd/pull_request_commenter'

describe Dredd::PullRequestCommenter do
  let(:client) { double('GitHub Client') }
  let(:template) { 'hello <%= username %>' }
  let(:commenter) { described_class.new(client, template) }

  let(:repository) { 'xoebus/test-repo' }
  let(:id) { 55 }
  let(:username) { 'seadowg' }
  let(:action) { 'opened' }

  let(:pull_request) do
    Dredd::PullRequest.new(id, repository, username, action)
  end

  describe 'making a comment' do
    it 'makes a comment with a template' do
      client.should_receive(:add_comment).with(
          repository,
          id,
          'hello seadowg'
      )
      commenter.comment(pull_request)
    end
  end
end