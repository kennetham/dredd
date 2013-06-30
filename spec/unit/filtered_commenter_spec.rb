require 'dredd/filtered_commenter'

describe Dredd::FilteredCommenter do
  let(:commenter) { double('Commenter') }
  let(:filter) { double('Filter') }
  let(:pull_request) { double('Pull Request') }

  let(:filtered_commenter) { described_class.new(commenter, filter) }

  describe 'filtering when we should comment' do
    context 'when filter#should_filter? returns true' do
      before do
        filter.stub(filter?: true)
      end

      it 'does not call through' do
        commenter.should_not_receive(:comment)

        filtered_commenter.comment(pull_request)
      end
    end

    context 'when the user is not in the filter list' do
      before do
        filter.stub(filter?: false)
      end

      it 'calls through' do
        commenter.should_receive(:comment).with(pull_request)
        filtered_commenter.comment(pull_request)
      end
    end
  end
end