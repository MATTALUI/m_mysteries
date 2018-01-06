class Enemy
  def initialize(name, health=1, attack=1, defense=0, item_drops=[], treasure_drop=0)
    @health = health
    @attack = attack
    @defense = defense
    @name = name
    @item_drops = item_drops
    @treasure_drop = treasure_drop
  end

  def attack_stat
    @attack
  end

  def defense_state
    @defense
  end

  def health_stat
    @health
  end

  def name
    @name
  end

  def item_drops
    @item_drops
  end

  def add_item_drop(item)
    @item_drops.push(item)
  end

  def delta_health(value)
    @health += value
    if @health <= 0 then
      die
    end
  end

  def attack
    puts ">>You attacked #{@name}.".yellow
    damage = ($game.hero.attack - @defense)
    damage = 1 if damage <= 0
    crit_chance = (20 - $game.hero.luck)
    crit_roll = rand(crit_chance)
    if crit_roll == 0 then
      puts ">>It was a critical hit!".green.bold
      damage = (damage * 2)
    end
    @health -= damage
    puts ">>You did #{damage} damage.".yellow
    if @health <= 0 then
      die
    else
      $game.hero.add_aggro(self) if not $game.hero.has_aggro?(self)
    end
  end

  def retaliate
    puts ">>#{@name} retaliates".red
    damage = (@attack - $game.hero.defense)
    damage = 1 if damage <= 0
    crit_roll = rand(21)
    if crit_roll == 15 then
      puts ">>It was a critical hit!".red.bold
      damage = (damage * 2)
    end
    $game.hero.delta_health(-damage)
    puts ">>#{@name} did #{damage} damage.".red
  end

  private
    def die
      puts ">>#{@name} was defeated.".green
      x = $game.hero.location[0]
      y = $game.hero.location[1]
      room = $game.dungeon[x][y]
      room.delta_treasure(@treasure_drop)
      @item_drops.each { |item|
        room.add_item(item)
        puts "#{@name} dropped #{item.name}"
      }
      $game.hero.remove_aggro(self)
      room.kill_enemy(self)
    end

end
