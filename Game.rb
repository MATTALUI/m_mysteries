


class Game

  def initialize
    @hero = Hero.new
    initialize_dungeon()
  end

  def hero
    @hero
  end

  def dungeon
    @dungeon
  end

  def dungeon_cleared?
    cleared = true
    @dungeon.each {|level|
      level.each{|room|
        cleared = false if not room.cleared?
      }
    }
    cleared
  end

  def exits(show=true)
    x = @hero.location[0]
    y = @hero.location[1]
    exits = []
    if x != (@dungeon.length - 1) then
      if y <= (@dungeon[x+1].length - 1) then
        exits.push("South")
      end
    end
    exits.push("North") if ((@dungeon[x-1].length-1 >= y) && (x != 0))
    exits.push("West") if y != 0
    exits.push("East") if y != (@dungeon[x].length - 1)
    if show then
      puts "There is an exit to the #{exits[0]}" if exits.length == 1
      puts "There are exits to the #{exits[0]} and to the #{exits[1]}" if exits.length == 2
      puts "There are exits to the #{exits[0]}, #{exits[1]}, and to the #{exits[2]}" if exits.length == 3
      puts "There are exits to the #{exits[0]}, #{exits[1]}, #{exits[3]}, and to the #{exits[2]}" if exits.length == 4
    end
    exits
  end

  private
   def initialize_dungeon
     @dungeon = []
     outer_index = 0
     outer_limit = rand(11)
     while outer_index <= outer_limit
       row = []
       inner_index = 0
       inner_limit = rand(11)

       while inner_index <= inner_limit
         row.push(Room.new(inner_index))
         inner_index += 1
       end

       @dungeon.push(row)
       outer_index += 1
     end
   end
end
