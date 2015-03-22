_gCellSize = 10
_gCircleSegments = 16
_gGrid = {{}}
_gUpdateInterval = 0.1
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
end

function love.load()
	love.window.setTitle("Game Of Life")
	love.resize()
	for y = 1, #_gGrid do
		for x = 1, #_gGrid[y] do
			_gGrid[y][x] = math.random() > 0.5
		end
	end
end

function love.update(dt)
	if _t < _gUpdateInterval then
		_t = _t + dt
		return
	else
		_t = 0
	end

	ysz = #_gGrid
	xsz = #_gGrid[1]
	g = {{}}
	resizeGrid(g, xsz, ysz)
	for y = 1, ysz do
		for x = 1, xsz do
			n = neighbours(_gGrid, x, y)
			if n < 2 or n > 3 then
				g[y][x] = false
			elseif n == 3 then
				g[y][x] = true
			end
		end
	end

	_gGrid = g
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
