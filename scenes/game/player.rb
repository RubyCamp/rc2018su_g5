class Player < Sprite
  attr_accessor :bullets, :score, :name

  FUKIDASHI_IMG = Image.load('images/fukudashi.png')
  PUNCHI_SOUND = Sound.new('sound/neko_punch.wav')
  FIRE_SOUND = Sound.new('sound/fire.wav')

  CLEAR_SCORE = 30

  def initialize(x, y, image, direction, bullet_image, controller, name)
    @direction = direction
    @bullet_image = bullet_image
    @controller = controller
    @name = name
    @ad = 0
    @bullets = []
    @score = 0
    @fukidashi_timer = 0
    @font = Font.new(12)

    @limit_y_top = 0
    @limit_y_bottom = Window.height - image.height

    if @direction > 0
      @limit_x_left = 0
      @limit_x_right = (Window.width / 2) - image.width
    else
      @limit_x_left = Window.width / 2
      @limit_x_right = Window.width - image.width
    end
    super
  end

  def update
    self.x += @controller.x
    self.y += @controller.y
    limit_check
    shoot if @controller.shooting?
    Sprite.update(@bullets)
    Sprite.clean(@bullets)
    draw_fukidashi
    self.draw
  end

  def draw_fukidashi
    return if @fukidashi_timer <= 0
    fx = self.x - (-@direction * (self.image.width / 2))
    fy = self.y - self.image.height / 2
    Window.draw(fx, fy, FUKIDASHI_IMG)
    Window.draw_font(fx + 14, fy + 20, 'にゃ！', @font, color: C_BLACK)
    @fukidashi_timer -= 1
  end

  def hit(bullet)
    if @direction > 0
      return if bullet.direction > 0
    else
      return if bullet.direction < 0
    end

    Scene[:game].player_hash[bullet.owner].score += 1
    @fukidashi_timer = 40
    PUNCHI_SOUND.play
    bullet.vanish

    Scene[:game].players.each do |player|
      if player.score >= CLEAR_SCORE
        Scene[:ending].change_bgm
        Scene.current = :ending
      end
    end
  end

  private

  def shoot
    bullet = Bullet.new(self.x, self.y, @bullet_image)
    bullet.direction = @direction * (rand(5.0) + 2)
    bullet.owner = @name
    @bullets << bullet
    FIRE_SOUND.play
  end

  def limit_check
    self.x -= @controller.x if @limit_x_right < self.x || self.x < @limit_x_left
    self.y -= @controller.y if @limit_y_bottom < self.y || self.y < @limit_y_top
  end


end
