require "../lib/raylib"
require "../lib/pico"
include Pico

IPF = 8  # interval per frame
NF = 2   # number of frames
max_gun_interval = 8

beam_spd = 4
beam_len = 4
beam_life = 64

@@t = 0
@@pc = nil
@@npcs = []

def distance(x1, y1, x2, y2)
  sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2)
end

def collide_with_other_npcs(c, x, y, r)
  @@npcs.each do |other|
    if c != other && collision(x, y, other.x, other.y, r)
      return true
    end
  end
  false
end

def collision(x1, y1, x2, y2, r)
  distance(x1, y1, x2, y2) < r
end

class Character
  attr_reader :x, :y

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
      @s += flr((@@t % (NF * IPF)) / IPF + 1) * 16
    end
    if self == @@pc and @gun
      @s += 4
    end
    # position
    if @walking
      nx = @x + @dx * @spd
      ny = @y + @dy * @spd
      if self == @@pc || !collide_with_other_npcs(self, nx, ny, 6)
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
    input

    super()

    if @gun_interval > 0
      @gun_interval -= 1
    end
  end

  def input()
    # walk
    @walking = false
    if btn(0)
      @dx = -1
      @dy = 0
      @d = 1
      @walking = true
    end
    if btn(1)
      @dx = 1
      @dy = 0
      @d = 2
      @walking = true
    end
    if btn(2)
      @dx = 0
      @dy = -1
      @d = 3
      @walking = true
    end
    if btn(3)
      @dx = 0
      @dy = 1
      @d = 4
      @walking = true
    end
    # gun
    @gun = btn(4)
    if @gun and @gun_interval == 0
      bx = @x
      by = @y
      if @d == 1
        bx -= 3
        by += 1
      elsif @d == 2
        bx += 2
        by += 1
      elsif @d == 3
        bx += 2
        by -= 2
      else
        bx -= 3
      end
      add_beam(bx, by, @dx, @dy)
      @gun_interval = max_gun_interval
    end
  end
end

class Npc < Character
  def initialize(x, y)
    super(x, y, 64)
  end

  def update
    super
    follow_pc
    face_pc
  end

  def follow_pc
    @walking = true
    @spd = 0.7
    dx = @@pc.x - @x
    dy = @@pc.y - @y
    dist = distance(@@pc.x, @@pc.y, @x, @y)
    @dx = dx / dist
    @dy = dy / dist
  end

  def face_pc
    if abs(@dx) > abs(@dy)
      if @dx < 0 then @d = 1 end
      if @dx > 0 then @d = 2 end
    else
      if @dy < 0 then @d = 3 end
      if @dy > 0 then @d = 4 end
    end
  end
end

class Scene
  def initialize
    @objs = []

    @@pc = Player.new
    @objs << @@pc

    (1..2).each do |y|
      (1..7).each do |x|
        npc = Npc.new(x * 16, y * 16)
        @objs << npc
        @@npcs << npc
      end
    end
  end

  def update
    @@t += 1
    @objs.each { |e| e.update }
  end

  def draw
    cls(13) # rectfill(0,0,127,127,13)
    @objs.each { |e| e.draw }
  end
end

run(Scene.new, "topview_shooter")
