pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- _init, _update, _draw
function _init()
 game = create_gamestate()
 player = create_player()
 
	tracelines={}
	tracelines.frames_to_load=10
	tracelines.line_len=128 * tracelines.frames_to_load
	tracelines.speed=2
	
 lns=make_lines(40, tracelines.line_len)
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
 		draw_lines(lns, game.tick * tracelines.speed)
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
 player.x=64
 player.y=64
 player.sprite = 0
 
 player.update = function(self)
	 if (btn(0)) self.x-=1 --left
	 if (btn(1)) self.x+=1 --right
	 if (btn(2)) self.y-=1 --up
	 if (btn(3)) self.y+=1 --down
 end
 
 player.draw = function(self)
 	spr(0,self.x,self.y,2,2)
 end
 
 return player
end
__gfx__
00000000000000000000000077777777777777777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000ffeef0000f0000fee77777777777777777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000f0e0002e0002e00000077777777777777777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000
000fee000fe02e0002e000fe77777777777777777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00fe00fe0ee002e0002e00ee77777777777777777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000
0000f0ee2e0ee020ee0202e077777777777777777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000
0fe0eee0eee20e0020e00eee77770000000000777777777700000000000000000000000000000000000000000000000000000000000000000000000000000000
0eee02200220fee00fee00227000ffee0ffe0f077777777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00e0f00f000fee20000fee200ffee0000ee2eee00777777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00eee0fee0eee200e0eee200eeee0ffee020000ef077777700000000000000000000000000000000000000000000000000000000000000000000000000000000
000020eeee0e2000ee0e20000000feeee20fffe0e207777700000000000000000000000000000000000000000000000000000000000000000000000000000000
000002222200000022000000ffe0e0eee0feeee0efe0777700000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000fee0e0ee20eeeee000e0077700000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000770ffe20e0e2e0ee0eeeeee0ee0ee07700000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000770fee0f0ee20eee0eee0ee0eee0e07700000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000770ee0fe0ee20eee2eee0e0eeee02f0700000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000770020fe0eee0eee2eee0eeeeee2020700000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000070ff00fee0ee0eeeeeee0eeee0e0f07700000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000070fee0fe2e0e0eeee22202ee02eee07700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000007022ee0e2eeee0222000f0202eeee20700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000007700e0efff2ee2000fffee02eee2e20700000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000770feeeee22220ee0feeee0ee22e207700000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000077022220effe0fee0eeeee0eeee2077700000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000077700002eeee0eeee020eeeeee20777700000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000077777702222e0eeeee0e02ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000777777700000eeeeeeee20220000000ffeef0000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000077777777777022022222070000000f0e0002e000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000777777777777007000007777000fee000fe02e00000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000077777777777777777777777700fe00fe0ee002e0000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000007777777777777777777777770000f0ee2e0ee020000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000007777777777777777777777770fe0eee0eee20e00000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000007777777777777777777777770eee02200220fee0000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000e0f00f000fee20000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000eee0fee0eee200000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000020eeee0e2000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000022222000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000000000000001605016050180501a0501d05021050250502505022050130500000000000000000000010050000000000000000000000000000000000000605000000000000000000050000000000000000
