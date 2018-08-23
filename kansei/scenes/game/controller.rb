class Controller
  attr_accessor :attack1, :attack2, :attack3, :avoid

  def initialize
    set_keybind
  end

  def press_attack1
    Input.key_push?(attack1)
  end

  def press_attack2
    Input.key_push?(attack2)
  end

  def press_attack3
    Input.key_push?(attack3)
  end

  def press_avoid
    Input.key_push?(avoid)
  end

  private

  def set_keybind
    self.attack1 = K_A
    self.attack2 = K_S
    self.attack3 = K_D
    self.avoid = K_W
  end
end
