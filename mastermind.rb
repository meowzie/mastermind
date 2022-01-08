# frozen_string_literal: true

require 'rainbow'

class Game
  # contains message
  module Game
    MESSAGE = "Guess the sequence of 4 colors. Enter #{Rainbow('R').red} for #{Rainbow('red').red}, "\
    "#{Rainbow('B').blue} for #{Rainbow('blue').blue}, #{Rainbow('G').green} for #{Rainbow('green').green}, or "\
    "#{Rainbow('Y').yellow} for #{Rainbow('yellow').yellow}"
  end

  # creates a sequence of colors
  class MasterCode
    attr_accessor :sequence, :compu_numbers

    def initialize
      @sequence = []
      @compu_numbers = []
    end

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

    def color_saver(sequence, num, numbers)
      numbers.push(num)
      color_picker(sequence, num)
    end

    def frice
      4.times { color_saver(@sequence, rand(1..4), @compu_numbers) }
      @sequence.join
    end
  end

  # creates the player's guesses
  class Guess
    include Game
    attr_accessor :playa_numbers, :sequence

    def initialize
      @sequence = nil
      @playa_numbers = []
    end

    def take_colors
      puts MESSAGE

      @sequence = gets.chomp.upcase.split('')
      allowed = %w[R B G Y]

      @sequence.all? { |letter| allowed.include?(letter) } && @sequence.length == 4 ? @sequence : 'Invalid input'
    end

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

    def number_adder
      @playa_numbers = @sequence.map { |letter| self.letter_to_num(letter) }
    end
  end
end
