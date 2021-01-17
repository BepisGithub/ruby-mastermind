# I don't have a player class to inherit from at the time of writing this comment
# THis is because I don't see any shared functionality between them
# The code maker must generate and store a code, then compare a given input with it and output the response
# The code breaker must create a sequence and the game must pass it to see if it matches up
# If it does then the breaker wins but if not then the maker returns some information about the positions of the colours

# This module contains things the players will need
module Player
  @@choices = ["white", "black", "red", "blue", "orange", "green"] # Need 6
end

class CodeBreaker
  include Player
  attr_accessor :guess

  def random_guess
    [@@choices.sample, @@choices.sample, @@choices.sample, @@choices.sample]
  end

  def initialize
    @guess = random_guess
  end
end

# This will contain everything the one who is making the code needs to 1.) Store the code 2.) Respond to a check
class CodeMaker
  include Player
  attr_accessor :secret_code

  def initialize
    # TODO: ALlow the user to be a code maker, this is currently written with it being the NPC in mind
    @secret_code = []
    4.times { secret_code.push(@@choices.sample) }
  end

  def check(guess)
    return "win" if guess == @secret_code
    # TODO: Complete the functionality by adding checks and return values based upon certain conditions
  end
end

# The game will do most of the leg work of passing the object's responses to each other
class Game
  # TODO: Complete functionality
  def initialize
    # For now, build it so that the computer generates the code and the player has to guess
    @breaker = CodeBreaker.new
    @maker = CodeMaker.new
    @max_turns = 12
    @turns = 1
  end

  def round

  end

  def play
    until @turns>@MAX_TURNS
      round
      @turns += 1
    end
  end
end