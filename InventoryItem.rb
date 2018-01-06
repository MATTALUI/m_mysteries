class InventoryItem
  def initialize(name, description, uses=1, action=->{})
    @name = name
    @description = description
    @uses = uses
    @action = action
  end

  def name
    @name
  end

  def description
    @description
  end

  def uses_remaining
    @uses
  end

  def use
    puts ">>Used #{@name}.".yellow
    @action[]
    return if @uses == true
    @uses -= 1
    if @uses == 0 then
      puts ">>Your #{@name} is gone.".red
      $game.hero.remove_from_inventory(self)
    end
  end
end
