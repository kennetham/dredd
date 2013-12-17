require 'spec_helper'

require 'dredd/filters/username_filter'

describe Dredd::UsernameFilter do
  let(:logger) { double('Logger').as_null_object }
  let(:filter) { described_class.new(logger, allowed_usernames) }

  let(:author) { 'xoebus' }
  let(:pull_request) do
    Dredd::PullRequest.new(1, 'xoebus/dredd', author, 'opened')
  end

  describe '#filter?' do
    context 'when the pull request author is in the allowed usernames' do
      let(:allowed_usernames) { [author] }

      it 'is true' do
        expect(filter.filter?(pull_request)).to be_true
      end

      it 'logs that the pull request is being filtered' do
        logger.should_receive(:info)
          .with("allow: user '#{author}' in allowed users list")

        filter.filter?(pull_request)
      end
    end

    context 'when the pull request author is in the allowed usernames' do
      let(:allowed_usernames) { %w(seadowg tissarah) }

      it 'is false' do
        expect(filter.filter?(pull_request)).to be_false
      end

      it 'logs that the pull request is not being filtered' do
        logger.should_receive(:info)
          .with("deny: user '#{author}' not in allowed users list")

        filter.filter?(pull_request)
      end
    end
  end
end
