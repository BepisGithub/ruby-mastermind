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

  def generate_guess
    # TODO: Add a conditional so that this random guess is only called if the codebreaker is an NPC
    if @npc == true
      @guess = random_guess
    else
      puts "The choices are #{@@choices}"
      puts "You will be asked to pick a choice from 1-6 four times to generate your code."
      arr = []
      4.times do
        choice = gets.chomp.to_i until choice.is_a? Integer
        choice -= 1
        arr.push(@@choices[choice])
      end
      puts "Your choices are #{arr}"
      arr
    end
  end

  def initialize(npc)
    @npc = npc
  end
  
end

# This will contain everything the one who is making the code needs to 1.) Store the code 2.) Respond to a check
class CodeMaker
  include Player
  attr_accessor :secret_code

  def initialize(npc)
    @npc = npc
    # TODO: ALlow the user to be a code maker, this is currently written with it being the NPC in mind
    @secret_code = []
    4.times { secret_code.push(@@choices.sample) }
  end

  def check(guess_arr)
    return "win" if guess_arr == @secret_code

    # Format of the response: an array which ,in no particular order, contains the key
    # The key is that a 2 indicates it is in the right place, a 1 indicates the colour is right but in the wrong place
    # A 0 means it was completely wrong
    result = []
    guess_arr.each_with_index do |guess, idx|
      if @secret_code.include? guess
        if @secret_code.index guess == idx
          result.push 2
        else
          result.push 1
        end
      else
        result.push 0
      end
    end
    result
  end

  def check_interpreter(arr)
    puts "----------------------------------"
    if arr == "win"
      puts "The codebreaker won!"
      return nil
    end
    arr.each do |result|
      case result
      when 0
        puts "A choice is completely wrong"
      when 1
        puts "A choice is right, but in the wrong place"
      when 2
        puts "A choice is right in the right place"
      end
    end
    puts "----------------------------------"
  end
end

# The game will do most of the leg work of passing the object's responses to each other
class Game
  # TODO: Complete functionality
  def initialize(breaker_npc)
    # For now, build it so that the computer generates the code and the player has to guess
    @breaker = CodeBreaker.new(breaker_npc)
    @maker = CodeMaker.new(!breaker_npc)
    @max_turns = 12
    @turns = 1
  end

  def round
    # The breaker's guess is retreived, then checked against the makers secret code
    # The return value of this check is stored in the result variable
    result = @maker.check @breaker.generate_guess
    @maker.check_interpreter result
    result
    # interpret and print results
    # Return the results
  end

  def play
    until @turns > @max_turns || @breaker.guess == @maker.secret_code # TODO: Replace "|| @breaker.guess == @maker.secret_code"
      # with a check at the end of the function that breaks if the result from the round function is a win
      round
      @turns += 1
    end
    if @breaker.guess == @maker.secret_code
      puts "The Codebreaker wins!"
    else
      puts "The Codemaker wins because you didn't guess the code!"
    end
    # TODO: Print who won and then ask to play again
  end
end
game = Game.new(false)
game.play