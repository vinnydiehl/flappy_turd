FPS = 60

class PipeGroup
  SPEED = 2
  WIDTH = 80
  GAP = 150

  DELAY = 3 # seconds

  attr_reader :primitives

  def initialize(args)
    @args = args

    @screen_width = args.grid.w
    @screen_height = args.grid.h

    @primitives = [(@screen_height + GAP) / 2, -(@screen_height + GAP) / 2].map do |y|
      {
        x: @screen_width, y: y,
        w: WIDTH,
        h: @screen_height,
        r: 34, g: 140, b: 34,
        primitive_marker: :solid
      }
    end
  end

  def advance
    @primitives.each { |p| p.x -= SPEED }
  end

  def colliding_with?(rect); end
end

class FlappyBirdGame
  PLAYER_SIZE = 40
  GRAVITY = 0.2

  def initialize(args)
    @args = args
    @primitives = args.outputs.primitives
    @keyboard = args.inputs.keyboard.key_down
    @controller = args.inputs.controller_one.key_down

    @screen_width = args.grid.w
    @screen_height = args.grid.h

    @player = {
      x: @screen_width / 4,
      y: (@screen_height / 2) - (PLAYER_SIZE / 2),
      w: PLAYER_SIZE,
      h: PLAYER_SIZE,
      path: "sprites/circle/orange.png",
      primitive_marker: :sprite,

      # Acceleration
      dy: 0
    }

    @pipe_groups = []
    spawn_pipes
  end

  def tick
    handle_input
    handle_physics
    handle_pipes
    render
  end

  def handle_input
    # if @keyboard.space || @controller.a
    #
    # end
  end

  def handle_physics
    @player.dy -= GRAVITY
    @player.y += @player.dy
  end

  def handle_pipes
    spawn_pipes if @pipe_spawn_timer == 0
    @pipe_spawn_timer -= 1
    @pipe_groups.each(&:advance)
  end

  def spawn_pipes
    @pipe_groups << PipeGroup.new(@args)
    @pipe_spawn_timer = PipeGroup::DELAY * FPS
  end

  def render
    @primitives << { x: 0, y: 0, w: @screen_width, h: @screen_height,
                     r: 135, g: 206, b: 235, primitive_marker: :solid }

    @pipe_groups.each { |p| @primitives << p.primitives }

    @primitives << @player
  end
end

def tick(args)
  args.state.game ||= FlappyBirdGame.new(args)
  args.state.game.tick
end

$gtk.reset
