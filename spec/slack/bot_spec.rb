describe Slack::Bot do
  let(:bot_id) { 'bot_id' }
  let(:instance) { described_class.new(content, bot_id) }

  describe '#process' do
    let(:channel) { 'channel' }
    let(:user) { 'user' }
    let(:content) { { 'channel' => channel, 'user' => user, 'text' => text } }
    subject { instance.process }

    context 'when a definition does not exist fo the query' do
      let(:text) { 'nope' }

      it 'returns the not found message' do
        message = "Sorry <@user>, but could not find any definition for *nope* :disappointed:"
        response = {type: "message", channel: "channel", text: message }

        expect(subject).to eq response.to_json
      end
    end

    context 'when a definition exists fo the query' do
      let(:text) { 'Array#first' }

      it 'returns the definition message' do
        message = '<@user>, here is the documentation for:\n\n*Array#first*\n'
        message += '\n\n(from ruby core)\n----------------------------------'
        message += '--------------------------------------------\n  ary.'
        message += 'first'
        
        expect(subject).to include(message)
      end
    end

    context 'when definition has bold characters' do
      let(:text) { 'off' }

      it 'removes the bold modifiers from the definition message' do
        message = "Implementation from Tracer"

        expect(subject).to include(message)
      end
    end

    context 'when definition has underlined characters' do
      let(:text) { 'String#split' }

      it 'removes the underline modifiers from the definition message' do
        message = "If pattern is a Regexp, str"

        expect(subject).to include(message)
      end
    end
  end
end
