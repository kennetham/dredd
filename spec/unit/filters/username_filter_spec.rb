require 'spec_helper'

require 'dredd/filters/username_filter'

describe Dredd::UsernameFilter do
  let(:filter) { described_class.new(allowed_usernames) }

  let(:author) { 'xoebus' }
  let(:pull_request) { Dredd::PullRequest.new(1, 'xoebus/dredd', author, 'opened') }

  describe '#filter?' do
    context 'when the pull request author is in the allowed usernames' do
      let(:allowed_usernames) { [author] }

      it 'is true' do
        expect(filter.filter?(pull_request)).to be_true
      end
    end

    context 'when the pull request author is in the allowed usernames' do
      let(:allowed_usernames) { %w(seadowg tissarah) }

      it 'is false' do
        expect(filter.filter?(pull_request)).to be_false
      end
    end
  end
end