pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- eeg game

function _init()
 game = create_gamestate()

 cls()
 print("✽ brain runner 0.01 alpha")
 print("generating traces...")
	traces={}
	traces.frames_to_load=15
	traces.line_len=128 * traces.frames_to_load
	traces.speed=2
	traces.min_gap=40
	
 lns=make_lines(traces.min_gap,
  traces.line_len)
 player = create_player()
 
 music(1)
 if(game.show_attract) then
   scrn_attract_init()
 end
end

function _update()
 game:inc_tick()
	if (game.state==1) then
		player:update()
	end
end

function _draw()
 if (game.state == 1) then
 	cls() --clear screen
 	player:draw()
 	
 	--if(game.tick * game.speed < tracelines.line_len - 128) then
 		draw_lines(lns, game.tick * traces.speed)
 	--end
	end
end



-->8
-- game state
function create_gamestate()
 local game={}
 
	game.state = 1 // 0 = over, 1 running, 2 = paused
	game.difficulty = 1 // easy
	game.speed = game.difficulty
 game.lives = 3 
 game.max_lives = 3
 game.score = 0
 game.high_score = 0
 game.show_attract = false
 game.level = 1
 game.tick = 0

	game.inc_tick = function(self)
		self.tick += 1
	end
 
 game.add_life = function(self)
 	self.lives += 1
 	if self.lives > self.max_lives then
 		self.lives = self.max_lives
 	end
 end
 
 game.start = function(self)
 	self.reset() 
 	self.show_attract = false
		self.state = 1
	end
	
	game.end_game = function(self)
		self.state = 2
		self.lives = 0
	end
 
 game.lose_life = function(self)
	 self.lives -= 1
	 if (self.lives <=0) then 
	 	self.player_dies()
	 end
	end
	
	game.player_dies = function(self)
		self.state = 2
		// player death sound/music
	end
	
	game.update_high_score = function(self)
		if (self.score > self.high_score) then
			self.high_score = self.score
		end
	end
 
 return game
 
end



-->8
-- game screens

function scrn_attract_init()
	scrn_attract()
end

function scrn_attact()
	cls()
	print ("welcome to flappy brain")
	print ("press any key")
end


	
-->8
-- tracelines
function make_lines(min_gap, len)
    top_line = {}
    add(top_line, { x = 0, y = rnd(127 - min_gap) })
    for i = 1, len do
        new_y = min(max(0, rnd(4) - 2 + top_line[count(top_line)].y), 127 - min_gap)
        new_pnt = { x = i, y = new_y }
        add(top_line, new_pnt)
    end

    bottom_line = {}
    add(bottom_line, { x = 0, y = top_line[1].y + min_gap })
    for i = 1, len do
        new_y = min(max(top_line[i].y + min_gap, rnd(4) - 2 + bottom_line[count(bottom_line)].y), 127)
        new_pnt = { x = i, y = new_y }
        add(bottom_line, new_pnt)
    end

    return { top = top_line, bottom = bottom_line }
end

function draw_line(ln, start)
    prev_x = ln[start].x - start
    prev_y = ln[start].y
    
    for i = start, start + 127 do
        line(prev_x, prev_y, ln[i].x - start, ln[i].y)
        prev_x = ln[i].x - start
        prev_y = ln[i].y
    end
end

function draw_lines(lns, start)
    draw_line(lns.top, start)
    draw_line(lns.bottom, start)
end
-->8
-- player

