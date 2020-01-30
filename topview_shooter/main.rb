require "../lib/raylib"
require "../lib/pico"
include Pico

class Scene
  def initialize
    @x = 1
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

    s = 0
    (0...16).each do |i|
      (0...16).each do |j|
        spr(s, j * 8, i * 8)
        s += 1
      end
    end

    print("Hello, World!", @x, SCREEN_HEIGHT * 0.5 - 5, 7)

    a = (0..5).select { |e| btn(e) }
    print(a.to_s, 0, 88, 7)
  end
end

Pico::mainloop(Scene.new, "topview_shooter")
