class Hero

  def initialize
    @health = 10
    @attack = 1
    @defense = 0
    @speed = 3
    @luck = 0
    @treasure = 0
    @location = [0,0]
    @inventory = [
      InventoryItem.new('wallet', 'It\'s a pretty typical wallet where you can keep treasure that you find throughout various dungeons. Using your walleet will give you a total count of treasure that you have.', true, ->{
        $game.hero.check_wallet()
      }),
      InventoryItem.new('small potion', 'A small potion. Using this small potion will restore 2 HP.', 1, ->{
        $game.hero.delta_health(2)
        puts ">>+2 HP".green
        puts ">>You now have #{$game.hero.health} HP".green
      }),
    ]

    if ARGV[0] == 'master' then
      @inventory.concat([
        InventoryItem.new('map', 'The map is a very useful item. Using the map will allow you to see the layout of the dungeon and your current location within it.', true, ->{
              $game.dungeon.each_with_index { |level, index|
                representation = Array.new(level.length, "-")
                if index == $game.hero.location[0] then
                  y = $game.hero.location[1]
                  representation[y] = "*"
                end
                print representation.inspect + "\n"
              }
            }),
        InventoryItem.new('treasure map', 'It is worn with age. Using this treasure map will allow you to see which rooms in the dungeon have special items that you can loot.', true, ->{
              $game.dungeon.each_with_index { |level, index|
                representation = level.map { |room|
                  if room.items.length > 0 then
                    return_value = "X"
                  else
                    return_value = "-"
                  end
                  return_value
                }
                print representation.inspect + "\n"
              }
            }),
            InventoryItem.new('threat map', 'Modern technology makes it possible to see heat signature of all life forms in the dungeon. Using the threat map will show you the location of all of the enemies hidden in the dungeon.', true, ->{
              $game.dungeon.each {|level|
                representation = level.map { |room|
                  if room.enemies.length == 0 then
                    return_value = "-"
                  else
                    return_value = room.enemies.length
                  end
                  return_value
                }
                print representation.inspect + "\n"
              }
              })
      ])
    end
    @weapons = []
    @armor = []
    @aggro = []
  end

  def health
    @health
  end

  def location
    @location
  end

  def attack
    @attack
  end

  def defense
    @defense
  end

  def speed
    @speed
  end

  def inventory
    @inventory
  end

  def weapons
    @weapons
  end

  def armor
    @armor
  end

  def luck
    @luck
  end

  def aggroed_enemies
    @aggro
  end

  def use_item(item_name)
    item_index = @inventory.index{|item| item.name == item_name}
    item = @inventory[item_index]
    item.use
  end

  def discard_item(item_name)
    item_index = @inventory.index{|item| item.name == item_name}
    item = @inventory[item_index]
    @inventory.delete(item)
    puts ">>You threw away your #{item.name}.".yellow
  end

  def add_inventory(item)
    @inventory.push(item)
  end

  def remove_from_inventory(item)
    @inventory.delete(item)
  end

  def add_weapon(weapon)
    return if @weapons.length == 2
    @weapons.push(weapon)
  end

  def remove_weapon(weapon)
    @weapons.delete(weapon)
  end

  def add_armor(armor)
    return if @armor.length == 5
    @armor.push(armor)
  end

  def remove_armor(armor)
    @armor.delete(armor)
  end

  def move(x, y)
    @location = [x,y]
  end

  def delta_treasure(value)
    @treasure += value
  end

  def delta_health(value)
    @health += value
    if @health <= 0 then
      puts ">>You died!"
      $on = false
    end
  end

  def delta_attack(value)
    @attack += value
  end

  def delta_defense(value)
    @defense += value
  end

  def delta_luck(value)
    @luck += value
  end

  def delta_speed(value)
    @speed += value
  end

  def check_wallet
    puts "You have #{@treasure} treasure."
  end

  def has_aggro?(enemy)
    aggro_index = @aggro.index(enemy)
    return false if aggro_index.nil?
    return true
  end

  def add_aggro(enemy)
    @aggro.push(enemy)
  end

  def remove_aggro(enemy)
    @aggro.delete(enemy)
  end

end
