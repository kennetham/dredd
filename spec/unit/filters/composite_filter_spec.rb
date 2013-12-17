require 'dredd/filters/composite_filter'

require 'dredd/pull_request'

describe Dredd::CompositeFilter do
  let(:logger) { double('Logger').as_null_object }
  let(:false_filter) { double(filter?: false) }
  let(:true_filter) { double(filter?: true) }

  let(:filter) { described_class.new(logger, filters) }

  let(:pull_request) do
    Dredd::PullRequest.new(1, 'xoebus/dredd', 'xoebus', 'opened')
  end

  describe 'filter?' do
    let(:filters) { [false_filter, true_filter] }

    context 'when none of the sub-filters say we should filter' do
      let(:filters) { [false_filter, false_filter, false_filter] }

      it 'does not think we should filter' do
        expect(filter.filter?(pull_request)).to be_false
      end

      it 'logs that the pull request is not being filtered' do
        logger.should_receive(:info)
          .with('deny: none of the above filters matched')

        filter.filter?(pull_request)
      end
    end

    context 'when at least one of the sub-filters say we should filter' do
      let(:filters) { [false_filter, true_filter, false_filter] }

      it 'does think we should filter' do
        expect(filter.filter?(pull_request)).to be_true
      end

      it 'logs that the pull request is being filtered' do
        logger.should_receive(:info)
          .with('allow: at least one of the above filters matched')

        filter.filter?(pull_request)
      end
    end
  end
end
