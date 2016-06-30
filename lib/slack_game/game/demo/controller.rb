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
        reaction RIGHT, 'point_right'
        reaction LEFT, 'point_left'
        reaction DOWN, 'point_down'
        reaction UP, 'point_up'
      end
    end
  end
end
