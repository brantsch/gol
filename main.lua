_gCellSize = 10
_gCircleSegments = 16
_gGrid = {{}}

function love.draw()
	local r = _gCellSize/2
	for y=1,#_gGrid do
		for x=1,#_gGrid[y] do
			if _gGrid[y][x] then
				love.graphics.setColor(255,255,255,255)
			else 
				love.graphics.setColor(0,0,0,255)
			end
			love.graphics.circle("fill",x*_gCellSize,y*_gCellSize,r)
		end
	end
end

function love.load()
	love.window.setTitle("Game Of Life")
	for y=1,10 do
		_gGrid[y]={}
		for x=1,10 do
			_gGrid[y][x]=false
		end
	end
end

function love.update(dt)
	for y=1,#_gGrid do
		for x=1,#_gGrid[y] do
			_gGrid[y][x] = math.random() >= 0.5
		end
	end
end

function love.resize()
end
