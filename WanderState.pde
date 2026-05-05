class WanderState extends State {

  void enterState(Rabbit bunny) {
    println("Entered the wander state!");
  }
  void updateState(Rabbit bunny, TileType type) {
    if (type == TileType.Food) {
      bunny.switchState(new FoodState());
    }
    //If the rabbit goes on a trap tile, it changes the tile to a closed box, plays a sound and then changes the state to be trapped
    else if (type == TileType.Trap){
      Tile trapTile = bunny.getTile();
      trapTile.setType(TileType.Trapped);
      trapped.rewind(); 
      trapped.play();
      bunny.switchState(new TrappedState());
    }
    else {
      PVector wander = bunny.wander();
    
      PVector futureVel = PVector.add(bunny.velocity, wander);
      futureVel.limit(bunny.topspeed);
    
      PVector nextPos = PVector.add(bunny.location, futureVel);
    
      int tx = int(nextPos.x / tileSize);
      int ty = int(nextPos.y / tileSize);
    
      tx = constrain(tx, 0, cols - 1);
      ty = constrain(ty, 0, rows - 1);
    
      if (!world[tx][ty].isBlocked()) {
        bunny.applyForce(wander);
      } 
      else {
        PVector away = PVector.mult(futureVel, -1);
        bunny.applyForce(away);
      }
    }
  }
}
