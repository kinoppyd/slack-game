require 'slack_game/game/demo/controller'
require 'slack_game/game/demo/canvas'

module SlackGame
  module Game
    class Demo
      def initialize(channel, x = 10, y = 10)
        @controller = Controller.new
        @canvas = Canvas.new(channel, x, y)
        @position = Position.new(0, 0, 0..9, 0..9)
        @canvas.dot_matrix[@position.y][@position.x] = Canvas::CHARACTOR
        @canvas.draw
      end

      def main_loop
        loop{
          begin
            update(@controller.take_last_command)
          rescue => e
            puts "GAME OVER #{e.message}"
            break
          end
        }
      end

      def update(cmd)
        case cmd
        when Controller::LEFT
          set_position(@position.x - 1, @position.y)
        when Controller::RIGHT
          set_position(@position.x + 1, @position.y)
        when Controller::DOWN
          set_position(@position.x, @position.y + 1)
        when Controller::UP
          set_position(@position.x, @position.y - 1)
        end
      end

      def set_position(x, y)
        @position.x = x
        @position.y = y
        matrix = @canvas.dot_matrix
        matrix = matrix.map { |n| n.map { |d| d == Canvas::CHARACTOR ? Canvas::PAINTED : d } }
        matrix[@position.y][@position.x] = Canvas::CHARACTOR
        @canvas.dot_matrix = matrix
        @canvas.draw
      end

      class Position
        attr_accessor :x, :y
        attr_reader :range_x, :range_y
        def initialize(x, y, range_x, range_y)
          @x = x
          @y = y
          @range_x = range_x
          @range_y = range_y
        end

        def x=(new_x)
          @x = range_x.include?(new_x) ? new_x : x
        end

        def y=(new_y)
          @y = range_y.include?(new_y) ? new_y : y
        end
      end
    end
  end
end
