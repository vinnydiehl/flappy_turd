class PipeGroup
  SPEED = 2
  WIDTH = 80
  GAP = 150
  MAX_OFFSET = 500

  DELAY = 3 # seconds

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
        r: 34, g: 140, b: 34,
        primitive_marker: :solid
      }
    end
  end

  def advance
    @primitives.each { |p| p.x -= SPEED }
  end

  def colliding_with?(rect)
    @primitives.any? { |pipe| pipe.intersect_rect?(rect) }
  end

  def off_screen?
    @primitives.first.x < -WIDTH
  end

  def cleared?(x)
    @primitives.first.x < x - WIDTH
  end

  def counted?
    @counted
  end

  def count
    @counted = true
  end
end
