require 'spec_helper'
require 'dredd/config'

describe Dredd::Config do
  shared_examples_for 'a configuration file' do
    describe 'reading configuration values' do
      it 'allows you to read the username' do
        expect(config.username).to eq('config-username')
      end

      it 'allows you to read the token' do
        expect(config.token).to eq('config-token')
      end

      it 'allows you to read the callback url' do
        expect(config.callback_url).to eq('http://example.com/callback')
      end

      it 'allows you to read the callback secret' do
        expect(config.callback_secret).to eq('asdfasdfasdf')
      end

      it 'allows you to read the list of repositories' do
        expect(config.repositories).to eq(
            %w(username/repository
               username/other-repository
               other-username/repository)
        )
      end

      it 'allows you to read the list of allowed usernames' do
        expect(config.allowed_usernames).to eq(%w(allowed-username))
      end

      it 'allows you to read the list of allowed emails' do
        expect(config.allowed_emails).to eq(%w(allowed-email@example.com))
      end
    end
  end

  describe 'reading from a hash' do
    let(:config_hash) { Psych.load(asset_contents('config.yml')) }
    let(:config) { described_class.new(config_hash) }

    it_behaves_like 'a configuration file'

    context 'if allowed_emails is not specified' do
      it 'returns an empty array for that value' do
        config_hash.delete('allowed_emails')
        expect(config.allowed_emails).to eq []
      end
    end

    context 'if allowed_emails is not specified' do
      it 'returns an empty array for that value' do
        config_hash.delete('allowed_usernames')
        expect(config.allowed_usernames).to eq []
      end
    end
    
    context 'if allowed_emails is nil (key with no value in YAML)' do
      it 'returns an empty array for that value' do
        config_hash['allowed_emails'] = nil
        expect(config.allowed_emails).to eq []
      end
    end

    context 'if allowed_emails is nil (key with no value in YAML)' do
      it 'returns an empty array for that value' do
        config_hash['allowed_usernames'] = nil
        expect(config.allowed_usernames).to eq []
      end
    end
  end

  describe 'reading from a file' do
    let(:config) { described_class.from_file(asset('config.yml')) }

    it_behaves_like 'a configuration file'
  end
end