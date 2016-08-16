describe Slack::Authenticator do
  let(:instance) { described_class.new }

  before do
    ENV['SLACK_URL'] = 'https://channel.slack.com'
    ENV['SLACK_TOKEN'] = 'xoxb-69207542418-QyIlDLz8iNdwXKtMykvx6Db7'
  end

  describe '#authenticate' do
    subject { instance.authenticate }

    before do
      allow(HTTParty).to receive(:get)
    end

    it 'makes a request to Slack Channel' do
      url = "https://channel.slack.com/api/rtm.start?token=xoxb-69207542418-QyIlDLz8iNdwXKtMykvx6Db7"
      
      expect(HTTParty).to receive(:get).with(url)

      subject
    end

    it 'returns a Slack::Authenticator instance' do
      expect(subject).to be_a(described_class)
    end
  end

  describe '#bot_id' do
    subject { instance.bot_id }

    context 'when authentication is successful' do
      before do
        allow(instance).to receive(:body).and_return({ 'ok' => true, 'self' => { 'id' => 1 } })
      end

      it 'returns the bot user id' do
        expect(subject).to eq 1
      end
    end

    context 'when authentication fails' do
      before do
        allow(instance).to receive(:body).and_return({ 'ok' => false })
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '#error' do
    subject { instance.error }

    context 'when authentication is successful' do
      before do
        allow(instance).to receive(:body).and_return({ 'ok' => true })
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'when authentication fails' do
      before do
        allow(instance).to receive(:body).and_return({ 'ok' => false, 'error' => 'invalid_auth' })
      end

      it 'returns the error message' do
        expect(subject).to eq 'invalid_auth'
      end
    end
  end

  describe '#ws_url' do
    subject { instance.ws_url }

    context 'when authentication is successful' do
      before do
        allow(instance).to receive(:body).and_return({ 'ok' => true, 'url' => 'url' })
      end

      it 'returns the WebSocket URL' do
        expect(subject).to eq 'url'
      end
    end

    context 'when authentication fails' do
      before do
        allow(instance).to receive(:body).and_return({ 'ok' => false })
      end

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '#success?' do
    subject { instance.success? }

    context 'when authentication is successful' do
      before do
        allow(instance).to receive(:body).and_return({ 'ok' => true })
      end

      it 'returns true' do
        expect(subject).to be_truthy
      end
    end

    context 'when authentication fails' do
      before do
        allow(instance).to receive(:body).and_return({ 'ok' => false })
      end

      it 'returns false' do
        expect(subject).to be_falsey
      end
    end
  end
end
