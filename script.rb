# I don't have a player class to inherit from at the time of writing this comment
# THis is because I don't see any shared functionality between them
# The code maker must generate and store a code, then compare a given input with it and output the response
# The code breaker must create a sequence and the game must pass it to see if it matches up
# If it does then the breaker wins but if not then the maker returns some information about the positions of the colours

class Player
  choices = ["white", "black", "red", "blue", "orange", "green"] # Need 6
end

class CodeBreaker < Player

end

class CodeMaker < Player
  def initialize
    # TODO: ALlow the user to be a code maker, this is currently written with it being the NPC in mind
  end
end


class Game
  def initialize
    # For now, build it so that the computer generates the code and the player has to guess
    breaker = CodeBreaker.new
    maker = CodeMaker.new
  end

end