class Gauge
  attr_accessor :fore_image, :diff_image

  GAUGE_IMAGE = Image.load('images/game/gauge.png')
  DIFF_SPEED = 2

  def initialize(x, y, width, height, player, left_to_right=false)
    @left_to_right = left_to_right
    if @left_to_right
      @back_image = GAUGE_IMAGE.slice(270, 2, 268, 84)
      bar_x = 11
      bar_y = 8
    else
      @back_image = GAUGE_IMAGE.slice(0, 0, 268, 84)
      bar_x = 1
      bar_y = 8
    end

    @back_sprite = Sprite.new(x, y, @back_image)
    @frame_image = Image.new(width, height, C_DEFAULT).box(0, 0, width, height, [255, 142, 99, 60])
    @frame_sprite = Sprite.new(x + bar_x, y + bar_y, @frame_image)
    @diff_image = Image.new(@frame_image.width, @frame_image.height, C_RED)
    @diff_sprite = Sprite.new(@frame_sprite.x, @frame_sprite.y, @diff_image)
    @fore_image = Image.new(@frame_image.width, @frame_image.height, C_GREEN)
    @fore_sprite = Sprite.new(@frame_sprite.x, @frame_sprite.y, @fore_image)
    @player = player
  end

  def update
    hp_rate = @player.current_hp / @player.max_hp.to_f

    unless @left_to_right
      if @diff_image.width > @fore_image.width
        width = @diff_image.width - DIFF_SPEED
        width = 1 if width <= 0
        @diff_image = Image.new(width, @diff_image.height, C_RED)
        @diff_sprite = Sprite.new(@diff_sprite.x, @diff_sprite.y, @diff_image)
      elsif @diff_image.width < @fore_image.width
        @diff_image = Image.new(@fore_image.width, @fore_image.height, C_GREEN)
        @diff_sprite = Sprite.new(@diff_sprite.x, @diff_sprite.y, @diff_image)
      end
    else
      if @diff_sprite.x < @fore_sprite.x
        width = @diff_image.width - DIFF_SPEED
        width = 1 if width <= 0
        @diff_image = Image.new(width, @fore_image.height, C_RED)
        @diff_sprite = Sprite.new(@diff_sprite.x + DIFF_SPEED, @diff_sprite.y, @diff_image)
      elsif @diff_sprite.x > @fore_sprite.x
        @diff_image = Image.new(@fore_image.width, @fore_image.height, C_RED)
        @diff_sprite = Sprite.new(@fore_sprite.x, @diff_sprite.y, @diff_image)
      end
    end

    @fore_image = Image.new(@player.current_hp <= 0 ? 1 : hp_rate * @frame_image.width, @frame_image.height, C_GREEN)
    @fore_sprite = Sprite.new(@frame_sprite.x + (@left_to_right ? @frame_image.width - @fore_image.width : 0), @frame_sprite.y, @fore_image)

    @back_sprite.draw
    @diff_sprite.draw
    @fore_sprite.draw
    @frame_sprite.draw
  end
end
