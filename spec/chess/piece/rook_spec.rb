module Chess
  describe RookPiece do
    let(:board) { double("Board", :get_piece_at => nil, :get_baseline => nil) }
    let(:team) { TEAM_WHITE }
    subject { RookPiece.new({x: 0, y: 0, board: board, team: team}) }
    
    describe "#can_move_to?" do
      context "moves vertical spaces" do
        it "should return true" do
          board.stub(:get_piece_at => nil)
          subject.can_move_to?(0,5).should be_true
        end
      end
      
      context "moves horizontal spaces" do
        it "should return false" do
          subject.can_move_to?(5,0).should be_false
        end
      end
      
      context "moves diagonal spaces" do
        it "should return false" do
          subject.can_move_to?(5,5).should be_false
        end
      end
      
      context "location is blocked" do
        it "should return false" do
          board.stub(:get_piece_at).with(0,5).and_return(double("Piece"))
          subject.can_move_to?(0,5).should be_false
        end
      end
      
      context "route is blocked" do
        it "should return false" do
          board.stub(:get_piece_at).with(0,3).and_return(double("Piece"))
          subject.can_move_to?(0,5).should be_false
        end
      end
    end
    
    describe "#can_capture?" do
      context "opposite team piece to north" do
        it "should return true" do
          black_piece = Piece.new({x: 0, y: 3, team: TEAM_BLACK})
          board.stub(:get_piece_at).with(0,3).and_return(black_piece)
          subject.can_capture?(0,3).should be_true
        end
      end
      
      context "opposite team piece to east" do
        it "should return false" do
          black_piece = Piece.new({x: 3, y: 0, team: TEAM_BLACK})
          board.stub(:get_piece_at).with(3,0).and_return(black_piece)
          subject.can_capture?(3,0).should be_false
        end
      end
      
      context "same team piece to north" do
        it "should return false" do
          white_piece = Piece.new({x: 0, y: 3, team: TEAM_WHITE})
          board.stub(:get_piece_at => white_piece)
          subject.can_capture?(0,3).should be_false
        end
      end
      
      context "opposite team piece to north but blocked" do
        it "should return false" do
          black_piece = Piece.new({x: 0, y: 3, team: TEAM_BLACK})
          white_piece = Piece.new({x: 0, y: 2, team: TEAM_WHITE})
          board.stub(:get_piece_at).with(0,3).and_return(black_piece)
          board.stub(:get_piece_at).with(0,2).and_return(white_piece)
          
          subject.can_capture?(0,3).should be_false
        end
      end
    end
  end
end