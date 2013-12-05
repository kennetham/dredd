require 'spec_helper'

require 'hashie/mash'
require 'dredd/filters/organization_filter'

describe Dredd::OrganizationFilter do
  let(:client) { double('GitHub Client') }
  let(:allowed_organizations) { [] }
  let(:filter) { described_class.new(client, allowed_organizations) }
  let(:user_organizations) { [Hashie::Mash.new(login: 'cloudfoundry')] }

  let(:author) { 'xoebus' }
  let(:pull_request) do
    Dredd::PullRequest.new(1, 'xoebus/dredd', author, 'opened')
  end

  describe '#filter?' do
    before do
      client.should_receive(:user).with(author) do
        user = double('user')
        user.stub(:organizations_url) { 'organization_url' }
        user
      end

      client.should_receive(:get).with('organization_url') do
        user_organizations
      end
    end

    context 'when allowed organizations list is empty' do
      it 'is false' do
        expect(filter.filter?(pull_request)).to be_false
      end
    end

    context 'when user has organizations' do
      context 'when user is member of an allowed organization' do
        let(:allowed_organizations) { %w{cloudfoundry pivotal} }
        it 'is true' do
          expect(filter.filter?(pull_request)).to be_true
        end

        context 'but the organization is in a different case' do
          let(:user_organizations) { [Hashie::Mash.new(login: 'CloudFoundry')] }

          it 'is true' do
            expect(filter.filter?(pull_request)).to be_true
          end
        end
      end

      context 'when user is not a member of an allowed organization' do
        let(:allowed_organizations) { %w{facebook} }

        it 'is false' do
          expect(filter.filter?(pull_request)).to be_false
        end
      end
    end

    context 'when user has no organizations' do
      let(:user_organizations) { [] }
      it 'is false' do
        expect(filter.filter?(pull_request)).to be_false
      end
    end
  end
end
