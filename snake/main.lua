require("snake")
require("maze")
require("food")

gamestatus = "menu"

function step()
  snake:updatePosition()
  return checkCollision(snake, maze)
end

function checkCollision(snake, maze)
  return snake:x() > maze.width or -- bateu direita
        snake:x() < maze.x or -- bateu esquerda
        snake:y() > maze.height or -- bateu topo
        snake:y() < maze.y -- bateu baixo
end

function love.load() 
  -- init function
  math.randomseed(os.time())
  snake = Snake.new({initial = 8, speed = 5})
  maze = Maze.new()
  food = Food.new()
  food:randomize()
  
  time = 0

  step()
end

function love.update(dt)
  if love.keyboard.isDown("s") then
    gamestatus = "playing"
  end
  if love.keyboard.isDown("h") then
    gamestatus = "playing"
    snake.hardcore = true
    snake.speed = 1
  end
  if love.keyboard.isDown("r") then
    gamestatus = "menu"
    love.load()
  end
  if gamestatus == "playing" then
    play(dt)
  end
end

function love.draw()
  if gamestatus == "menu" then
    love.graphics.print("Bem vindo ao Snake.\n\nAperte 's' para iniciar\n\nAperte 'h' para iniciar no modo hardcore", 200, 40)
  elseif snake:isDead() then
    love.mouse.setVisible(true)
    love.graphics.print("Game over", 350, love.window.getHeight()/2)
    love.graphics.print("\nSeu score: ".. snake.growth, 345, love.window.getHeight()/2)
    love.graphics.print("Aperte 'r' para reiniciar", 320, love.window.getHeight()/2 + 50)
  else
    if snake:collide(food) then
      food:randomize()
      snake:grown()
    end
    love.graphics.rectangle("line", maze.x, maze.y, maze.width, maze.height)
    love.graphics.circle("fill", food.x, food.y, 2, 100)
    snake:draw()
  end
end

function play(dt)
  time = time + 100 * dt
  if time >= snake.speed and snake.alive then
    key = love.keyboard.isDown("right") and "right"
    or love.keyboard.isDown("left") and "left"
    or love.keyboard.isDown("up") and "up"
    or love.keyboard.isDown("down") and "down"
    if love.keyboard.isDown("v") then
      snake:grown()
    else 
      snake:changeDirection(key)
    end
    time = 0
    collision = step()
    if collision then
      snake:die()
    end
  end
end