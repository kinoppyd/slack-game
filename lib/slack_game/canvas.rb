module SlackGame
  class Canvas
    attr_reader :channel, :last_update
    attr_accessor :matrix

    def self.inherited(subclass)
      def subclass.dot(id, emoji)
        dot_map[id] = emoji
      end

      def subclass.dot_map
        @@dot ||= {}
      end
    end

    def initialize(channel, x, y)
      @slack = Slack::Client.new(token: ENV['SLACK_TOKEN'])
      @channel = resolve_channel(channel)
      @matrix = y.times.inject([]) { |acc| acc << Array.new(x) }
    end

    def draw
      decoded_matrix = encode(matrix)
      result = if last_update
        @slack.chat_update(ts: last_update, channel: channel, text: decoded_matrix)
      else
        @slack.chat_postMessage(channel: channel, text: decoded_matrix, as_user: true)
      end
      @last_update = result['ok'] ? result['ts'] : raise
    end

    private

    def encode(matrix)
      decoded = matrix.map { |l| line_decode(l) }
      decoded.join("\n")
    end

    def line_decode(line)
      decoded_line = line.map do |t|
        dot_emoji(t)
      end
      decoded_line.join
    end

    def dot_emoji(id)
      self.class.dot_map[id] || ENV['DEFAULT_SPACER'] || ':spacer:'
    end

    def resolve_channel(channel_name)
      @slack.channels_list['channels'].find { |c| c['name'] == channel_name }['id']
    end
  end
end
