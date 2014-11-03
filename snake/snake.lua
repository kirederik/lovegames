-- Block Snake

Block = {}
Block.__index = Block

function Block.new(block, previous)
  b = {}
  b.size = block.size or 10
  b.x = block.x or 100
  b.y = block.y or 100
  b.direction = block.direction
  b.vertices = block.vertices or {}
  b.previous = nil
  return setmetatable(b, Block)
end

Block.__tostring = function(t)
  return "{ " .. t.x .. ", " .. t.y .. " }"
end

function Block:move(where, speed, head)
  local x1, x2, y1, y2
  local speed = self.size
  local position = {x = self.x, y = self.y, direction = self.direction}
  if not where then
    if self.direction == "up" then
      self.y = self.y - speed
    elseif self.direction == "down" then
      self.y = self.y + speed
    elseif self.direction == "right" then
      self.x = self.x + speed
    elseif self.direction == "left" then
      self.x = self.x - speed
    end
  else 
    self.direction = where.direction
    self.x = where.x
    self.y = where.y
  end
  x1 = self.x
  y1 = self.y
  x2 = self.x + self.size
  y2 = self.y + self.size

  self.vertices = {
    x1-1, y1-1,
    x2-1, y1-1,
    x2-1, y2-1,
    x1-1, y2-1
  }

  if where and self:collide(head) then
    return true
  end
  if self.previous ~= nil then
    return self.previous:move(position, speed, head)
  end
end

function Block:draw()
  love.graphics.polygon("fill", self.vertices);
  love.graphics.setColor(0,255,0)
  love.graphics.polygon("line", self.vertices);
  love.graphics.setColor(255,255,255)

  if self.previous then
    self.previous:draw()
  end
end

function Block:addNew()
  if self.previous then
    self.previous:addNew()
  else
    self.previous = Block.new(self, nil)
  end
end

function Block:collide(otherblock)
  collidable = (self.direction == "left" or self.direction == "right") 
    and (otherblock.direction == "up" or otherblock.direction == "down") or
    (otherblock.direction == "left" or otherblock.direction == "right") 
    and (self.direction == "up" or self.direction == "down")
  return collidable and self.x == otherblock.x and self.y == otherblock.y
end

-- Snake class
Snake = {}
Snake.__index = Snake

function Snake.new(s)
  snake = {
    speed = s.speed or 2,
    alive = s.alive or true,
    growth = -s.initial,
    hardcore = false
  }
  block = Block.new({
    size = 10, x = love.window.getWidth()/2, 
    y = love.window.getHeight()/2, 
    direction = "right"
  }, nil)
  snake.head = block
  snake = setmetatable(snake, Snake)
  for i=1,s.initial do
    snake:grown()
  end
  love.mouse.setVisible(false)
  return snake
end

function Snake:changeDirection(key)
  if self.head.direction == "up" or self.head.direction == "down" then
    left, right = love.keyboard.isDown("left"), love.keyboard.isDown("right")
    if key == "left" or key == "right" then
      self.head.direction = key
    end
  elseif self.head.direction == "right" or self.head.direction == "left" then
    if key == "up" or key == "down"then
      self.head.direction = key
    end
  end
end

function Snake:updatePosition()

  collision = self.head:move(nil, snake.speed, self.head)
  if collision then
    self:die()
  end

end

function Snake:collide(food)
  return self.head.x <= food.x and 
    self.head.x + self.head.size >= food.x and
    self.head.y <= food.y and 
    self.head.y + self.head.size >= food.y 
end

function Snake:grown()
  self.head:addNew()
  self.growth = self.growth + 1
  
  if self.hardcore == false then
    print(self.growth, self.speed)
    if self.growth > 10 then
      self.speed = 4
    end
    if self.growth > 15 then
      self.speed = 3
    end
    if self.growth > 20 then
      self.speed = 2
    end
    if self.growth > 25 then
      self.speed = 1
    end
  end
end

function Snake:draw()
  self.head:draw()
end

function Snake:isDead() return not self.alive end
function Snake:die() self.alive = false end

function Snake:x() return self.head.x end
function Snake:y() return self.head.y end
function Snake:size() return self.head.size end
function Snake:vertices() return self.head.vertices end

function Snake:setX(x) self.head.x = x end
function Snake:setY(y) self.head.y = y end
function Snake:setVertices(v) self.head.vertices = v end
function Snake:direction() return self.head.direction end

-- Set constructor
setmetatable(Snake, { __call = function(_, ...) return Snake.new(...) end })
setmetatable(Block, { __call = function(_, ...) return Block.new(...) end })