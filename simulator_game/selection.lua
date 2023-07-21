local selection = {onSelection = nil}

local options = {}
local width, height
local pingSize
local hover = nil
local titleFont
local titleHeight = 50

local projectBox = {x=0,y=0,width=0,height=0}

function selection.load()
    titleFont = love.graphics.newFont(titleHeight)
    width, height = love.graphics.getDimensions()
    projectBox.x = width/2
    projectBox.y = height/4+titleHeight*2
    projectBox.width = 300
    projectBox.height = titleHeight
end

local function inBounds(x,y,obj)
    return math.abs(x-obj.x)<=(obj.width or obj.size)/2 and math.abs(y-obj.y)<=(obj.height or obj.size)/2
end

local function detectHover(x,y)
    for i,v in ipairs(options) do
        if inBounds(x,y,v) then
            return i,v
        end
    end
end

function selection.update(dt)
    for i,v in ipairs(options) do
        v.t = v.t + dt*v.speed
        v.y = height/2+math.cos(v.t)*pingSize
    end
    local mx, my = love.mouse.getPosition()
    hover = detectHover(mx, my)
end

function selection.mousepressed(x, y, button)
    if button ~= 1 then return end
    local index, opt = detectHover(x, y)
    if index then
        if selection.onSelection then selection.onSelection(opt.value) end
        return
    end
    if inBounds(x,y,projectBox) then
        love.system.openURL('https://community.wolfram.com/groups/-/m/t/2959726')
    end
end

function selection.setOptions(opts)
    options = {}
    local n = #opts
    local size = width/16
    local spacing = size/5
    local total = size*n + spacing*(n-1)
    pingSize = size/20
    for i,v in ipairs(opts) do
        options[i] = {
            x = width/2 - total/2 + size/2 + (size+spacing)*(i-1), y = height/2,
            speed = 4+(i-1)/2, t = 0, size = size,
            value = v
        }
    end
end

function selection.draw()
    local rect, color = love.graphics.rectangle, love.graphics.setColor
    local gprint = love.graphics.printf
    local font = love.graphics.getFont()
    love.graphics.setFont(titleFont)
    gprint('[WSS23] Aggregation System Puzzle', 0, height/4-titleHeight/2, width, 'center')
    love.graphics.setFont(font)
    gprint('by Pietro Pepe', 0, height/4+titleHeight, width, 'center')
    love.graphics.setLineWidth(3)
    for i,v in ipairs(options) do
        local alpha = hover==i and 1 or 0.75
        --color(1, 1, 1, alpha)
        color(0.2, 0.2, 0.2, alpha)
        rect('fill', v.x-v.size/2, v.y-v.size/2, v.size, v.size, v.size/10, v.size/10)
        color(1, 1, 1, alpha)
        --color(1,0,0,alpha)
        rect('line', v.x-v.size/2, v.y-v.size/2, v.size, v.size, v.size/10, v.size/10)
        color(1,1,1,alpha)
        gprint(v.value, v.x-v.size/2, v.y-8, v.size, 'center')
    end
    color(0.3,0.3,0.3)
    rect('fill', projectBox.x-projectBox.width/2, projectBox.y-projectBox.height/2, projectBox.width, projectBox.height,5,5)
    color(1,1,1)
    rect('line', projectBox.x-projectBox.width/2, projectBox.y-projectBox.height/2, projectBox.width, projectBox.height,5,5)
    gprint('See full project',projectBox.x-projectBox.width/2, projectBox.y-10, projectBox.width, 'center')

    gprint('choose instance size', 0, 0.75*height, width, 'center')
end

return selection