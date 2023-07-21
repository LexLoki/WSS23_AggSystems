local Camera = require 'camera'
local camera

local game = {onQuit = nil}

local rule = {0, 1, 0, 0, 1, 1, 1, 1}

local cellList = {}
local timer = 0

local CTYPE = {
    ON = 1, OPEN = 2, OFF = 3
}

local baseOpenColor = {1, 0, 1}

local colors = {
    {1, 1, 1},
    {1, 0, 1},
    {0, 0, 0}
}

local adj = {
    {1,0}, {-1,0}, {0,1}, {0,-1},
    {1,1}, {1,-1}, {-1,1}, {-1, -1}
}

local W,H
local bounds = {{0,0},{0,0}}
local cellSize = {50, 50}
local cellSpacing = 0.06
local fadeDuration = 0.3

local fadingTimer = {}

local drawCall, drawRect

local function query(cx, cy)
    return (cellList[cx] or {})[cy]
end

local function n_neighbors(cx, cy)
    local count = 0
    for i=1,#adj do
        if query(cx+adj[i][1], cy+adj[i][2]) == CTYPE.ON then
            count = count+1
        end
    end
    return count
end

local function valid_open(cx, cy)
    return rule[n_neighbors(cx, cy)]==1
end

local function addCell(cx, cy, type)
    if not cellList[cx] then cellList[cx] = {} end
    cellList[cx][cy] = type
    if type ~= CTYPE.ON then return end
    for _,dir in ipairs(adj) do
        local adcx, adcy = cx + dir[1], cy + dir[2]
        if query(adcx, adcy) ~= CTYPE.ON then
            addCell(adcx, adcy, valid_open(adcx, adcy) and CTYPE.OPEN or CTYPE.OFF)
        end
    end
end

local function addRandom()
    local cells = {}
    for row,rowList in pairs(cellList) do
        for col, ctype in pairs(rowList) do
            if ctype == CTYPE.OPEN then table.insert(cells, {row,col}) end
        end
    end
    if #cells == 0 then return end
    local cell = cells[math.random(#cells)]
    addCell(cell[1], cell[2], CTYPE.ON)
end

function game.load()
    W,H = love.graphics.getDimensions()
end

function game.start(value)
    cellList = {}
    camera = Camera.new(0,0,{W/2,H/2})
    addCell(0,0,CTYPE.ON)
    addCell(1,1,CTYPE.ON)
    for i=3,value do
        addRandom()
    end
end

function game.mousemoved(x,y,dx,dy)
    if not love.mouse.isDown(3) and not love.mouse.isDown(2) then return end
    camera:translate(-dx/camera.zoom,-dy/camera.zoom)
end

function game.mousepressed(x, y, button)
    x,y = camera:toWorld(x-W/2,y-H/2)
    local col = math.floor(x/cellSize[1])
    local row = math.floor(y/cellSize[2])
    if button == 1 then
        if not cellList[row] or not cellList[row][col] then return end
        if cellList[row][col] == CTYPE.OPEN then
            addCell(row, col, CTYPE.ON)
        end
    end
end

function game.update(dt)
    timer = timer+dt
    local t = 0.175+0.175*math.cos(2*timer)
    for i=1,3 do
        colors[CTYPE.OPEN][i] = (1-t)*baseOpenColor[i] + t*colors[CTYPE.ON][i]
    end
    --[[
    for i=#fadingTimer,1,-1 do
        local cell = fadingTimer[i]
        time = time+dt
        if time+dt>fadingTimer then table.remove(fadingTimer, cell)
        else fadingTimer[cell] = time end
    end]]
end

function game.keypressed(key)
    if key == 'escape' then
        game.onQuit()
        return
    end
end

function drawRect(row, col, ctype)
    love.graphics.setColor(colors[ctype])
    local ft = fadingTimer[cellList[row][col]]
    local pt = ft and ft/fadingTimer or 1
    love.graphics.rectangle('fill',
        (col+cellSpacing+(0.5-cellSpacing)*(1-pt))*cellSize[1],
        (row+cellSpacing+(0.5-cellSpacing)*(1-pt))*cellSize[2],
        cellSize[1]*(1-cellSpacing*2)*pt,
        cellSize[2]*(1-cellSpacing*2)*pt,
        cellSize[1]/20,
        cellSize[2]/20
    )
end

function drawCall()
    for row,rowList in pairs(cellList) do
        for col,ctype in pairs(rowList) do
            drawRect(row, col, ctype)
        end
    end
end

function game.draw()
    love.graphics.push()
    love.graphics.translate(W/2,H/2)
    love.graphics.setColor(1,1,1)
    camera:draw(drawCall)
    love.graphics.pop()
    love.graphics.setColor(1,1,1)
    love.graphics.print('Click to kill all pink cells\nPress ESC to give up - return to menu\nPress and drag wheel/right mouse button to pan')
end

return game