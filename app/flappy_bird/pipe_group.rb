class PipeGroup
  SPEED = 2
  WIDTH = 80
  GAP = 150
  MAX_OFFSET = 500

  DELAY = 3.seconds

  attr_reader :primitives

  def initialize(args)
    @args = args

    @screen_width = args.grid.w
    @screen_height = args.grid.h

    offset = rand(MAX_OFFSET) - (MAX_OFFSET / 2)

    @primitives = [(@screen_height + GAP) / 2, -(@screen_height + GAP) / 2].map do |y|
      {
        x: @screen_width, y: y + offset,
        w: WIDTH,
        h: @screen_height,
        path: "sprites/pipe.png",
        primitive_marker: :sprite
      }
    end

    @primitives.last.flip_vertically = true
  end

  # The pipes move to the left at a constant speed. This method advances the pipes each frame.
  def advance
    @primitives.each { |p| p.x -= SPEED }
  end

  # @param rect [Hash|Array] the rectangle to check against for a collision
  # @return [Boolean] whether or not the rectangle is in collision with either pipe
  def colliding_with?(rect)
    @primitives.any? { |pipe| pipe.intersect_rect?(rect) }
  end

  # @return [Boolean] whether or not the pipes have completely exited the screen to the left
  def off_screen?
    @primitives.first.x < -WIDTH
  end

  # Call to see if the player has cleared the obstacle. It will only return true one time,
  # so you can check this every frame.
  #
  # @param x [Float] the x-coordinate of the player
  # @return whether or not the player has cleared this obstacle
  def cleared?(x)
    if !@counted && @primitives.first.x < x - WIDTH
      @counted = true
    end
  end
end
