Chess RSpec
===========

By: Vincent Samaco

11/20/12

A code example of modeling elements of the game of chess.  Using TDD with RSpec, 
the code demonstrates the movements and captures by pawn.

## Pawn Behavior

* moves forward one space depending on team
* moves forward two spaces if on baseline (second row from team side)
* move is valid if destination and route is not blocked
* white team moves north direction and black team moves south direction
* capture opposing team piece if one space diagonally

## Setup
1. gem install rspec
2. rspec spec

