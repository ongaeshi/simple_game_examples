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

    circfill(64, 64, 4, 8)

    print("Hello, World!", @x, SCREEN_HEIGHT * 0.5 - 5, 7)
    print("rnd(2) #{rnd(2)}", 0, 72, 7)
    print("sqrt(3) #{sqrt(3)}", 0, 80, 7)
    print("abs(-10) #{abs(-10)}", 0, 88, 7)
    print("flr(5.9) #{flr(5.9)} flr(-5.2) #{flr(-5.2)}", 0, 96, 7)

    a = (0..5).select { |e| btn(e) }
    print(a.to_s, 0, 112, 7)

    line(63, 0, 126, 63, 8)
    line(126, 63, 63, 126, 8)
    line(63, 126, 0, 63, 8)
    line(0, 63, 63, 0, 8)

    (1..8).each do |x|
      line(rnd(128), rnd(128), rnd(128), rnd(128), 7)
    end
  end
end

run(Scene.new, "topview_shooter")
