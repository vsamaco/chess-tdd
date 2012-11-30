module Chess
  class RookPiece < Piece
    def valid_move_distance?(x,y)
      x == @x # only move vertical spaces, x must be same
    end
    
    def route_blocked?(x,y)
      (@y+1...y).each do |ystep|
        if board.get_piece_at(x, ystep)
          return true
        end
      end
      
      false
    end
    
    def valid_capture_distance?(x, y)
      valid_move_distance?(x,y) && route_blocked?(x,y) == false
    end
    
    # alias parent_blocked? blocked?
    # def blocked?(x,y)
    #   parent_blocked?(x,y)
    # end
  end
end