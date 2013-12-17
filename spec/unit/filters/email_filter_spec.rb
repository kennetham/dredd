require 'spec_helper'

require 'hashie/mash'
require 'dredd/filters/email_filter'

describe Dredd::EmailFilter do
  let(:client) { double('GitHub Client') }
  let(:filter) { described_class.new(client, allowed_emails) }

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

      context 'when the pull request email is in the allowed emails' do
        let(:allowed_emails) { %w(xoebus@xoeb.us) }

        it 'is true' do
          expect(filter.filter?(pull_request)).to be_true
        end
      end

      context 'when the pull request email is not in the allowed emails' do
        let(:allowed_emails) { %w(random@xoeb.us) }

        it 'is false' do
          expect(filter.filter?(pull_request)).to be_false
        end
      end
    end

    context 'when the user does not have an email set' do
      let(:email) { nil }
      let(:allowed_emails) { %w(xoebus@xoeb.us) }

      it 'does not filter the user (since we can not tell if valid user)' do
        expect(filter.filter?(pull_request)).to be_false
      end
    end
  end
end
