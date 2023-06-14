class ShitSpray
  # Sprite dimensions
  WIDTH = 50
  HEIGHT = 100

  # Frames of animation
  FRAMES = 7
  # Game ticks each frame of animation is held for
  HELD = 3

  def initialize(args)
    @args = args
    @birth_frame = args.state.tick_count
  end

  # @return [Boolean] whether or not the animation has concluded
  def dead?
    @args.state.tick_count - @birth_frame >= FRAMES * HELD
  end

  # @param x [Integer] the x-position of the player
  # @param y [Integer] the y-position of the player
  # @return [Hash] the shit spray's sprite primitive for this frame,
  #                or nil if the animation has concluded
  def sprite(x, y)
    if index = @birth_frame.frame_index(count: FRAMES, hold_for: HELD)
      {
        x: x - 8,
        y: y - HEIGHT,
        w: WIDTH,
        h: HEIGHT,
        path: "sprites/spray/spray#{index}.png"
      }
    end
  end
end
