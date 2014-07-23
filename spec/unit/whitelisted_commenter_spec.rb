require 'dredd/whitelisted_commenter'

describe Dredd::WhitelistedCommenter do
  let(:whitelisted_commenter) do
    described_class.new(commenter, action_whitelist, composite_whitelist, options)
  end

  let(:commenter) { double('Commenter') }
  let(:action_whitelist) { double('ActionWhitelist') }
  let(:composite_whitelist) { double('CompositeWhitelist') }
  let(:pull_request) { double('Pull Request') }
  let(:whitelisted_template) { nil }
  let(:non_whitelisted_template) { 'Go to Jail' }

  let(:options) do
    {
      whitelisted_template: whitelisted_template,
      non_whitelisted_template: non_whitelisted_template
    }
  end

  describe 'comment' do
    context 'when the pull request action is in the list of enabled actions' do
      before do
        allow(action_whitelist).to receive(:whitelisted?).with(pull_request).and_return(true)
      end

      context 'when the pull request submitter is in the whitelist' do
        before { composite_whitelist.stub(whitelisted?: true) }

        context 'when a whitelist template has been provided' do
          let(:whitelisted_template) { 'OK, pass Go' }

          it 'makes a comment' do
            commenter.should_receive(:comment).with(pull_request, whitelisted_template)
            whitelisted_commenter.comment(pull_request)
          end
        end

        context 'when a whitelist template has not been provided' do
          let(:whitelisted_template) { nil }

          it 'does not make a comment' do
            commenter.should_not_receive(:comment)
            whitelisted_commenter.comment(pull_request)
          end
        end
      end

      context 'when the pull request submitter does not exist in the whitelist' do
        before { composite_whitelist.stub(whitelisted?: false) }

        it 'makes a comment' do
          commenter.should_receive(:comment).with(pull_request, non_whitelisted_template)
          whitelisted_commenter.comment(pull_request)
        end
      end
    end

    context 'when the pull request action is not in the list of enabled actions' do
      before do
        allow(action_whitelist).to receive(:whitelisted?).with(pull_request).and_return(false)
      end

      it 'does not make a comment' do
        commenter.should_not_receive(:comment)
        whitelisted_commenter.comment(pull_request)
      end
    end
  end
end
