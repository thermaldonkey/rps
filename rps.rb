class FalseClass; def to_i; 0 end end
class TrueClass; def to_i; 1 end end

class Gesture
  SYMBOLS = [?R, ?P, ?S]

  attr_reader :symbol

  def initialize symbol
    @symbol = symbol
    @beats = SYMBOLS[ (SYMBOLS.index(symbol) + 2) % 3 ]
  end

  def beats? symbol
    @beats == symbol
  end
end

class Turn
  attr_reader :score

  def initialize gesture1, gesture2
    @score = [ Gesture.new(gesture1).beats?(gesture2).to_i, Gesture.new(gesture2).beats?(gesture1).to_i ]
  end
end

class Player
  attr_reader :turns
  attr_accessor :wins

  def initialize turns
    @turns = turns
    @wins = 0
  end

  def empty_turn?
    @turns == "E"
  end
end

class Game
  def initialize p1_turns, p2_turns
    @player1 = Player.new(p1_turns)
    @player2 = Player.new(p2_turns)
  end

  def play
    return nil if @player1.empty_turn? && @player2.empty_turn?
    @player1.turns.length.times do |turn|
      award_winner_score( decide_winner(turn) )
    end
    display_scores
  end

  def decide_winner turn
    Turn.new(@player1.turns[turn], @player2.turns[turn]).score
  end

  def award_winner_score turn_result
    @player1.wins += turn_result.first
    @player2.wins += turn_result.last
  end

  def display_scores
    puts "P1: #{@player1.wins}"
    puts "P2: #{@player2.wins}"
  end
end

File.open("rps.in", "r") do |f|
  while not f.eof?
    Game.new(f.readline.strip, f.readline.strip).play
  end
end
