require 'dredd/filters/composite_filter'

require 'dredd/pull_request'

describe Dredd::CompositeFilter do
  let(:false_filter) { double(filter?: false) }
  let(:true_filter) { double(filter?: true) }

  let(:filter) { described_class.new(filters) }

  let(:pull_request) do
    Dredd::PullRequest.new(1, 'xoebus/dredd', 'xoebus', 'opened')
  end

  describe 'filter?' do
    let(:filters) { [false_filter, true_filter] }

    it 'asks all of the sub-filters what it should do' do
      false_filter.should_receive(:filter?).with(pull_request)
      true_filter.should_receive(:filter?).with(pull_request)

      filter.filter?(pull_request)
    end

    context 'when none of the sub-filters say we should filter' do
      let(:filters) { [false_filter, false_filter, false_filter] }

      it 'does not think we should filter' do
        expect(filter.filter?(pull_request)).to be_false
      end
    end

    context 'when at least one of the sub-filters say we should filter' do
      let(:filters) { [false_filter, true_filter, false_filter] }

      it 'does think we should filter' do
        expect(filter.filter?(pull_request)).to be_true
      end
    end
  end
end