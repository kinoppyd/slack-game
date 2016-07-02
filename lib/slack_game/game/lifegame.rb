require 'slack_game/game/lifegame/canvas'

module SlackGame
  module Game
    class Lifegame
      def initialize(channel, size = 10)
        @canvas = Canvas.new(channel, size, size)
        @field = Field.new(size)
        @canvas.dot_matrix = @field.to_display
        @canvas.draw
      end

      def main_loop
        loop{
          begin
            update
          rescue => e
            puts "GAME OVER #{e.message}"
            break
          end
        }
      end

      def update
        @canvas.dot_matrix = @field.next.to_display
        @canvas.draw
      end

      class Field
        attr_reader :field
        def initialize(size)
          @size = size
          @field = Array.new(size) { Array.new(size) { rand < 0.3 ? Cell.new(true) : Cell.new(false) } }
        end

        def next
          next_field = Array.new(@size) { Array.new(@size) }
          @field.each_with_index do |line, outer_index|
            line.each_with_index do |cell, inner_index|
              next_field[outer_index][inner_index] = cell.next_gen(arround_cells(outer_index, inner_index))
            end
          end
          @field = next_field
          self
        end

        def to_display
          @field.map do |l|
            l.map do |d|
              d.alive? ? Canvas::ARIVE : Canvas::DEAD
            end
          end
        end

        private

        def arround_cells(row, col)
          cells = []
          [row-1, row, row+1].each do |n|
            [col-1, col, col+1].each do |m|
              if (n!=row || m!=col) && 0 <= n && n < @size && 0 <= m && m < @size
                cells << @field[n][m]
              end
            end
          end
          cells
        end
      end

      class Cell
        def initialize(alive)
          @alive = !! alive
        end

        def alive?
          !! @alive
        end

        def next_gen(arround_cells)
          alives =  arround_cells.select(&:alive?).size
          if alive?
            (alives <= 1 || 4 <= alives) ?  Cell.new(false) : Cell.new(true)
          else
            alives == 3 ? Cell.new(true) : Cell.new(false)
          end
        end
      end
    end
  end
end
