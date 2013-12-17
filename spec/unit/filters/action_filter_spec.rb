require 'spec_helper'

require 'hashie/mash'
require 'dredd/filters/action_filter'

describe Dredd::ActionFilter do
  let(:client) { double('GitHub Client') }
  let(:enabled_actions) { [] }
  let(:filter) { described_class.new(client, enabled_actions) }
  let(:pull_request_action) { 'opened' }

  let(:author) { 'xoebus' }
  let(:pull_request) do
    Dredd::PullRequest.new(1, 'xoebus/dredd', author, pull_request_action)
  end

  describe '#filter?' do
    context 'when enabled actions list is empty' do
      it 'is false on any action' do
        expect(filter.filter?(pull_request)).to be_false
      end
    end

    context 'when enabled actions are specified' do
      let(:enabled_actions) { %w{opened reopened} }

      context 'when action is not in the list' do
        let(:pull_request_action) { 'closed' }
        it 'is true' do
          expect(filter.filter?(pull_request)).to be_true
        end
      end

      context 'when action is in the list' do
        let(:pull_request_action) { 'opened' }
        it 'is false' do
          expect(filter.filter?(pull_request)).to be_false
        end
      end
    end
  end
end
