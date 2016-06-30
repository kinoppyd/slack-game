module SlackGame
  class Canvas
    attr_reader :channel
    attr_accessor :dot_matrix

    def self.inherited(subclass)
      subclass.class_variable_set(:@@dot, {})

      def subclass.dot(id, emoji)
        self.dot_map[id] = emoji
      end

      def subclass.dot_map
        self.class_variable_get(:@@dot)
      end
    end

    def initialize(channel, x, y)
      Slack.configure do |conf|
        conf.token = ENV['SLACK_TOKEN']
      end
      @slack = Slack::Web::Client.new
      @channel = resolve_channel(channel)
      @dot_matrix = y.times.inject([]) { |acc| acc << Array.new(x) }
    end

    def draw
      emoji_matrix = dot2emoji(dot_matrix)
      result = if @last_update
        @slack.chat_update(ts: @last_update, channel: channel, text: emoji_matrix)
      else
        @slack.chat_postMessage(channel: channel, text: emoji_matrix, as_user: true)
      end
      @last_update = result['ok'] ? result['ts'] : raise
    end

    private

    def dot2emoji(matrix)
      matrix.map { |l| line_convert(l) }.join("\n")
    end

    def line_convert(line)
      line.map { |t| convert(t) }.join
    end

    def convert(id)
      self.class.dot_map[id] || ENV['DEFAULT_SPACER'] || ':spacer:'
    end

    def resolve_channel(channel_name)
      @slack.channels_list['channels'].find { |c| c['name'] == channel_name }['id']
    end
  end
end
