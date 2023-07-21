local selection = require'selection'
local game = require'game'

local state = nil

local events = {'update', 'draw', 'mousepressed', 'keypressed', 'mousemoved'}

local function setGame(arg)
    game.start(arg)
    state = game
end

local function setSelection()
    state = selection
end

function love.load()
    love.window.setMode(1800,1000)
    selection.load()
    game.load()
    state = selection
    selection.setOptions({2, 10, 50, 250})
    selection.onSelection = setGame
    game.onQuit = setSelection
    love.graphics.setFont(love.graphics.newFont(20))
end

for i,event in pairs(events) do
    love[event] = function(...)
        if state[event] then state[event](...) end
    end
end