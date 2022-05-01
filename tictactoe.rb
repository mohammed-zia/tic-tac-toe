# frozen_string_literal: true

# This is a tic-tac-toe game played in the CLI. Player 1 (X) always goes first.
# I may eventually refactor this (when I gain more exp) to make better use of OOP principles.
# I especially think that there must be a way to track the current player better inside the Game instance
# but couldn't figure it out.

# We'll have a class from which we can create a board object
class Board
  @@new_board = { '1': ' ', '2': ' ', '3': ' ',
                  '4': ' ', '5': ' ', '6': ' ',
                  '7': ' ', '8': ' ', '9': ' ' }
  attr_accessor :board, :moves, :allowable_moves

  def initialize
    puts "Let's play tic-tac-toe!"
    @board = @@new_board
    @moves = []
    @allowable_moves = ('1'..'9')
  end

  def print_board
    puts "  #{@board['1']} |  #{@board['2']}  | #{@board['3']}  "
    puts '--------------'
    puts "  #{@board['4']} |  #{@board['5']}  | #{@board['6']}  "
    puts '--------------'
    puts "  #{@board['7']} |  #{@board['8']}  | #{@board['9']}  "
  end

  def place_marker(player, position)
    @board[position] = player.marker
  end

  def game_won?(player)
    win_slices = [
                  # HORIZONTAL WIN SLICES
                  [@board['1'], @board['2'], @board['3']],
                  [@board['4'], @board['5'], @board['6']],
                  [@board['7'], @board['8'], @board['9']],
                  # VERTICAL WIN SLICES
                  [@board['1'], @board['4'], @board['7']],
                  [@board['2'], @board['5'], @board['8']],
                  [@board['3'], @board['6'], @board['9']],
                  # DIAGONAL WIN SLICES
                  [@board['1'], @board['5'], @board['9']],
                  [@board['3'], @board['5'], @board['7']]
                  ]
    win_slices.each do |slice|
      if slice.all? { |val| val == player.marker }
        return true
      end
    end
  end
end

# We'll create a player class to create instances of players for each marker
class Player
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

# We'll create a game class to keep track of the current game instance
class Game
  attr_accessor :turns

  def initialize
    @turns = 9
  end
end

def start_game
  game = Game.new
  player1 = Player.new('X')
  player2 = Player.new('O')
  board = Board.new
  player = player1
  while game.turns.positive?
    play_round(player, board, game)
    if board.game_won?(player) == true
      board.print_board
      game_over(player)
    else
      if player.marker == "X"
        player = player2
      else
        player = player1
      end
      game.turns -= 1
    end
  end
end

def play_round(player, board, game)
  puts board.print_board
  desired_placement = gets.chomp
  if board.moves.none?(desired_placement) && board.allowable_moves.one?(desired_placement)
    board.place_marker(player, desired_placement)
    board.moves.push(desired_placement)
  else
    puts 'Invalid move'
    game.turns += 1
    play_round(player, board, game)
  end
end

def game_over(player)
  puts "Game over! #{player.marker} wins!"
  exit
end

start_game
