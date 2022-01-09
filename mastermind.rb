# frozen_string_literal: true

require 'rainbow'

# contains message and common methods
module Common
  MESSAGE = "Guess the sequence of 4 colors. Enter #{Rainbow('R').red} for #{Rainbow('red').red}, "\
  "#{Rainbow('B').blue} for #{Rainbow('blue').blue}, #{Rainbow('G').green} for #{Rainbow('green').green}, or "\
  "#{Rainbow('Y').yellow} for #{Rainbow('yellow').yellow}"

  def color_picker(sequence, num)
    case num
    when 1
      sequence.push(Rainbow('•').red)
    when 2
      sequence.push(Rainbow('•').blue)
    when 3
      sequence.push(Rainbow('•').green)
    when 4
      sequence.push(Rainbow('•').yellow)
    end
  end
end

# creates the game
class Game
  attr_accessor :master, :guess, :ordered_common, :unordered_common, :clue

  def initialize
    @master = MasterCode.new
    @guess = Guess.new
    @ordered_common = []
    @unordered_common = []
    @clue = %w[- - - -]
  end

  # contains gameplay
  def play
    @master.frice
    @guess.take_colors
    self.partial_ordered_success
    self.partial_unordered_success
    puts self.cluer
  end

  # checks if the player has won
  def total_success?
    @master.numbers == @guess.numbers
  end

  # checks if the player has guessed a correct color in the correct spot
  def partial_ordered_success
    0.upto(3) do |number|
      @ordered_common.push(number) if @master.numbers[number] == @guess.numbers[number]
    end
    @ordered_common
  end

  # checks if the player has guessed a correct color
  def partial_unordered_success
    mutable_numbers = Array.new(@master.numbers)
    0.upto(3) do |number|
      if mutable_numbers.include?(@guess.numbers[number]) && @ordered_common.none? { |num| num == number }
        mutable_numbers.delete(@guess.numbers[number])
        @unordered_common.push(number)
      end
    end
    @unordered_common
  end

  def cluer
    @ordered_common.each { |index| @clue[index] = @master.sequence[index] }
    @unordered_common.each { |index| @clue[index] = '◦' }
    @clue.join
  end

  # creates the 'master code' sequence of colors
  class MasterCode
    include Common
    attr_accessor :sequence, :numbers

    def initialize
      @sequence = []
      @numbers = []
    end

    # saves the number that a color corresponds to in the @numbers array & converts each number into a color to be
    # stored in the @sequence array
    def color_saver(sequence, num, numbers)
      numbers.push(num)
      color_picker(sequence, num)
    end

    def frice
      4.times { color_saver(@sequence, rand(1..4), @numbers) }
    end
  end

  # creates the player's color sequence guesses
  class Guess
    include Common
    attr_accessor :numbers, :sequence

    def initialize
      @sequence = nil
      @numbers = []
    end

    # allows the player to guess a sequence; invalid input detection built-in
    def take_colors
      puts MESSAGE
      @sequence = gets.chomp.upcase.split('')
      allowed = %w[R B G Y]
      if @sequence.all? { |letter| allowed.include?(letter) } && @sequence.length == 4
        @numbers = @sequence.map { |letter| self.letter_to_num(letter) }
        @sequence = []
        @numbers.map { |number| color_picker(@sequence, number) }
      else
        'Invalid input'
      end
    end

    # converts the player's letter guesses into numbers
    def letter_to_num(letter)
      case letter
      when 'R'
        1
      when 'B'
        2
      when 'G'
        3
      when 'Y'
        4
      end
    end
  end
end
