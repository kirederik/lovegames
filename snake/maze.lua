Maze = {}
Maze.__index = Maze 

function Maze.new(m)
  maze = m or {
    width = love.window.getWidth() - 20,
    height = love.window.getHeight() - 20,
    x = 10,
    y = 10
  }
  return setmetatable(maze, Maze)
end