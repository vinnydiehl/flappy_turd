require "app/flappy_turd/flappy_turd.rb"
require "app/flappy_turd/obstacle.rb"
require "app/flappy_turd/shit_spray.rb"

def tick(args)
  args.state.game ||= FlappyTurdGame.new(args)
  args.state.game.tick
end

$gtk.reset
