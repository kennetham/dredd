require 'spec_helper'

require 'hashie/mash'
require 'dredd/filters/domain_filter'

describe Dredd::DomainFilter do
  let(:client) { double('GitHub Client') }
  let(:filter) { described_class.new(client, allowed_domains) }

  let(:author) { 'xoebus' }
  let(:pull_request) do
    Dredd::PullRequest.new(1, 'xoebus/dredd', author, 'opened')
  end

  describe '#filter?' do
    before do
      client.should_receive(:user).with(author).and_return(
          Hashie::Mash.new(email: email)
      )
    end

    context 'when the user does have an email set' do
      let(:email) { 'xoebus@xoeb.us' }

      context 'when the pull request domain is in the allowed domains' do
        let(:allowed_domains) { %w(xoeb.us) }

        it 'is true' do
          expect(filter.filter?(pull_request)).to be_true
        end
      end

      context 'when the pull request domain is not in the allowed domains' do
        let(:allowed_domains) { %w(google.com) }

        it 'is false' do
          expect(filter.filter?(pull_request)).to be_false
        end
      end
    end

    context 'when the user does not have an email set' do
      let(:email) { nil }
      let(:allowed_domains) { %w(xoeb.us) }

      it 'does not filter the user (since we can not tell if valid user)' do
        expect(filter.filter?(pull_request)).to be_false
      end
    end
  end
end
