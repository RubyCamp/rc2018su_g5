class Scene
  @@current = nil
  @@scene_directors = {}

  ERRORS = {
    no_current: 'カレントシーンがセットされていません。set_current(director_name)を実行してください',
    director_not_found: '指定されたディレクター名が見つかりませんでした'
  }

  def self.add(director_name, director_obj)
    @@scene_directors[director_name.to_sym] = director_obj
  end

  def self.remove(director_name)
    @@scene_directors.delete(director_name.to_sym)
    @@current = nil if @@current == director_name.to_sym
  end

  def self.current=(director_name)
    raise ERRORS[:director_not_found] unless @@scene_directors.has_key?(director_name.to_sym)
    @@current = director_name.to_sym
  end

  def self.[](director_name)
    @@scene_directors[director_name.to_sym]
  end

  def self.play
    raise ERRORS[:no_current] unless @@current
    @@scene_directors[@@current].play
  end
end
