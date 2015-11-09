module SlackGame
  class Controller

    def self.inherited(subclass)
      subclass.class_variable_set(:@@parsers, [])

      def subclass.command(command, pattern)
        parsers << InputParser.new(command, pattern)
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
      slack = Slack::Client.new(token: ENV['SLACK_TOKEN'])
      @rtm = slack.realtime
      @rtm.on(:message) do |m|
        input(m['text'])
      end
    end

    def listen
      @thread = Thread.new do
        @rtm.start
      end
      @thread.run
    end

    def input(command)
      parser = self.class.parsers.find { |p| p.match?(command) }
      @command = parser.command if parser
    end

    def take
      command = @command
      @command = nil
      command
    end

    class InputParser
      attr_reader :pattern, :command

      def initialize(command, pattern)
        @command = command
        @pattern = pattern
      end

      def match?(input)
        !! pattern.match(input)
      end
    end
  end
end
