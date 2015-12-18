module SlackGame
  module Game
    class Lifegame
      class Canvas < ::SlackGame::Canvas
        ARIVE = 0
        DEAD  = 1

        dot ARIVE, ENV['LIFE_ALIVE']
        dot DEAD, ENV['DEFAULT_SPACER'] || ':spacer:'
      end
    end
  end
end
