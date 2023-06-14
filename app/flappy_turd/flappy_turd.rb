class FlappyTurdGame
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
      path: "sprites/turd.png",
      primitive_marker: :sprite,

      # Velocity
      dy: 0
    }

    @pipe_groups = []

    @score = 0
    @timer = 0
  end

  def tick
    handle_input
    handle_physics
    check_collisions
    handle_pipes
    check_scoring
    render

    @timer += 1
  end

  def handle_input
    if @keyboard.space || @controller.a
      @player.dy = 5
    end
  end

  def handle_physics
    @player.dy -= GRAVITY
    @player.y += @player.dy
  end

  def check_collisions
    if @player.y <= -PLAYER_SIZE || @pipe_groups.any? { |p| p.colliding_with?(@player) }
      $gtk.reset
    end
  end

  def handle_pipes
    spawn_pipes if @timer % PipeGroup::DELAY == 0
    @pipe_groups.each(&:advance)
    @pipe_groups.reject!(&:off_screen?)
  end

  def check_scoring
    @pipe_groups.each do |pipe_group|
      @score += 1 if pipe_group.cleared?(@player.x)
    end
  end

  def render
    @primitives << {
      x: 0, y: 0, w: @screen_width, h: @screen_height,
      r: 135, g: 206, b: 235, primitive_marker: :solid
    }

    @pipe_groups.each { |p| @primitives << p.primitives }

    @primitives << @player

    @args.outputs.primitives << {
      x: 50, y: 50.from_top,
      text: "Score: #{@score}", size_enum: 5
    }
  end

  def spawn_pipes
    @pipe_groups << PipeGroup.new(@args)
  end
end
