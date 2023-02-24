robot_art = r"""
      0: {head_name}
      Is available: {head_status}
      Attack: {head_attack}                              
      Defense: {head_defense}
      Energy consumption: {head_energy_consump}
              ^
              |                  |1: {weapon_name}
              |                  |Is available: {weapon_status}
     ____     |    ____          |Attack: {weapon_attack}
    |oooo|  ____  |oooo| ------> |Defense: {weapon_defense}
    |oooo| '    ' |oooo|         |Energy consumption: {weapon_energy_consump}
    |oooo|/\_||_/\|oooo|          
    `----' / __ \  `----'           |2: {left_arm_name}
   '/  |#|/\/__\/\|#|  \'           |Is available: {left_arm_status}
   /  \|#|| |/\| ||#|/  \           |Attack: {left_arm_attack}
  / \_/|_|| |/\| ||_|\_/ \          |Defense: {left_arm_defense}
 |_\/    O\=----=/O    \/_|         |Energy consumption: {left_arm_energy_consump}
 <_>      |=\__/=|      <_> ------> |
 <_>      |------|      <_>         |3: {right_arm_name}
 | |   ___|======|___   | |         |Is available: {right_arm_status}
// \\ / |O|======|O| \  //\\        |Attack: {right_arm_attack}
|  |  | |O+------+O| |  |  |        |Defense: {right_arm_defense}
|\/|  \_+/        \+_/  |\/|        |Energy consumption: {right_arm_energy_consump}
\__/  _|||        |||_  \__/        
      | ||        || |          |4: {left_leg_name} 
     [==|]        [|==]         |Is available: {left_leg_status}
     [===]        [===]         |Attack: {left_leg_attack}
      >_<          >_<          |Defense: {left_leg_defense}
     || ||        || ||         |Energy consumption: {left_leg_energy_consump}
     || ||        || || ------> |
     || ||        || ||         |5: {right_leg_name}
   __|\_/|__    __|\_/|__       |Is available: {right_leg_status}
  /___n_n___\  /___n_n___\      |Attack: {right_leg_attack}
                                |Defense: {right_leg_defense}
                                |Energy consumption: {right_leg_energy_consump}
                                
"""

print(robot_art)

class Part():

  def __init__(self, name: str,  attack_level=0, defense_level=0, energy_consumption=8): 
    self.name = name 
    self.attack_level = attack_level
    self.defense_level = defense_level 
    self.energy_consumption = energy_consumption
    
    
  def get_status_dict(self):
    formatted_name = self.name.replace(" ", "_").lower()
    return {
      "{}_name".format(formatted_name): self.name.upper(), 
      "{}_status". format (formatted_name): self.is_avaliable(), 
      "{}_attack".format(formatted_name): self.attack_level, 
      "{}_defense".format(formatted_name): self.defense_level, 
      "{}_energy_consump".format(formatted_name): self.energy_consumption,
    }
  def is_avaliable(self):
      return not self.defense_level <= 0
    
colors = {"Black": '\x1b[90m', 
          "Blue":'\x1b[94m', 
          "Cyan":'\x1b[96m', 
          "Green":'\x1b[92m', 
          "Magenta":'\x1b[95m', 
          "Red":'\x1b[91m', 
          "White":'\x1b[97m', 
          "Yelow":'\x1b[93m', 
}
class Robot():
  def __init__(self, name, color_code):
    self.name = name
    self.color_code = color_code
    self.energy = 100
    self.parts = [ 
        Part("head", attack_level=5, defense_level=10, energy_consumption=5),
        Part("weapon", attack_level=15, defense_level=0, energy_consumption=10), 
        Part("Left Arm", attack_level=3, defense_level=20, energy_consumption=10),
        Part("Right Arm", attack_level=6, defense_level=20, energy_consumption=10),
        Part("Left Leg", attack_level=4, defense_level=20, energy_consumption=15),
        Part("Right Leg", attack_level=8, defense_level=20, energy_consumption=15),
    ]
    
  def greet(self):
     print("My name is: ", self.name)

  def print_energy(self):
    print("We have", self.energy, "percent energy left")

  def attack(self, enemy_robot, part_to_use, part_to_attack):
    enemy_part = enemy_robot.parts[part_to_attack]
    energy_before_attack = enemy_part.defense_level
    
    enemy_part.defense_level -= self.parts[part_to_use].attack_level
    self.energy -= self.parts[part_to_use].energy_consumption
    
    if enemy_part.defense_level <= 0 and energy_before_attack >= 0:
      self.parts[part_to_use].energy_consumption *= 2
      print("Attacking with", self.parts[part_to_use].name, "on", enemy_part.name)
      
  def is_on(self):
    return self.energy >= 0
      
  def is_there_avaliable_parts(self):
    for part in self.parts:
      if part.is_avaliable():
        return True
    return False

  def print_status(self):
     print(self.color_code)
     str_robot = robot_art.format(**self.get_part_status())
     self.greet()
     self.print_energy()
     print(str_robot)
     print(colors["Black"])
  
  def get_part_status(self):
      part_status = {}
      for part in self.parts:
        status_dict = part.get_status_dict()
        part_status.update(status_dict)
      return part_status
    
def build_robot():
  robot_name = input("Robot name: ")
  color_code = choose_color()
  robot = Robot(robot_name, color_code)
  robot.print_status()
  return robot

def choose_color():
    print("Estos son los colores disponibles:")
    for color in colors:
        print(color)
    seleccion = input("Selecciona un color: ")
    if seleccion in colors:
        return colors[seleccion]
    else:
        print("Color no válido. Por favor selecciona uno de la lista.")
        return choose_color()
      
def play():
  playing = True
  print("Welcome to the game")
  print("Datas for player 1")
  robot_one = build_robot()
  print("Welcome to the game")
  print("Datas for player 2")
  robot_two = build_robot()
  rount = 0
  while playing:
    if rount % 2 == 0:
        current_robot = robot_one
        enemy_robot = robot_two
    else:
        current_robot = robot_two
        enemy_robot = robot_one
    current_robot.print_status()  
    print("What part should I use to attack?")
    part_to_use = input("Choose a number part:")
    part_to_use = int(part_to_use)
    if part_to_use >= 0 and part_to_use <= 5:
            print("Which part of the enemy should we attack?")
            part_to_attack = input("Choose an enemy part to attack: ")
            part_to_attack = int(part_to_attack)
            if part_to_attack >= 0 and part_to_attack <= 5:
                current_robot.attack(enemy_robot, part_to_use, part_to_attack)
                rount += 1
            else:
                print("Error: Invalid input for part to attack.")
    else:
        print("Error: Invalid input for part to use.")

    if not enemy_robot.is_on() or enemy_robot.is_there_avaliable_parts() == False:
            playing = False
            print("Congratulations, you won!")
            print(current_robot.name)
    #else:
        #print("Error: You cannot use more than 5 robot parts to attack.")
        #playing = False
play()
