
Food = {}
Food.__index = Food

function Food.new()
  f = {}
  f.x = 0
  f.y = 0
  f.width = love.window.getWidth() - 20
  f.heigth = love.window.getHeight() - 20
  return setmetatable(f, Food)
end

function Food:randomize()
  self.x = (5 + math.random(10, self.width) * 10) % self.width
  self.y = (5 + math.random(10, self.heigth) * 10) % self.heigth
  if self.x <= 10 then self.x = 15 end
  if self.y <= 10 then self.y = 15 end
end

setmetatable(Food, { __call = function(_, ...) return Food.new(...) end })
