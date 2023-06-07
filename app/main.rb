require "app/flappy_bird/flappy_bird.rb"
require "app/flappy_bird/pipe_group.rb"

def tick(args)
  args.state.game ||= FlappyBirdGame.new(args)
  args.state.game.tick
end

$gtk.reset
