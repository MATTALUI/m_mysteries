require 'colorize'
require "./Game.rb"
require './InventoryItem.rb'
require './EquipmentItem.rb'
require './Hero.rb'
require './Room.rb'

def init
  puts "Welcome to Matt's Mysteries!".red.bold
  puts "Matt's Mysteries is a fun, simple text adventure game where you can explore rooms of a dungeon, collect treasure, and fight monsters.".red
  puts "You may type help at any time to get instructions.".yellow
  $on = true
  $game = Game.new
  while $on
    if $game.dungeon_cleared? then
      puts "Your dungeon is cleared."
    end
    await_next_command()
  end
end

def await_next_command
  puts
  puts
  puts
  puts "What would you like to do?".blue
  next_command = STDIN.gets
  handle_command next_command
end

def handle_command (whole_command)
  words = whole_command.split(" ")
  action = words[0]
  case action
    when "help"
      help()
    when "hero"
      inspect_hero()
    when "use"
      words.shift()
      handle_use(words.join(' '))
      apply_turn()
    when "discard"
      words.shift()
      handle_discard(words.join(' '))
      apply_turn()
    when "attack"
      words.shift()
      handle_attack(words.join(' '))
      apply_turn()
    when "inspect"
      inspect_room()
      apply_turn()
    when "loot"
      loot_room()
      apply_turn()
    when "inventory"
      show_inventory()
    when "equip"
      words.shift()
      handle_equip(words.join(' '))
      apply_turn()
    when "remove"
      words.shift()
      handle_remove(words.join(' '))
      apply_turn()
    when "go"
      words.shift()
      change_room(words)
      apply_turn()
    when "exit"
      $on = false
      puts "Maintain the adventure.".magenta
    else
      puts ">>Unrecognized action \"#{action}\".".red
  end
end

def handle_use(item)
  if item.length == 0 then
    puts "Which item would you like to use?".blue
    item = STDIN.gets.strip
  end
  has = $game.hero.inventory.index{|inventory_item| inventory_item.name == item}
  if not has then
    puts ">>You do not have #{item} in your inventory.".red
    return
  end
    puts item
    $game.hero.use_item(item)
end

def handle_discard(item)
  if item.length == 0 then
    puts "Which item would you like to discard?".blue
    item = STDIN.gets.strip
  end
  has = $game.hero.inventory.index{|inventory_item| inventory_item.name == item}
  if not has then
    puts ">>You do not have #{item} in your inventory.".red
    return
  end
    $game.hero.discard_item(item)

end

def handle_attack(target)
  x = $game.hero.location[0]
  y = $game.hero.location[1]
  enemies = $game.dungeon[x][y].enemies
  if enemies.length == 0 then
    puts ">>There are no enemies in this room...".red
    return
  end
  enemy_index = enemies.index{|enemy| enemy.name == target}
  if enemy_index.nil? then
    puts ">>There is no #{target} in this room.".red
    return
  end
  enemy = enemies[enemy_index]
  enemy.attack
end

def handle_equip(intended_eq_piece)
  eq_index = $game.hero.inventory.index{|item| item.name == intended_eq_piece}
  if eq_index.nil? then
    puts ">>You do not have #{intended_eq_piece} in your inventory.".red
    return
  end
  equipment = $game.hero.inventory[eq_index]
  if not equipment.instance_of? EquipmentItem then
    puts ">>You can not equip #{equipment.name}.".red
    return
  end
  if equipment.type == :weapon then
    equip_weapon(equipment)
  elsif equipment.type == :armor then
    equip_armor(equipment)
  else
    puts "Some unforseen forces prevented you from equipping #{equipment.name}."
  end

end

def handle_remove(remove_piece)
  hero = $game.hero
  eq_index = hero.weapons.index{|w| w.name == remove_piece}
  type = :weapon
  type = :armor if eq_index.nil?
  eq_index = hero.armor.index{|a| a.name == remove_piece} if eq_index.nil?
  if eq_index.nil? then
    puts ">>You do not have #{remove_piece} equipped.".red
    return
  end
  if type == :weapon then
    equipment = hero.weapons[eq_index]
    hero.remove_weapon(equipment)
  else
    equipment = hero.armor[eq_index]
    hero.remove_armor(equipment)
  end
  equipment.remove
  hero.add_inventory(equipment)
  puts ">>Removed #{equipment.name}".yellow
end

def equip_weapon(weapon)
  hero = $game.hero
  if hero.weapons.length == 2 then
    puts ">>You can only equip two weapons at a time.".red
    return
  end
  hero.remove_from_inventory(weapon)
  weapon.equip
  hero.add_weapon(weapon)
  puts ">>You equipped #{weapon.name}.".yellow
end

