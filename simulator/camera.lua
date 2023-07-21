
local camera = {}

local mt = {__index = camera}

function camera.new(x,y,extents)
    local self = {
        x = x or 0,
        y = y or 0,
        size = extents,
        zoom = 1
    }
    setmetatable(self, mt)
    return self
end

function camera:translate(dx,dy)
    self.x, self.y = self.x+dx, self.y+dy
end

function camera:toWorld(px, py)
    --return (self.x-px)/self.zoom, (self.y-py)/self.zoom
    --return (px-self.x)/self.zoom, (py-self.y)/self.zoom
    --return (self.x+px)/self.zoom, (self.y+py)/self.zoom
    return self.x + px/self.zoom, self.y + py/self.zoom
end

function camera:draw(drawCall)
    love.graphics.push()
    love.graphics.scale(self.zoom)
    love.graphics.translate(-self.x, -self.y)
    drawCall()
    love.graphics.pop()
end

return camera