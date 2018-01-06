require './description_list.rb'
require './Enemy.rb'
class Room
  def initialize(y_index)
    initialize_loot(y_index)
    initialize_enemies(y_index)
    initialize_description()
  end

  def inspect_room
    puts @description
    @enemies.each_with_index {|enemy, index|
      puts "There is an #{enemy.name} in this room!"
    }
  end

  def loot
    if (@treasure == 0 && @items.length == 0) then
      puts "There is nothing in this room..."
      return
    end

    if @treasure > 0 then
      puts ">>You loot #{@treasure} treasure from this room!".green
      $game.hero.delta_treasure(@treasure)
      @treasure = 0
    end

    if @items.length > 0 then
      @items.each { |item|
        puts ">>You found a #{item.name}!".green
        $game.hero.add_inventory(item)
      }
      @items = []
    end

  end

  def items
    @items
  end

  def enemies
    @enemies
  end

  def add_item(inventory_item)
    @items.push(inventory_item)
  end

  def delta_treasure(amount)
    @treasure += amount
  end

  def kill_enemy(enemy)
    @enemies.delete(enemy)
  end

  def cleared?
    return false if @treasure > 0
    return false if @items.length > 0
    return false if @enemies.length > 0
    return true
  end

  private

    def initialize_description
      random_index = rand(description_options.length - 1)
      @description = description_options[random_index]
    end

    def initialize_loot(y_index)
      @treasure = 0
      @items = []
      if ((y_index >= 0) && (y_index <= 4)) then
        @treasure = rand(20)
        generate_loot(small_items)
      elsif ((y_index >= 5) && (y_index <= 9)) then
        @treasure = (10 + rand(20))
        generate_loot(medium_items)
      else
        @treasure = (20 + rand(20))
        generate_loot(large_items)
      end
    end

    def generate_loot(items)
      chance = rand(9)-6
      gen_index = 1
      while gen_index <= chance
        new_item = items[rand(items.length)]
        @items.push(new_item.clone)
        gen_index += 1
      end
    end

    def initialize_enemies(y_index)
      @enemies = []
      if ((y_index >= 0) && (y_index <= 4)) then
        generate_enemies(easy_enemies, small_items)
      elsif ((y_index >= 5) && (y_index <= 9)) then
        generate_enemies(medium_enemies, medium_items)
      else
        generate_enemies(hard_enemies, large_items)
      end

    end

    def generate_enemies(enemies, possible_items)
      chance = rand(4)
      gen_index = 1
      while gen_index <= chance
        enemy = enemies[rand(enemies.length)]
        new_enemy = enemy.clone
        add_enemy_drops(new_enemy, possible_items)
        @enemies.push(new_enemy)
        gen_index += 1
      end
    end

    def add_enemy_drops(enemy, possible_items)
      # return if enemy.item_drops[0].nil?
      item = possible_items[rand(possible_items.length)]
      item_added = item.clone
      enemy.add_item_drop(item_added)
    end





    def description_options
      [
        "The room is a normal room.",
        "There's something mysterious about this room.",
        "A large rock is in the center of the room.",
        "This room has seen better days...",
        "A large skylight lights up the room",
        "Old furniture is stacked up agains a wall.",
        "The room is full of bones. Spooky!",
        "There's a cat sleeping soundly in the corner.",
        "This room reeks of bad cheese.",
        "A slight humming can be heard from within the walls.",
        "You've never seen so much garbage before!",
        "Everything in this room is pristine and clean.",
        "Some strange characters are painted on the wall.",
        "A large hole in the floor lets you see into the rooms below."
      ]
    end

    def easy_enemies
      [
        Enemy.new('rat', 3, 1, 0, [], 5),
        Enemy.new('ant hill', 7, 1, 0, [], 11),
        Enemy.new('rabbid dog', 7, 2, 1, [], 12),
        Enemy.new('midget', 3, 1, 0, [], 5),
        Enemy.new('enchanted plant', 4, 1, 0, [], 6),
      ]
    end

    def medium_enemies
      [
        Enemy.new('goblin', 10, 3, 2, [], 15),
        Enemy.new('alien', 15, 4, 4, [], 20),
        Enemy.new('crooked police officer', 20, 4, 4, [], 20),
        Enemy.new('crazy hippie', 14, 3, 2, [], 11),
        Enemy.new('voltorb', 21, 3, 5, [], 19),
        Enemy.new('sludge thang', (1+rand(18)), rand(6), rand(6), [], rand(21)),

      ]
    end

    def hard_enemies
      [
        Enemy.new('tank', 30, 5, 20, [], 40),
        Enemy.new('baby drake', 40, 10, 11, [], 45),
      ]
    end

    def small_items
      [

        InventoryItem.new('small potion', 'A small potion. Using this small potion will restore 2 HP.', 1, ->{
          $game.hero.delta_health(2)
          puts ">>+2 HP".green
          puts ">>You now have #{$game.hero.health} HP.".green
        }),
        InventoryItem.new('berry bushel', 'A bushel full of yummy berries. Eating some will help you feel better.', 10, ->{
          $game.hero.delta_health(1)
          puts ">>+1 HP".green
          puts ">>You now have #{$game.hero.health} HP.".green
        }),
        InventoryItem.new('small bomb', 'It\'s a mess of wires and chemicals that you don\'t really understand, but it\'ll sure clear a room. Using this small bomb will damage all enemies in room, but also attract their attention.', 1, ->{
          x = $game.hero.location[0]
          y = $game.hero.location[1]
          enemies = $game.dungeon[x][y].enemies
          if enemies.length == 0 then
            puts ">>Your bomb went off. There were no enemies around.".yellow
            return
          end
          enemies.each { |enemy|
            puts ">>Small bomb delt 3 damage to #{enemy.name}.".green
            $game.hero.add_aggro(enemy)
            enemy.delta_health(-3)
          }
        }),
        InventoryItem.new('ninja throwing star', "Woah! Its edges are all sharpened to a razor point. Using this throwing star will do 3 damage to the closest enemy in a room.", 1, ->{
          x = $game.hero.location[0]
          y = $game.hero.location[1]
          enemies = $game.dungeon[x][y].enemies
          if enemies.length == 0 then
            puts ">>Your throwing star didn't hit anything..."
            return
          end
          target = enemies[0]
          puts "Zzzzzip! Your throwing star delt 3 damage to #{target.name}.".green
          $game.hero.add_aggro(target)
          target.delta_health(-3)
          }),






        EquipmentItem.new('fur hat', "Equippable armor. A trapper-style hat that makes you tougher by confidence alone. \n+3 Defense", :armor, {:def=>3}),
        EquipmentItem.new('ratted shoes', "Equippable armor. Some old shoes that have obviously walked their share of miles. You can see the floor through them. \n+3 Defense", :armor, {:def=>3}),
        EquipmentItem.new('leather coat', "Equippable armor. The elbows are faded with use.\n+4 Defense", :armor, {:def=>4}),
        EquipmentItem.new('dobbys sock', "Equippable armor. A relic reminiscent of a once enslaved house elf. It feels as if it has mystical effects...\n+1 Defense", :armor, {:def=>1,:luck=>3}),
        EquipmentItem.new('blue jeans', "Equipable armor. Wearing these will make Neil Diamond proud of you.\n+4 Defense",:armor, {:def=>4}),
        EquipmentItem.new('white sword', "Equippable weapon. The sword has a respectable weight and craftsmanship, but its dulled from use.\n+7 Attack", :weapon, {:atk=>7}),
        EquipmentItem.new('sharp stick', "Equippable weapon. Someone took the time to sharpen this little stick to a point. It's better than nothing...\n+3 Attack", :weapon, {:atk=>3}),
        EquipmentItem.new('trashcan lid', "Equippable weapon. It's the lid to a trashcan. You can use it as a shield!\n+4 Defense", :armor, {:def=>4})
      ]
    end

    def medium_items
      [
        InventoryItem.new('medium potion', 'A medium potion. Using this medium potion will restore 5 HP.', 1, ->{
          $game.hero.delta_health(5)
          puts ">>+5 HP".green
          puts ">>You now have #{$game.hero.health} HP.".green
        }),
        InventoryItem.new('atk potion', 'A potion red in color. Using this potion will boost your attack by 2.', 1, ->{
            $game.hero.delta_attack(2)
            puts ">>+2 Attack".green
            puts ">>You now have #{$game.hero.attack} attack."
        }),
        InventoryItem.new('randsta potion', 'A new kind of potion that all of the hip kids are doing. It\'s not really sure what using it will do...', 1, ->{
          rand_kind = rand(3)
          case rand_kind
            when 0
              amount = 3 + rand(3)
              $game.hero.delta_health(amount)
              puts ">>+#{amount} HP.".green
              puts ">>You now have #{$game.hero.health} HP.".green
            when 1
              amount = 3 + rand(6)
              $game.hero.delta_attack(amount)
              puts ">>+#{amount} Attack.".green
              puts ">>You now have #{$game.hero.attack} Attack.".green
            when 2
              amount = 3 + rand(6)
              $game.hero.delta_defense(amount)
              puts ">>+#{amount} Defense.".green
              puts ">>You now have #{$game.hero.attack} Defense.".green
          end
        }),
        InventoryItem.new('small luck potion', 'Until now you thought that luck potions were only a rumor. Using this potion will increase your chance of critical attacks on enemies by a small amount.', 1, ->{
          amount = rand(3)
          $game.hero.delta_luck(amount)
          puts ">>You're feeling luckier...".green
        }),
        InventoryItem.new('def potion', 'The scales of dragons are ground up to make this odd potion. Using this potion will boost your defense by 2.', ->{
          $game.hero.delta_defense(2)
          puts ">>+2 Defense".green
          puts ">>You now have #{$game.hero.defense} defense."
          }),
        InventoryItem.new('boomerang', "Indigenous Australians invented this weapon. Using the boomerang will damage the closest enemy and it will even come back to you a couple of times.", (1+rand(5)), ->{
          x = $game.hero.location[0]
          y = $game.hero.location[1]
          enemies = $game.dungeon[x][y].enemies
          if enemies.length == 0 then
            puts ">>Your boomerang didn't hit anything...".yellow
            return
          end
          target = enemies[0]
          puts "Whack! Your throwing star delt 3 damage to #{target.name}.".green
          $game.hero.add_aggro(target)
          target.delta_health(-3)
          }),







        EquipmentItem.new('spiked shield', "Equippable weapon. A typical buckler shield with a protruding spike on the front.\n+7 Defense\n+2 Attack", :weapon, {:def=>7,:atk=>2}),
        EquipmentItem.new('rugged boots', "Equippable armor. Man, these are some solid boots! You could use them to stomp some enemies!\n+5 Defense\n+2 Attack", :armor, {:def=>5, :atk=>2}),
        EquipmentItem.new('combat helmet', "Equippable armor. It's an old World War 2 style combat helmet.\n+7 Defense", :armor, {:def=>9}),
        EquipmentItem.new('party pants', "Equippable armor. These pants protect you because they're so groovy that its hard for enemies to attack you.\n+6 Defense", :armor, {:def=>6, :luck=>2}),
        EquipmentItem.new('great sword', "Equippable weapon.The sword is so heavy that you need two hands to properly wield it, but you're going to use one anyway, aren't you.\n+12 Attack\n-3 Speed", :weapon, {:atk=>12, :spd=>-3}),
        EquipmentItem.new('feather blade', "Equippable Weapon. While it doesn't make you much more dangerous, its aerodynamic shape helpes you to move quicker.\n+4 Attack\n+10 Speed", :weapon, {:atk=>4, :spd=>10}),
        EquipmentItem.new('sombrero', "Wearable armor. Straight out of the heart of Mexico, it will protect you from enemies as well as the sun.\n+7 Defense\n+2 Speed", :armor,{:def=>7, :spd=>2, :luck=>2}),
        EquipmentItem.new('quick whip', "Equippable weapon. A quick snap is enough to strike fear into the hearts of both livestock and nazis.\n+3 Attack\n+6 Speed", :weapon, {:atk=>3, :spd=>6}),
        EquipmentItem.new('flight jacket', "Equippable armor. A small number of patches are sewn into the sleeve.\n+7 Defense\n+1 Speed", :armor, {:def=>7,:spd=>1})
      ]
    end

    def large_items
      [
        InventoryItem.new('large potion', 'A large potion. Using this large potion will restore 10 HP.', 1, ->{
          $game.hero.delta_health(10)
          puts ">>+10 HP".green
          puts ">>You now have #{$game.hero.health} HP.".green
        }),
        InventoryItem.new('atk potion plus', 'The red potion sparkles with power. Using this potion will boost your attack by 7.', 1, ->{
          $game.hero.delta_attack(7)
          puts ">>+7 Attack".green
          puts ">>You now have #{$game.hero.attack} attack."
        })
      ]
    end
end
