_gCellSize = 10
_gCircleSegments = 16
_gGrid = {{}}
_gUpdateInterval = 0.1

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

function resizeGrid(x_size_new, y_size_new)
	if x_size_new < 1 then x_size_new = 1 end
	if y_size_new < 1 then y_size_new = 1 end
	local y_size_old = #_gGrid
	local x_size_old = #_gGrid[1]
	if y_size_new ~= y_size_old then
		resizeArray(_gGrid, y_size_new, function() return {} end)
	end
	if x_size_new ~= x_size_old then
		for y=1,#_gGrid do
			resizeArray(_gGrid[y], x_size_new, function() return false end)
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
	resizeGrid(x_size_new, y_size_new)
end

function love.load()
	love.window.setTitle("Game Of Life")
	love.resize()
end

_t = 0
function love.update(dt)
	if _t < _gUpdateInterval then
		_t = _t + dt
		return
	else
		_t = 0
	end

	for y=1,#_gGrid do
		for x=1,#_gGrid[y] do
			_gGrid[y][x] = x%2 == y%2
		end
	end
end
