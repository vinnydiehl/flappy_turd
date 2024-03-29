class FlappyTurdGame
  PLAYER_SIZE = 40
  GRAVITY = 0.2

  def initialize(args)
    @args = args
    @primitives = args.outputs.primitives
    @audio = args.audio
    @keyboard = args.inputs.keyboard.key_down
    @controller = args.inputs.controller_one.key_down

    @screen_width = args.grid.w
    @screen_height = args.grid.h

    @scene = :game

    @player = {
      x: @screen_width / 4,
      y: (@screen_height / 2) - (PLAYER_SIZE / 2),
      w: PLAYER_SIZE,
      h: PLAYER_SIZE,
      path: "sprites/turd.png",

      # Velocity
      dy: 0
    }

    @shit_sprays = []
    @obstacles = []

    @score = 0
    @timer = 0
  end

  def tick
    send "#{@scene}_tick"
  end

  def game_tick
    handle_input
    handle_physics
    check_collisions
    handle_pipes
    check_scoring
    render

    @timer += 1
  end

  def game_over_tick
    # Quick & dirty timeout so A button spam doesn't skip the game over screen
    @game_over_timeout = !@game_over_timeout ? 0.5.seconds : @game_over_timeout - 1
    $gtk.reset if @game_over_timeout < 0 && (@keyboard.space || @controller.a)

    render_background
    @primitives << ["Get shit on :(", "Score: #{@score}"].each_with_index.map do |text, i|
      {
        x: @screen_width / 2,
        y: @screen_height / 2 + 50 - (60 * i),
        text: text,
        size_enum: 15 / (i + 1),
        alignment_enum: 1,
        vertical_alignment_enum: 1
      }
    end
  end

  def handle_input
    if @keyboard.space || @controller.a
      @player.dy = 5
      @audio.fart = { input: "sounds/farts/fart#{rand(3)}.wav", looping: false }
      @shit_sprays << ShitSpray.new(@args)
    end
  end

  def handle_physics
    @player.dy -= GRAVITY
    @player.y += @player.dy
  end

  def check_collisions
    if @player.y <= -PLAYER_SIZE || @obstacles.any? { |p| p.colliding_with?(@player) }
      @audio.flush = { input: "sounds/flush.wav", looping: false }
      @scene = :game_over
    end
  end

  def handle_pipes
    spawn_pipes if @timer % Obstacle::DELAY == 0
    @obstacles.each(&:move)
    @obstacles.reject!(&:off_screen?)
  end

  def check_scoring
    @obstacles.each do |pipe_group|
      @score += 1 if pipe_group.cleared?(@player.x)
    end
  end

  def render
    render_background
    @obstacles.each { |p| @primitives << p.primitives }
    @primitives << @player
    render_shit_sprays

    @args.outputs.primitives << {
      x: 50, y: 50.from_top,
      text: "Score: #{@score}", size_enum: 5
    }
  end

  def render_background
    @primitives << {
      x: 0, y: 0, w: @screen_width, h: @screen_height,
      r: 135, g: 206, b: 235, primitive_marker: :solid
    }
  end

  def render_shit_sprays
    @shit_sprays.reject!(&:dead?)
    @shit_sprays.each do |spray|
      @primitives << spray.sprite(@player.x, @player.y)
    end
  end

  def spawn_pipes
    @obstacles << Obstacle.new(@args)
  end
end
