module SlackGame
  module Game
    class Demo
      class Canvas < ::SlackGame::Canvas
        CHARACTOR = 0
        PAINTED   = 1
        SPACER    = 2

        dot CHARACTOR, ENV['DEMO_CHARACTOR']
        dot PAINTED, ENV['DEMO_PAINTED']
        dot SPACER, ':spacer:'
      end
    end
  end
end
