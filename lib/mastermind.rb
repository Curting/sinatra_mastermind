class MasterMind

  attr_accessor :guess, :feedback, :code, :guess_count

  def initialize
    @code = []
    @guess = []
    @guess_count = 0
    @rounds = 8
    @feedback = []

    generate_code
  end

  def reset
    @guess_count = 0
    @rounds = 8
    @guess = []
    @feedback = []
    @code = []
    
    generate_code
  end

  def valid_input?(input)
    input.length == 4 &&  valid_number_range?(input)
  end

  def valid_number_range?(input) # Refactor
    input.all? { |number| number.between?(1, 6) }
  end

  def evaluate(input, answer)
    feedback = [0, 0, 0, 0]
    # Duplicate temp_code so it doesn't point directly to @code (destructive)
    temp_code = answer.dup

    # Correct color and position = -2
    temp_code.each_with_index do |x, index|
      if x == input[index]
        feedback[index] = -2
        # Remove the used color (to avoid false duplicates)
        temp_code[index] = nil
      end
    end

    # Correct color but WRONG position = -1
    input.each_with_index do |x, index|
      if temp_code.include?(x) && feedback[index] != -2
        feedback[index] = -1
        # Remove the used color by finding the index
        temp_code[temp_code.index(x)] = nil
      end
    end

    feedback
  end

  def lost?
    @guess_count >= @rounds
  end

  def won?
    @guess.last == @code
  end

  def game_over?
    won? || lost?
  end

end


class Codebreaker < MasterMind

  def generate_code
    4.times { @code << rand(1..6) }
  end

  def guess_and_evaluate(guess)
    # if @guess_count == 0
    #   puts "What's your first guess?"
    # else
    #   puts "You've got #{@rounds - @guess_count} guesses left."
    #   puts "What's your next guess?"
    # end
    # Extract numbers (strings in array) and turn them into integers

    if valid_input?(guess)
      @feedback << evaluate(guess, @code)
      # show_board
      @guess_count += 1
    else
      puts "What? I don't understand that. Give me 4 numbers between 1-6, please."
      guess_and_evaluate
    end
  end
  
end

class Integer
  def to_color
    case self
    when -2 then "black"
    when -1 then "white"
    when 0 then "gray"
    when 1 then "red"
    when 2 then "blue"
    when 3 then "green"
    when 4 then "yellow"
    when 5 then "orange"
    when 6 then "purple"
    end
  end
end