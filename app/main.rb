class FlappyBirdGame
  PLAYER_SIZE = 40

  def initialize(args)
    @args = args
    @primitives = args.outputs.primitives

    @screen_width = args.grid.w
    @screen_height = args.grid.h

    @player = {
      x: @screen_width / 4,
      y: (@screen_height / 2) - (PLAYER_SIZE / 2),
      w: PLAYER_SIZE,
      h: PLAYER_SIZE,
      path: "sprites/circle/orange.png",
      primitive_marker: :sprite
    }
  end

  def tick
    render
  end

  def render
    @primitives << { x: 0, y: 0, w: @screen_width, h: @screen_height,
                     r: 135, g: 206, b: 235 }.to_solid
    @primitives << @player
  end
end

def tick(args)
  args.state.game ||= FlappyBirdGame.new(args)
  args.state.game.tick
end

$gtk.reset
