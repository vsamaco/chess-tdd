require 'spec_helper'

module Chess
  describe Piece do
    let(:board) { double("Board") }
    let(:team) { TEAM_WHITE }
    subject { Piece.new({x: 0, y: 0, board: board, team: team}) }
    
    it "should have a location" do
      subject.location == [0, 0]
    end
    
    describe "#blocked?" do
      context "location is occupied" do
        it "should be true" do
          board.stub(:get_piece_at => double("Piece"))
          subject.blocked?(0, 1).should be_true
        end
      end
      
      context "location is empty" do
        it "should be false" do
          board.stub(:get_piece_at => nil)
          subject.blocked?(0, 1).should be_false
        end
      end
    end
    
    describe "#can_move_to?" do   
      before(:each) { board.stub(:get_piece_at => nil) }
      
      context "valid basic pawn move" do
        it "should return true" do
          subject.can_move_to?(0, 1).should be_true
        end
      end
      
      context "invalid basic pawn move" do
        it "should return false" do
          subject.can_move_to?(1, 0).should be_false
        end
      end
      
      context "pawn move at baseline" do
        it "should be true" do
          subject.x, subject.y = 0, 1
          subject.can_move_to?(0, 3).should be_true
        end
      end
      
      context "pawn move not at baseline" do
        it "should be false" do
          piece = Piece.new({x: 0, y: 0, board: board})
          piece.can_move_to?(0, 2).should be_false
        end
      end
      
      context "pawn is blocked" do
        before(:each) { board.stub(:piece_at? => true) }
        
        context "destination is occupied" do
          it "should be false" do
            piece = Piece.new({x: 0, y: 0, board: board})
            piece.can_move_to?(0, 1).should be_false
          end
        end
        
        context "route is blocked" do
          it "should be false" do
            piece = Piece.new({x: 0, y: 1, board: board})
            piece.can_move_to?(0, 3).should be_false
          end
        end
      end
    end
    
    describe "#team" do  
      before(:each) { board.stub(:get_piece_at => nil) }
      
      it "should belong a team" do
        subject.team.should == team
      end
      
      context "belongs to team black" do
        before(:each) do
          subject.team = TEAM_BLACK
          subject.x, subject.y = 0, 1
        end
        
        it "should move in south direction" do
          subject.can_move_to?(0, 0).should be_true
        end
        
        it "should not move in north direction" do
          subject.can_move_to?(0, 2).should be_false
        end 
      end
    end
    
    describe "#can_capture?" do
      context "opposite team piece to northeast" do
        it "should be true" do
          black_piece = Piece.new({x: 1, y: 1, team: TEAM_BLACK})
          board.stub(:get_piece_at => black_piece)
          subject.can_capture?(1, 1).should be_true
        end
      end
      
      context "opposite team piece to east" do
        it "should be false" do
          black_piece = Piece.new({x: 0, y: 1, team: TEAM_BLACK})
          board.stub(:get_piece_at => black_piece)
          subject.can_capture?(0, 1).should be_false
        end
      end
      
      context "same team piece to northeast" do
        it "should be false" do
          white_piece = Piece.new({x: 1, y: 1, team: TEAM_WHITE})
          board.stub(:get_piece_at => white_piece)
          subject.can_capture?(1, 1).should be_false
        end
      end
      
      context "no piece to northeast" do
        it "should be false" do
          board.stub(:get_piece_at => nil)
          subject.can_capture?(1, 1).should be_false
        end
      end
      
      context "belongs to black team" do
        before(:each) do 
          subject.team = TEAM_BLACK
          subject.x, subject.y = 0, 1
        end
        
        context "opposite team piece to southeast" do 
          it "should be true", :focus => true do
            white_piece = Piece.new({x: 1, y: 0, team: TEAM_WHITE})
            board.stub(:get_piece_at => white_piece)
            subject.can_capture?(1, 0).should be_true
          end
        end
        
        context "opposite team piece to northeast" do
          it "should be false" do
            white_piece = Piece.new({x: 1, y: 2, team: TEAM_WHITE})
            board.stub(:get_piece_at => white_piece)
            subject.can_capture?(1, 2).should be_false
          end
        end
      end
    end
  end  
  
  describe Board do
    let(:piece) { double("Piece") }
    subject{ Board.new({width: 8, height: 8}) }
    
    it "should have pieces" do
      subject.pieces.should be_an_instance_of(Array)
    end
    
    it "should have dimensions" do
      subject.dimensions.should == [8, 8]
    end
    
    describe "#add_piece" do
      context "when position is empty" do
        it "should be true" do
          piece.stub(:x => 0, :y => 0)
          subject.stub(:get_piece_at => nil)
          subject.add_piece(piece).should be_true
        end
      end
      
      context "when position is occupied" do
        it "should be false" do
          piece.stub(:x => 0, :y => 0)
          subject.stub(:get_piece_at => double("Piece"))
          subject.add_piece(piece).should be_false
        end
      end
      
      context "when position is outside dimensions" do
        it "should be false" do
          piece.stub(:x => 9, :y => 9)
          subject.add_piece(piece).should be_false
        end
      end
    end
    
    describe "#get_piece_at" do
      it "should return true if piece exists at location" do
        piece.stub(:location => [0, 0])
        subject.pieces << piece
        subject.get_piece_at(0, 0).should be_true
      end
      
      it "should return false if piece doesn't exists at location" do
        subject.get_piece_at(0,0).should be_false
      end
    end
  end
end