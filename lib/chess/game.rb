module Chess
  TEAM_WHITE = "white"
  TEAM_BLACK = "black"
  
  class Piece
    attr_accessor :x, :y, :board, :team
    
    def initialize(params=[])
      @x,@y = params[:x], params[:y]
      @board = params[:board] || nil
      @team = params[:team] || nil
    end
    
    def location
      [@x, @y]
    end
    
    def can_move_to?(x, y)
      if blocked?(x, y)
        return false
      end
      
      return valid_move_distance?(x, y)
    end
    
    def valid_move_distance?(x, y)      
      # only move vertically
      x == @x && y - @y == move_direction
    end
    
    def direction
      (@team == TEAM_WHITE ? 1 : -1)
    end
    
    def move_direction
      if at_baseline?
        return 2 * direction
      else
        return 1 * direction
      end
    end
    
    def at_baseline?
      y == board.get_baseline(@team)
    end
    
    def blocked?(x, y)
      board.get_piece_at(x, y) || route_blocked?(x, y) # check destination and route
    end
    
    def route_blocked?(x, y)
      if at_baseline? && board.get_piece_at(x, y + direction) # check 1 space in direction
        return true
      end
      
      return false
    end
    
    def can_capture?(x, y)
      piece = board.get_piece_at(x, y)
      
      return valid_capture_piece?(piece) && valid_capture_distance?(x, y)
    end
    
    def valid_capture_piece?(piece)
      piece && piece.team != @team
    end
    
    def valid_capture_distance?(x, y)
      # slope formula y2 - y1 / x2 - x2
      rise = y - @y
      run = x - @x
      
      if run == 0 # cannot capture on same axis
        return false
      end
      
      # slope must match direction of piece
      return rise/run == 1 * direction

    end
  end
  
  class Board
    attr_accessor :pieces, :width, :height, :baseline
    
    def initialize(params={})
      @pieces = Array.new
      @width, @height = params[:width], params[:height]
      
      @baseline = {}
      @baseline[TEAM_WHITE] = 1
      @baseline[TEAM_BLACK] = @height - 1
    end
    
    def add_piece(piece)
      if valid_location?(piece.x, piece.y) && get_piece_at(piece.x, piece.y) == nil
        @pieces << piece
        return true
      else
        return false
      end
    end
    
    def get_piece_at(x, y)
      @pieces.detect { |piece| piece.location == [x,y] }
    end
    
    def dimensions
      [@width, @height]
    end
    
    def valid_location?(x, y)
      x.between?(0, @width) && y.between?(0, @height)
    end
    
    def get_baseline(team)
      @baseline[team]
    end
  end
  
  class Game
  end
end