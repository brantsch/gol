_gCellSize = 10
_gCircleSegments = 16
_gGrid = {{}}
_gGridB = {{}}
_gTargetFrameRate = 15
_gTargetFrameTime = 1/_gTargetFrameRate
_gPaused = false
_t = 0

function resizeArray(tbl, new_sz, cb)
	if #tbl > new_sz then
		for i=#tbl,new_sz,-1 do
			tbl[i] = nil
		end
	elseif #tbl < new_sz then
		for i=#tbl,new_sz do
			tbl[i] = cb()
		end
	end
end

function resizeGrid(grid, x_size_new, y_size_new)
	if x_size_new < 1 then x_size_new = 1 end
	if y_size_new < 1 then y_size_new = 1 end
	local y_size_old = #grid
	local x_size_old = #grid[1]
	if y_size_new ~= y_size_old then
		resizeArray(grid, y_size_new, function() return {} end)
	end
	if x_size_new ~= x_size_old then
		for y=1,#grid do
			resizeArray(grid[y], x_size_new, function() return false end)
		end
	end
end

function love.draw()
	r = _gCellSize/2
	for y=1,#_gGrid do
		for x=1,#_gGrid[y] do
			if _gGrid[y][x] then
				love.graphics.setColor(255,255,255)
			else
				love.graphics.setColor(0,0,0)
			end
			love.graphics.circle("fill",x*_gCellSize,y*_gCellSize,r)
		end
	end
end

function love.resize()
	local x_size_new = love.window.getWidth() / _gCellSize
	local y_size_new = love.window.getHeight() / _gCellSize
	resizeGrid(_gGrid, x_size_new, y_size_new)
	resizeGrid(_gGridB, x_size_new, y_size_new)
end

function love.load()
	love.window.setTitle("Game Of Life")
	love.resize()
	randomise(_gGrid)
end

function love.update(dt)
	if _gPaused then return end

	ysz = #_gGrid
	xsz = #_gGrid[1]
	g = _gGridB
	for y = 1, ysz do
		for x = 1, xsz do
			n = neighbours(_gGrid, x, y)
			g[y][x] = _gGrid[y][x] and n==2 or n==3
		end
	end

	_gGridB = _gGrid
	_gGrid = g
end

function love.keypressed(key, isrepeat)
	if key == "r" then
		randomise(_gGrid)
	elseif key == "q" then
		love.event.quit()
	elseif key == " " then
		_gPaused = not _gPaused
	end
end

function neighbours (grid, x, y)
	n = 0
	ysz = #grid
	xsz = #grid[y]
	--[[ ONE-BASED INDICES ARE HORRIBLE ]]--
	x = x - 1
	y = y - 1
	if grid[y + 1][(x+1)%xsz + 1] then n = n+1 end
	if grid[y + 1][(x-1)%xsz + 1] then n = n+1 end
	if grid[(y+1)%ysz + 1][x + 1] then n = n+1 end
	if grid[(y-1)%ysz + 1][x + 1] then n = n+1 end
	if grid[(y+1)%ysz + 1][(x+1)%xsz + 1] then n = n+1 end
	if grid[(y-1)%ysz + 1][(x-1)%xsz + 1] then n = n+1 end
	if grid[(y+1)%ysz + 1][(x-1)%xsz + 1] then n = n+1 end
	if grid[(y-1)%ysz + 1][(x+1)%xsz + 1] then n = n+1 end
	return n
end

function randomise(grid)
	for y = 1, #grid do
		for x = 1, #grid[y] do
			grid[y][x] = math.random() > 0.5
		end
	end
end

function love.run()
	if love.math then
		love.math.setRandomSeed(os.time())
		for i=1,3 do love.math.random() end
	end

	if love.event then
		love.event.pump()
	end

	if love.load then love.load(arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	repeat

		local tBefore = 0
		if love.timer then tBefore = love.timer.getTime() end

		-- Process events.
		if love.event then
			love.event.pump()
			for e,a,b,c,d in love.event.poll() do
				if e == "quit" then
					if not love.quit or not love.quit() then
						if love.audio then
							love.audio.stop()
						end
						return
					end
				end
				love.handlers[e](a,b,c,d)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end

		-- Call update and draw
		love.update(dt) -- will pass 0 if love.timer is disabled

		if love.window and love.graphics and love.window.isCreated() then
			love.draw()
			love.graphics.present()
		end

		if love.timer then 
			frameTime = love.timer.getTime() - tBefore
			sleepTime = _gTargetFrameTime - frameTime
			if sleepTime > 0 then love.timer.sleep(sleepTime) end
		end

	until false
end