def equip_armor(armor)
  hero = $game.hero
  if hero.armor.length == 5 then
    puts ">>You can only equip five pieces of armor at a time.".red
    return
  end
  hero.remove_from_inventory(armor)
  armor.equip
  hero.add_armor(armor)
  puts ">>You equipped #{armor.name}.".yellow
end

def help
  puts "|----------- HELP -----------|".green.bold
  puts
  puts "inspect".green.bold
  puts "Using ".light_green+ "inspect".green.bold + " will give you a brief description of the room that you're in, enemies present, directions of its exits, as well as any other notable features.".light_green

  puts
  puts "hero".green.bold
  puts "Using ".light_green+ "hero".green.bold + " will give you a brief overview of all of your hero's stats and equipped items.".light_green

  puts
  puts "loot".green.bold
  puts "Using ".light_green+ "loot".green.bold + " will retrieve any treasure in a room or that was dropped by enemies. It will also pick up any key items that may be hidden in the room.".light_green

  puts
  puts "inventory".green.bold
  puts "Using ".light_green+ "inventory".green.bold + " will show a list of all the item available to ".light_green + "use".green.bold + ", ".light_green + "discard".green.bold + ", or ".light_green + "equip".green.bold + ".".light_green

  puts
  puts "equip".green.bold + "/".light_green + "remove [item]".green.bold
  puts "Using ".light_green + "equip".green.bold + " will remove given equippable item from your inventory and apply it to your hero. ".light_green + "Using ".light_green + "remove".green.bold + " will take given equipment off of your hero and place it back into your inventory.".light_green

  puts
  puts "go [direction]".green.bold
  puts "Using ".light_green+ "go".green.bold + " will take you through any available exits in the room that you're in.".light_green

  puts
  puts "|----------------------------|".green.bold
end

def inspect_hero
  puts "|----------- HERO -----------|".green.bold
  puts
  puts "HEALTH: ".green.bold + "#{$game.hero.health}".light_green
  puts "ATTACK: ".green.bold + "#{$game.hero.attack}".light_green
  puts "DEFENSE: ".green.bold + "#{$game.hero.defense}".light_green
  puts "SPEED: ".green.bold + "#{$game.hero.speed}".light_green
  puts

  if $game.hero.weapons[0] then
    puts "WEAPON 1: ".green.bold+"#{$game.hero.weapons[0].name}".light_green
  else
    puts "WEAPON 1: ".green.bold + "[EMPTY]".light_green
  end

  if $game.hero.weapons[1] then
    puts "WEAPON 2: ".green.bold+"#{$game.hero.weapons[1].name}".light_green
  else
    puts "WEAPON 2: ".green.bold + "[EMPTY]".light_green
  end

  armors = $game.hero.armor
  puts "ARMORS: ".green.bold
  arm_index = 0
  while arm_index < 5
    puts "#{arm_index + 1}) ".green.bold+"[EMPTY]".light_green if armors[arm_index].nil?
    puts "#{arm_index + 1}) ".green.bold+"#{armors[arm_index].name}".light_green if not armors[arm_index].nil?
    arm_index += 1
  end

  puts
  puts "|----------------------------|".green.bold
end

def inspect_room
  puts ">>You inspect the room.".yellow
  x = $game.hero.location[0]
  y = $game.hero.location[1]
  $game.dungeon[x][y].inspect_room
  $game.exits
end

def loot_room
  x = $game.hero.location[0]
  y = $game.hero.location[1]
  $game.dungeon[x][y].loot
end

def change_room(commands)
  exits = $game.exits(false).map { |direction|  direction.downcase }
  if commands.length == 0 then
    puts "Which direction would you like to go?".blue
    direction = STDIN.gets
  else
    direction = commands[0].downcase
  end
  if exits.index(direction).nil? then
    puts ">>That's not a direction that you can go.".red
  else
    x = $game.hero.location[0]
    y = $game.hero.location[1]
    $game.hero.move(x+1,y) if direction == "south"
    $game.hero.move(x-1,y) if direction == "north"
    $game.hero.move(x,y+1) if direction == "east"
    $game.hero.move(x,y-1) if direction == "west"
    puts ">>You go out through the #{direction.capitalize} exit.".yellow
  end
end

def show_inventory
  puts "|--------- INVENTORY ---------|".green.bold
  puts
  $game.hero.inventory.each { |item|
    puts "#{item.name}".green.bold
    puts "#{item.description}".light_green
    if item.uses_remaining != true then
      puts "(USES REMAINING: #{item.uses_remaining})".light_green
    end
    puts
  }
  puts "|-----------------------------|".green.bold
end

def face_retaliation
  $game.hero.aggroed_enemies.each { |enemy|
    enemy.retaliate
  }
end

def apply_turn
  face_retaliation()
end







init()
