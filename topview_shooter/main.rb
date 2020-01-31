require "../lib/raylib"
require "../lib/pico"
include Pico

ipf = 8  # interval per frame
nf = 2   # number of frames
max_gun_interval = 8

beam_spd = 4
beam_len = 4
beam_life = 64

@@pc = nil

class Character
  def initialize(x, y, s0)
    @x = x
    @y = y
    @s = s0
    @s0 = s0
    @d = 4
    @dx = 0
    @dy = 1
    @spd = 2
    @walking = false
  end

  def update
    # sprite
    @s = (@d - 1) + @s0
    if @walking
      @s += flr((t % (nf * ipf)) / ipf + 1) * 16
    end
    if self == @@pc and @gun
      @s += 4
    end
    # position
    if @walking
      nx = @x + @dx * @spd
      ny = @y + @dy * @spd
      if self == @@pc # or not collide_with_other_npcs(c, nx, ny, 6)
        @x = nx
        @y = ny
      end
    end
  end

  def draw
    spr(@s, @x - 4, @y - 4)
  end
end

class Player < Character
  def initialize
    super(64, 64, 1)
    @gun = false
    @gun_interval = 0
  end

  def update
    super()

    if @gun_interval > 0
      @gun_interval -= 1
    end
  end
end

class Scene
  def initialize
    @t = 0
    @objs = []

    @@pc = Player.new
    @objs << @@pc
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
