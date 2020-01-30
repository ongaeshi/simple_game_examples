require "../lib/raylib"
require "../lib/pico"
include Pico

class Scene
  def initialize
    @x = 0
  end

  def update
    @x += 1
    @x = -80 if @x > 150
  end

	def draw
		cls(1)

    (0...16).each do |i|
      (0...16).each do |j|
        if (i % 2) + (j % 2) == 1
          rectfill(i * 8, j * 8, 8, 8, 3)
        end
      end
    end

    Raylib::draw_text("Hello, World!", @x, SCREEN_HEIGHT * 0.5 - 5, 10, Raylib::Color.init(255, 163, 0, 255))
  end
end

Pico::mainloop(Scene.new, "topview_shooter")

