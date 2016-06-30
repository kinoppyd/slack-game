module SlackGame
  class Controller

    def self.inherited(subclass)
      subclass.class_variable_set(:@@parsers, [])

      def subclass.command(command, pattern)
        parsers << InputParser.new(command, pattern)
      end

      def subclass.reaction(command, emoji)
        parsers << ReactionParser.new(command, emoji)
      end

      def subclass.parsers
        self.class_variable_get(:@@parsers)
      end
    end

    def initialize
      init
      listen
    end

    def init
      @rtm = Slack::RealTime::Client.new
      @rtm.on(:message) { |m| input(m) }
      @rtm.on(:reaction_add) { |m| input(m) }
      @rtm.on(:reaction_removed) { |m| input(m) }
    end

    def listen
      @thread = Thread.new do
        @rtm.start!
      end
      @thread.run
    end

    def input(message)
      matched = parsers.find { |p| p.match?(message) }
      @command = matched.command if matched
    end

    def take_last_command
      command = @command
      @command = nil
      command
    end

    def parsers
      self.class.parsers
    end

    class Parser
      attr_reader :command
    end

    class InputParser < Parser
      attr_reader :pattern

      def initialize(command, pattern)
        @command = command
        @pattern = pattern
      end

      def match?(message)
        !! pattern.match(message['text'])
      end
    end

    class ReactionParser < Parser
      attr_reader :emoji, :any

      def initialize(command, emoji)
        @command = command
        @emoji = chomp(emoji)
      end

      def match?(message)
        return false unless ['reaction_add', 'reaction_removed'].include?(message['type'])
        message['reaction'] == @emoji
      end

      private

      def chomp(emoji)
        if emoji.start_with?(':') && emoji.end_with?(':')
          emoji[1..-2]
        else
          emoji
        end
      end
    end
  end
end
