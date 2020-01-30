--- constants

ipf=8 -- interval per frame
nf=2 -- number of frames
max_gun_interval=8

beam_spd=4
beam_len=4
beam_life=64

--- variables

t=0

pc={}
beams={}
npcs={}

--- characters

function create_character(x, y, s0)
 local c={}
 c.x=x
 c.y=y
 c.s=s0
 c.s0=s0
 c.d=4
 c.dx=0
 c.dy=1
 c.spd=2
 c.walking=false
 return c
end

function update_c(c)
 -- sprite
 c.s=(c.d-1)+c.s0
 if c.walking then
  c.s+=flr((t%(nf*ipf))/ipf+1)*16
 end
 if c==pc and c.gun then
  c.s+=4
 end
 -- position
 if c.walking then
  local nx=c.x+c.dx*c.spd
  local ny=c.y+c.dy*c.spd
  if c == pc or not collide_with_other_npcs(c, nx, ny, 6) then
   c.x=nx
   c.y=ny
  end
 end
end

function draw_c(c)
 spr(c.s,c.x-4,c.y-4)
end

--- npcs

function add_npc(x, y)
 add(npcs, create_character(x, y, 64))
end

function hit_npc(x, y, r)
 for c in all(npcs) do
  if collision(x, y, c.x, c.y, r) then
   return c
  end
 end
 return nil
end

function update_npc(n)
 update_c(n)
 follow_pc(n)
 face_pc(n)
end

function follow_pc(n)
 n.walking=true
 n.spd=0.7
 local dx=pc.x-n.x
 local dy=pc.y-n.y
 local dist=distance(pc.x, pc.y, n.x, n.y)
 n.dx=dx/dist
 n.dy=dy/dist
end

function distance(x1,y1,x2,y2)
 return sqrt((x1-x2)^2+(y1-y2)^2)
end

function face_pc(n)
 if abs(n.dx)>abs(n.dy) then
  if n.dx<0 then n.d=1 end
  if n.dx>0 then n.d=2 end
 else
  if n.dy<0 then n.d=3 end
  if n.dy>0 then n.d=4 end
 end
end

function collide_with_other_npcs(c, x, y, r)
 for other in all(npcs) do
  if c~=other and collision(x, y, other.x, other.y, r) then 
   return true 
  end
 end
 return false
end

function collision(x1,y1,x2,y2)
 if distance(x1,y1,x2,y2) < 8 then
  return true
 else
  return false
 end
end

--- pc

function init_pc()
 pc=create_character(64, 64, 1)
 pc.gun=false
 pc.gun_interval=0
end

function update_pc()
 update_c(pc)
 if pc.gun_interval>0 then
  pc.gun_interval-=1
 end
end

--- beams

function add_beam(x, y, dx, dy)
 local b={}
 b.x=x
 b.y=y
 b.dx=dx
 b.dy=dy
 b.life=beam_life
 add(beams, b)
end

function update_beam(b)
 b.x+=b.dx*beam_spd
 b.y+=b.dy*beam_spd
 b.life-=1
 if b.life<=0 or b.x<0 or b.x>127 or b.y<0 or b.y>127 then
  del(beam, b)
 else
  local c = hit_npc(b.x, b.y, 3)
  if c ~= nil then
   del(npcs, c)
   del(beams, b)
   sfx(0)
   local num_ptcls=rnd()*10+5
   for i=0, num_ptcls do
    add_ptcl(b.x, b.y, b.dx, b.dy)
   end
  end
 end
end

function draw_beam(b)
 line(b.x+b.dx*beam_len, b.y+b.dy*beam_len, b.x, b.y, 8)
end

--- particle
ptcls={}

function add_ptcl(x, y, dx, dy)
 local p = {}
 p.x=x
 p.y=y
 p.r=rnd()*2
 p.vx=rnd()*2-1+dx
 p.vy=rnd()*2-1+dy
 p.life=rnd()*8+8
 p.col=9
 if rnd() > 0.6 then
  p.col=flr(rnd()*3+8)
  if p.col==9 then
   p.col=7
  end
 end
 add(ptcls,p)
end

function update_ptcl(p)
 p.x += p.vx
 p.y += p.vy
 p.life -= 1
 if p.life < 1 then
   del(ptcls, p)
 end
end

function draw_ptcl(p)
 circfill(p.x, p.y, p.r, p.col)
end

---

function input()
 -- walk
 pc.walking=false
 if btn(0) then
  pc.dx=-1
  pc.dy=0
  pc.d=1
  pc.walking=true
 end
 if btn(1) then 
  pc.dx=1
  pc.dy=0
  pc.d=2
  pc.walking=true
 end
 if btn(2) then 
  pc.dx=0
  pc.dy=-1
  pc.d=3
  pc.walking=true
 end
 if btn(3) then 
  pc.dx=0
  pc.dy=1
  pc.d=4
  pc.walking=true
 end
 -- gun
 pc.gun=btn(4)
 if pc.gun and pc.gun_interval==0 then
  local bx=pc.x
  local by=pc.y
  if pc.d==1 then
   bx-=3
   by+=1
  elseif pc.d==2 then
   bx+=2
   by+=1
  elseif pc.d==3 then
   bx+=2
   by-=2
  else
   bx-=3
  end
  add_beam(bx, by, pc.dx, pc.dy)
  pc.gun_interval=max_gun_interval
 end
end

---

function _init()
 init_pc()
 for y=1,2 do
  for x=1,7 do
   add_npc(x*16,y*16)
  end
 end
end

function _update()
 t+=1
 input()
 update_pc()
 foreach(npcs, update_npc)
 foreach(beams, update_beam)
 foreach(ptcls, update_ptcl)
end

function _draw()
 rectfill(0,0,127,127,13)
 draw_c(pc)
 foreach(npcs, draw_c)
 foreach(beams, draw_beam)
 foreach(ptcls, draw_ptcl)
end
]