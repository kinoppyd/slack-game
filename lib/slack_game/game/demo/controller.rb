module SlackGame
  module Game
    class Demo
      class Controller < ::SlackGame::Controller
        RIGHT = 1
        LEFT  = 2
        DOWN  = 3
        UP    = 4

        command RIGHT, /r/
        command LEFT, /l/
        command DOWN, /d/
        command UP, /u/
      end
    end
  end
end
