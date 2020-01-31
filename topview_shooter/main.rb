require "../lib/raylib"
require "../lib/pico"
include Pico

ipf = 8  # interval per frame
nf = 2   # number of frames
max_gun_interval = 8

beam_spd = 4
beam_len = 4
beam_life = 64

class Scene
  def initialize
    @t = 0
    @objs = []
  end

  def update
    @t += 1
    @objs.each { |e| e.update }
  end

  def draw
    cls(13) # rectfill(0,0,127,127,13)
    @objs.each { |e| e.draw }
  end
end

run(Scene.new, "topview_shooter")
