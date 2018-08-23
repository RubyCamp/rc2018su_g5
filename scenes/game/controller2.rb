class Controller2 < Controller
  private

  def set_keybind
    self.attack1 = K_LEFT
    self.attack2 = K_DOWN
    self.attack3 = K_RIGHT
    self.avoid = K_UP
  end
end
