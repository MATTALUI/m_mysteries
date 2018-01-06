class EquipmentItem < InventoryItem
  def initialize(name, description, type, stats)
    super(name, description, true)
    remove_instance_variable(:@action)
    @type = type
    @stats = stats
  end

  def type
    @type
  end

  def use
    puts ">>The #{@name} must be equipped".yellow
  end

  def equip
    $game.hero.delta_health(@stats[:hp]) if @stats[:hp]
    $game.hero.delta_defense(@stats[:def]) if @stats[:def]
    $game.hero.delta_attack(@stats[:atk]) if @stats[:atk]
    $game.hero.delta_luck(@stats[:luck]) if @stats[:luck]
    $game.hero.delta_speed(@stats[:spd]) if @stats[:spd]
    @stats[:up][] if @stats[:up]
  end

  def remove
    $game.hero.delta_health(-@stats[:hp]) if @stats[:hp]
    $game.hero.delta_defense(-@stats[:def]) if @stats[:def]
    $game.hero.delta_attack(-@stats[:atk]) if @stats[:atk]
    $game.hero.delta_luck(-@stats[:luck]) if @stats[:luck]
    $game.hero.delta_speed(-@stats[:spd]) if @stats[:spd]
    @stats[:down][] if @stats[:down]
  end

end
