# name, hp, atk, def, items, $$$
# SMALL ENEMIES
[
  Enemy.new('rat', 3, 1, 0, [], 5),
  Enemy.new('ant hill', 7, 1, 0, [], 11),
  Enemy.new('rabbid dog', 7, 2, 1, [], 12),
  Enemy.new('midget', 3, 1, 0, [], 5),
  Enemy.new('enchanted plant', 4, 1, 0, [], 6),
]

# MEDIUM ENEMIES
[
  Enemy.new('goblin', 10, 3, 2, [], 15),
  Enemy.new('alien', 15, 4, 4, [], 20),
  Enemy.new('crooked police officer', 20, 4, 4, [], 20),
  Enemy.new('crazy hippie', 14, 3, 2, [], 11),
  Enemy.new('voltorb', 21, 3, 5, [], 19),
  Enemy.new('sludge thang', (1+rand(18)), rand(6), rand(6), [], rand(21)),

]

# HARD ENEMIES
[
  Enemy.new('tank', 30, 5, 20, [], 40),
  Enemy.new('baby drake', 40, 10, 11, [], 45),
]

# BOSSES
[

]
