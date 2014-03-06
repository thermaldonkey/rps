class Gesture
  SYMBOLS ||= [?R, ?P, ?S]

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
  attr_reader :win

  def initialize gesture1, gesture2
    if Gesture.new(gesture2).beats?(gesture1)
      @win = -1
    elsif Gesture.new(gesture1).beats?(gesture2)
      @win = 1
    else
      @win = 0
    end
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
    @current_turn_result = nil
  end

  def play
    return nil if @player1.empty_turn? && @player2.empty_turn?
    @player1.turns.length.times do |turn|
      decide_winner(turn)
      award_winner_score
    end
    display_scores
  end

  def decide_winner turn
    @current_turn_result = Turn.new(@player1.turns[turn], @player2.turns[turn]).win
  end

  def award_winner_score
    if @current_turn_result < 0
      @player2.wins += 1
    else
      @player1.wins += @current_turn_result
    end
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
