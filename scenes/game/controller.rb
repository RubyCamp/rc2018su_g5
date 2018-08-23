class Controller
  attr_accessor :attack1, :attack2, :attack3, :avoid
  def initialize
    set_keybind
  end

  private

  def set_keybind
    self.attack1 = K_A
    self.attack2 = K_S
    self.attack3 = K_D
    self.avoid = K_W

  end
end
