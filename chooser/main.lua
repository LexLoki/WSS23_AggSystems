local Camera = require 'camera'
local Parser = require 'parser'
local camera

local canvas

local cellList = {}


local CTYPE = {
    ON = 1, OPEN = 2, OFF = 3
}

local colors = {
    {255, 255, 255},
    {255, 0, 255},
    {0, 0, 0}
}

local adj = {
    {1,0}, {-1,0}, {0,1}, {0,-1},
    {1,1}, {1,-1}, {-1,1}, {-1, -1}
}

--local rule = {0,0,1,0,0,1,1,1}
--latest
--local rule = {0,0,1,0,0,0,1,1}
local rule = {0,1,0,0,1,1,1,1}
rule[0] = 0

local W,H

local bounds = {{0,0},{0,0}}
local cellSize = {50, 50}
local cellSpacing = 0.06

local auto = true

local timer = 2
local timer_speed = 1
local iteration = 1

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
    --love.graphics.setCanvas(canvas)
    --drawRect(cx, cy, type)
    --love.graphics.setCanvas()
    if type ~= CTYPE.ON then return end
    iteration = iteration+1
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

local function reset()
    iteration,auto,cellList = 1,false,{}
end

local function loadConfig(crule, cinitial)
    if crule then
        local argRule = Parser.parse_rule(tonumber(crule))
        for i=1,#rule do
            rule[i] = argRule[i] or 0
        end
    end
    local cells = Parser.parse_initial(cinitial)
    for _,cell in ipairs(cells) do
        addCell(cell[1], cell[2], CTYPE.ON)
    end
end

function love.load(arg)
    love.window.setMode(1800,1000)
    W,H = love.graphics.getDimensions()
    reset()
    if arg[1] then
        loadConfig(arg[1], arg[2])
    else addCell(0, 0, CTYPE.ON) end
    camera = Camera.new(0,0,{W/2,H/2})
    canvas = love.graphics.newCanvas(W,H)
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0,0,0,255)
    love.graphics.setCanvas()
end

function love.mousepressed(x, y, button)
    x,y = camera:toWorld(x-W/2,y-H/2)
    local col = math.floor(x/cellSize[1])
    local row = math.floor(y/cellSize[2])
    if button == 1 then
        if not cellList[row] or not cellList[row][col] then return end
        if cellList[row][col] == CTYPE.OPEN then
            addCell(row, col, CTYPE.ON)
        end
    elseif button == 2 then
        addCell(row, col, CTYPE.ON)
    end
end

function love.wheelmoved(x, y)
    camera.zoom = camera.zoom * math.pow(1.5,y>0 and 1 or -1)
end

function love.mousemoved(x,y,dx,dy)
    if not love.mouse.isDown(3) then return end
    camera:translate(-dx/camera.zoom,-dy/camera.zoom)
end

function love.keypressed(key)
    if key == 'escape' then
        reset()
        return
    end
    if key == 'r' then
        addRandom()
        return
    end
    if key == 'up' then timer_speed = timer_speed*2
    elseif key == 'down' then timer_speed = timer_speed/2
    elseif key == 'space' then
        auto = not auto
    end
    local n = tonumber(key)
    if n and n>=1 and n<=8 then
        rule[n] = (rule[n]+1)%2
    end
end

function love.update(dt)
    if not auto then return end
    timer = timer + timer_speed*dt
    while timer > 1 do
        timer = timer-1
        addRandom()
    end
end

function drawRect(row, col, ctype)
    love.graphics.setColor(colors[ctype])
    love.graphics.rectangle('fill',
        (col+cellSpacing)*cellSize[1],
        (row+cellSpacing)*cellSize[2],
        cellSize[1]*(1-cellSpacing*2),
        cellSize[2]*(1-cellSpacing*2)
    )
end

function drawCall()
    --love.graphics.draw(canvas)
    for row,rowList in pairs(cellList) do
        for col,ctype in pairs(rowList) do
            drawRect(row, col, ctype)
        end
    end
end

function love.draw()
    love.graphics.push()
    love.graphics.translate(W/2,H/2)
    love.graphics.setColor(255,255,255)
    camera:draw(drawCall)
    love.graphics.pop()
    love.graphics.setColor(255,255,255)
    love.graphics.print(table.concat(rule,'\t'),0,0)
    love.graphics.print(iteration,0,50)
end