function create_player()
	local player={}
	local midpoint=(bottom_line[1].y - top_line[1].y) / 2
	midpoint += top_line[1].y
 player.x=24
 player.y=midpoint
 player.sprite=0
	player.damage=0
 
 player.update = function(self)
	 if (player:hitcheck()==false) then
		 if (btn(0)) self.x=max(0,self.x-1) --left
		 if (btn(1)) self.x=min(111,self.x+1) --right
		 if (btn(2)) self.y=max(0,self.y-1) --up
		 if (btn(3)) self.y=min(243-player.botrgt.y,self.y+1) --down
  end
		player:update_coordinates()		 
	end
  
	player.update_coordinates = function(self)
		player.toplft = {x= player.x+1, 
	                  y= player.y+1}
	 player.botrgt = {x= player.x+14,
	                  y= player.y+11}
	end
	
 
 player.hitcheck=function(self)
  local p=0
  local collision=false
 	for i=self.toplft.x, self.toplft.x+15 do
			p = pget(i, self.toplft.y-1)	 
 		if (p>0)	then  
 			self.damage += 1
 			self.y += 1
 			collision=true
 			break
 		end
 	end
 	
		for i=self.botrgt.x-15, self.botrgt.x do
			p = pget(i, self.botrgt.y+1)	 
 		if (p>0)	then  
 			self.damage += 1
 			self.y -= 1
 			collision=true
 			break
 		end
 	end

		if (self.y<0) self.y=0
		if (self.y>112) self.y=112 	 	
 	return collision
 end
 
 player.draw = function(self)
  spr(0,self.x,self.y,2,2)
  print("damage:"..self.damage,25,5)
 end
 
 player:update_coordinates()

 return player
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000ffeef00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000f0e0002e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000fee000fe02e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00fe00fe0ee002e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000f0ee2e0ee0200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0fe0eee0eee20e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0eee02200220fee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00e0f00f000fee200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00eee0fee0eee2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000020eeee0e20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000e0f00f000fee20000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000eee0fee0eee200000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000020eeee0e2000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000022222000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006060
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006660
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060600
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000600000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000606000000006000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000606000006006000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000600006660000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000606000606060600000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006060000060660000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000600000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006600000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000600006006000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000006606006606060006660000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000006060660660006660000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000660000000000006000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000006000000000000000000000006000006000000000000000000000000000000000000000000000
00000000000000000000000000060000000000000000000000006600000000000000000000060600006000000000000000000000000000000000000000000000
00000000000000000000000000066006066000000000006000660600060000000000000000600600060000000000000000000000000000000000000000000000
00000000000000000000000000606060600600000000060660600066606006006600000000600066060000000000000000000000000000000000000000000000
00000000000000000000000606000660000600000666600006000000000660660060000006000000600000000000000000000000000000000000000000000000
00000000000000000000000660000600000060000600000000000000000000600066060060000000000000000000000000000000000000000000000000000000
60606660060000000000006000000000000006006000000000000000000000000000606060000000000000000000000000000000000000000000000000000000
06060006066066000000060000000000000000606000000000000000000000000000006600000000000000000000000000000000000000000000000000000000
00000006606600666000600000000000000000660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000600600600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000606000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000ffeef0000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000f0e0002e000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000fee000fe02e00000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000fe00fe0ee002e0000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000f0ee2e0ee020000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000fe0eee0eee20e00000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000eee02200220fee0000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000e0f00f000fee20000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000eee0fee0eee200000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000020eeee0e2000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000022222000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000006600000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000660060000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000006000006000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000060000006060000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000066600000000666066000000000000000000000000000000000
00000000000000000000000000000000000000000000000000060000000000000000000000000600000000000600600600000000000000000000000000000000
00066000000000000000000000000000000000000000000000606600000000000000000000066000000000000000000600000000000000000000000000000000
06600606000000000000000000000000000000000000000006000066606000660066000000600000000000000000000060600000000000000000000000000000
60000660606000000000000000000000000000000000000006000060060606006600660606000000000000000000000006666000000000006000000066000000
60000000066600000000000000000000000000000000000060000000000060000000006060000000000000000000000006000600666000006600000060600000
00000000060660000000000000000000000000000000000600000000000000000000000000000000000000000000000000000606000600060060000600660000
00000000000006000060000000000000000060000000000600000000000000000000000000000000000000000000000000000060000606060006060600006600
00000000000000600066000006060000000066000000606000000000000000000000000000000000000000000000000000000000000060600000606000000060
00000000000000060600600060606600006606606066060000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006600066600006060006000060600000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000006000000000000006060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
01100000021430e155021620211202112021120214302314090430905309062090220c0410c0530c0630c02207044070550736407012070120731407012070120c0430c0550c0630c0220e0330e0550e0620e025
011000001a757027471a737027271a717027171a737027171a717027171a717027171c757047471c7370472718757007471873700727187170071718737007171f757077471f737077271f717077171f73707717
011000001f757077471c737047271c717047171c737047171c757047471a737027271a717027171a737027171a710027100000000000000000000000000000000000000000000000000000000000000000000000
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000003951034510325103551039510345103551037510395103551037510345103951034510355103751039510345103051034510395103451035510375103951035510375103451039510345103551037510
011000002613026000260202133026010210202413021010240201f330240101f020211301f01021010000001a130000001a020133301a010130201513013010150200c330150100c020181300c0101801000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000000000000000002162500000000002162500000000000733300000000001a6251a600000001a600000001a600000001a62500000000002d62500000000000723300000000001a625000000000000000
011000000217300000000002662500000000003962500000073230760002173000001a6251a600000001a600000001a600000001a62500000000002d6251a6251f2230000002173000001a625000000217300000
__music__
00 00414a55
00 004b4a55
00 00014344
00 00024344
00 00014344
00 00024344
00 00014314
00 00024314
00 00014314
00 00024314
01 40014a14
00 41020b15
00 00010b15
00 00020b15
00 000a0b14
00 000a0b15
00 00010b41
00 00020b14
00 00010a0b
02 00020a0b

