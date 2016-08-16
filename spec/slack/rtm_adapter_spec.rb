describe Slack::RTMAdapter do
  let(:url) { 'url' }
  let(:bot_id) { 'bot_id' }
  let(:instance) { described_class.new(url, bot_id) }
  let(:client) { instance_double(Faye::WebSocket::Client) }

  describe '#on_message' do
    subject { instance.on_message(content, client) }

    context 'when message is directed to the bot' do
      let(:content) { { 'text' => "<@#{bot_id}> message" } }
      let(:reply) { 'reply' }

      before do
        allow(Slack::Bot).to receive(:process).and_return(reply)
        allow(client).to receive(:send)
      end

      it 'sends message to be processed by the Bot' do
        expect(Slack::Bot).to receive(:process).with(content, bot_id)

        subject
      end

      it 'sends reply message to the Slack through WebSocket' do
        expect(client).to receive(:send).with(reply)

        subject
      end
    end

    context 'when message is not directed to the bot' do
      let(:content) { { 'text' => "message" } }

      it 'does not send message to be processed by the Bot' do
        expect(Slack::Bot).not_to receive(:process)

        subject
      end

      it 'does not reply message' do
        expect(client).not_to receive(:send)

        subject
      end
    end
  end

  describe '#reconnect' do
    subject { instance.reconnect }

    before do
      allow(instance).to receive(:connect)
      allow(EM).to receive(:stop)
    end

    it 'stops running EM' do
      expect(EM).to receive(:stop)

      subject
    end

    it 'tries to reconnect' do
      expect(instance).to receive(:connect)

      subject
    end
  end

  describe '#message_received' do
    subject { instance.message_received(client, msg) }

    context 'when type is known' do
      let(:msg) { OpenStruct.new(data: { type: 'hello' }.to_json) }

      it 'calls on_hello on instance' do
        content = JSON.parse(msg.data)

        expect(instance).to receive(:on_hello).with(content, client)

        subject
      end
    end

    context 'when type is unknown' do
      let(:msg) { OpenStruct.new(data: { type: 'unknown' }.to_json) }

      before do
        allow(instance).to receive(:respond_to?).with(:on_unknown).and_return(false)
        allow(instance).to receive(:respond_to?).with('on_unknown').and_return(false)
      end

      it 'does not call on_unknown on instance' do
        expect(instance).not_to receive('on_unknown')

        subject
      end
    end
  end
end
