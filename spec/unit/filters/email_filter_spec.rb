require 'spec_helper'

require 'hashie/mash'
require 'dredd/filters/email_filter'

describe Dredd::EmailFilter do
  let(:client) { double('GitHub Client') }
  let(:filter) { described_class.new(client, allowed_emails) }

  let(:author) { 'xoebus' }
  let(:pull_request) { Dredd::PullRequest.new(1, 'xoebus/dredd', author) }

  describe '#filter?' do
    before do
      client.should_receive(:user).with(author).and_return(
          Hashie::Mash.new(email: 'xoebus@xoeb.us')
      )
    end

    context 'when the pull request author is in the allowed usernames' do
      let(:allowed_emails) { %w(xoebus@xoeb.us) }

      it 'is true' do
        expect(filter.filter?(pull_request)).to be_true
      end
    end

    context 'when the pull request author is in the allowed usernames' do
      let(:allowed_emails) { %w(random@xoeb.us) }

      it 'is false' do
        expect(filter.filter?(pull_request)).to be_false
      end
    end
  end
end