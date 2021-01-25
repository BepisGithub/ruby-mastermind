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

  def generate_guess(result)
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
      guess_hash.reject! { |k| (@secret_code.count k) == 0  } # Getting rid of key colours not present in the secret code
    end
    guess_hash.each do |k, v|
      num_extra_guesses = v.length - (@secret_code.count k) # How many more of a colour there are in the guess vs the secret code
      if num_extra_guesses < 1 # If there aren't any extra then skip to the next colour
        next
      else
        while num_extra_guesses >= 1 # While there are too many
          v.each do |item|
            if @secret_code[item] == k
              next
            else
              v.delete_at(v.index(item)) # If the index is not the exact one, delete it
              num_extra_guesses -= 1
              break
            end
          end
        end
      end
    end
  end

  def check_interpreter(results)
    puts "---------------------------------------------"
    results.shuffle.each do |result|
      puts "A colour is at exactly the right place" if result == 2
      puts "A colour is right but at the wrong place" if result == 1
    end
    puts "---------------------------------------------"
  end

  def check(guess_arr)
    return "win" if guess_arr == @secret_code

    results = []
    guess_hash = array_to_hash guess_arr
    delete_extra_guesses guess_hash

    guess_hash.each do |k, arr|
      arr.each do |index|
        if @secret_code[index] == k
          results.push 2
        else
          results.push 1
        end
      end
    end
    results
  end
end

# The game will do most of the leg work of passing the object's responses to each other
class Game
  include Player

  def initialize
    # For now, build it so that the computer generates the code and the player has to guess
    puts 'Would you like to be the Codemaker? (yes/no)'
    @breaker_npc = gets.chomp.downcase
    if @breaker_npc == 'yes'
      @breaker_npc = true
    else
      @breaker_npc = false
    end
    @breaker = CodeBreaker.new(@breaker_npc)
    @maker = CodeMaker.new(!@breaker_npc)
    @max_turns = 12
    @turns = 1
    @end_game = false
  end

  def round
    result = []
    if !@breaker_npc
      # The breaker's guess is retreived, then checked against the makers secret code
      # The return value of this check is stored in the result variable
      result = @maker.check @breaker.generate_guess nil
      unless result == 'win'
        @maker.check_interpreter result
      end
      # interpret and print results
      # Return the result
    else
      @breaker.generate_guess result
      puts "The breakers guess is #{@breaker.guess}"
      puts 'How many are the right colour in the right place? Enter a number '
      result = []
      right_place = gets.chomp.to_i until right_place.is_a?(Integer) && right_place < 5
      right_place.times do
        result.push 2
      end
      @end_game = true if result == [2, 2, 2, 2]
      unless @end_game == true
        puts 'How many are the right colour in the wrong place? Enter a number '
        wrong_place = gets.chomp.to_i until wrong_place.is_a?(Integer) && wrong_place <= (4-right_place)
        wrong_place.times do
          result.push 1
        end
      end
    end
  end

  def another
    puts "That was fun, would you like another go? (yes/no)"
    choice = gets.chomp.downcase
    if choice == "yes"
      game = Game.new
      game.play
    end
  end

  def play
    if !@breaker_npc # If the code breaker is a human
      until @turns > @max_turns || @breaker.guess == @maker.secret_code # TODO: Replace "|| @breaker.guess == @maker.secret_code"
        # with a check at the end of the function that breaks if the result from the round function is a win
        round
        @turns += 1
      end
      if @breaker.guess == @maker.secret_code
        puts "The Codebreaker wins! The secret code was #{@maker.secret_code}"
      else
        puts "The Codemaker wins because you didn't guess the code! The code was #{@maker.secret_code}"
      end
    else # If the code breaker is not a human
      puts 'Think of a 4 colour combination in your head'
      puts "The choices are #{@@choices}"
      until @turns > @max_turns || @end_game
        round
        @turns += 1
      end
      if @end_game
        puts 'The Codebreaker wins!'
      else
        puts 'The Codemaker wins because the Codebreaker didn\'t guess the code!'
      end
    end
    another
  end
end
game = Game.new
game.play
