_gCellSize = 10
_gCircleSegments = 16
_gGrid = {{}}

function resizeGrid(v, h)
	nh = h/_gCellSize
	nv = v/_gCellSize
	cv = #_gGrid
	ch = #(_gGrid[1])
	if nv < 1 then nv = 1 end
	if nh < 1 then nh = 1 end
	if cv < nv then
		for cv = cv, nv do
			_gGrid[cv] = {}
		end
	elseif cv > nv then
		for cv = cv, nv, -1 do
			_gGrid[cv] = nil
		end
	end
	for v = 1, nv do
		if ch < nh then
			for ch = ch, nh do
				_gGrid[v][ch] = false
			end
		elseif ch > nh then
			for ch = ch, nh, -1 do
				_gGrid[v][ch] = nil
			end
		end
	end
end

function love.draw()
	r = _gCellSize/2
	for y,line in pairs(_gGrid) do
		for x,cell in pairs(_gGrid[y]) do
			if cell then
					love.graphics.setColor(0xFF,0xFF,0xFF,0xFF);
			else
					love.graphics.setColor(0, 0, 0, 0xFF);
			end
			love.graphics.circle("fill", r, (x-1)*_gCellSize, (y-1)*_gCellSize, _gCircleSegments)
		end
	end
end

function love.load()
	love.window.setTitle("Game Of Life")
	resizeGrid(love.window.getHeight(), love.window.getWidth())
end

function love.update(dt)
	for y = 1, #_gGrid do
		for x = 1, #_gGrid[y] do
			_gGrid[y][x] = math.random() <= 0.5
		end
	end
end

function love.resize()
	resizeGrid(love.window.getHeight(), love.window.getWidth())
end
