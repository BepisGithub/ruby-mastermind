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
      puts "You will be asked to pick a choice four times to generate your code." # TODO: Potentially only allow the user
      arr = []
      4.times do |n|
        puts "Enter guess number #{n + 1}"
        choice = gets.chomp.downcase.strip until @@choices.include? choice
        arr.push(choice)
      end
      puts "Your choices are #{arr}"
      @guess = arr
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

  # This function takes the guess array and converts it into a hash
  # The has contains the key as the guess colour and the indexes of the colour in the guess as a value
  def array_to_hash(guess_arr)
    guess_hash = {}
    guess_arr.each_with_index do |guess, guess_idx|
      if guess_hash[guess].nil?
        guess_hash[guess] = [guess_idx]
      else
        guess_hash[guess].push(guess_idx)
      end
    end
    guess_hash
  end

  # This function takes the guess hash and deletes indexes of duplicate guesses if there
  # are more guesses of a colour than the number of them in the secret code
  def delete_extra_guesses(guess_hash)
    guess_hash.each do |k, v|
      # v.each do |index|
      #   next if @secret_code[index] == k
      #   v.delete_at index if (@secret_code.count k).to_i < (v.length.to_i)
      #   p index
      # end
      v.select! { |index| (@secret_code.count k).to_i > (v.length.to_i) || @secret_code[index] == k }
    end
  end

  def check(guess_arr)
    puts "---------------------------------------------"
    return "win" if guess_arr == @secret_code

    # REFACTOR
    guess_hash = array_to_hash guess_arr
    delete_extra_guesses guess_hash
    @secret_code.each_with_index do |secret, index|
      # REFACTOR
      if guess_hash.key? secret # Check if the guess includes the value in the secret code
        if guess_hash[secret].include? index # If the guess is at the exact location
          puts "A colour is at exactly the right place"
          guess_hash[secret].delete_at index
        else # If the guess is at the wrong location
          puts "A colour is right but at the wrong place"
          # TODO: Potentially delete one of the values in the array
          guess_hash[secret].each_with_index do |value, idx|
            if @secret_code[value] == secret
              next
            else
              guess_hash[secret].delete_at idx
              break
            end
          end
        end


      end
    end

  puts "---------------------------------------------"
  end
end

# The game will do most of the leg work of passing the object's responses to each other
class Game
  def initialize(breaker_npc)
    # For now, build it so that the computer generates the code and the player has to guess
    @breaker_npc = breaker_npc
    @breaker = CodeBreaker.new(breaker_npc)
    @maker = CodeMaker.new(!breaker_npc)
    @max_turns = 12
    @turns = 1
  end

  def round
    # The breaker's guess is retreived, then checked against the makers secret code
    # The return value of this check is stored in the result variable
    @maker.check @breaker.generate_guess
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
      puts "The Codemaker wins because you didn't guess the code! The code was #{@maker.secret_code}"
    end
    puts "That was fun, would you like another go? (yes/no)"
    choice = gets.chomp.downcase
    if choice == "yes"
      game = Game.new(@breaker_npc) # TODO: Get the input for the choice. e.g. make a get choice method, then initialize the game and from the init call the get choice method
      game.play
    end
  end
end
game = Game.new(false)
game.play