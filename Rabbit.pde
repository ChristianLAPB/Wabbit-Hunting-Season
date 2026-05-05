class Rabbit extends Character {
  
  State currentState;
  
  ArrayList<Node> path = new ArrayList<Node>();
  int pathIndex = 0;
  //Defaults each rabbit to the wander state
  Rabbit() {
    currentState = new WanderState();
    currentState.enterState(this);
  }
  //Used to follow the path that is outputted by the Dijkstra function 
  void followPath() {
    if (path == null || pathIndex >= path.size()) return;
  
    Node targetNode = path.get(pathIndex);
    PVector targetPos = targetNode.getTileCenter();
  
    int tx = int(targetPos.x / tileSize);
    int ty = int(targetPos.y / tileSize);
  
    tx = constrain(tx, 0, cols - 1);
    ty = constrain(ty, 0, rows - 1);
  
    if (world[tx][ty].isBlocked()) {
      path = null;
      pathIndex = 0;
      return;
    }
  
    PVector dir = PVector.sub(targetPos, location);
  
    if (dir.mag() < 2) {
      pathIndex++;
      return;
    }
  
    dir.normalize();
    dir.mult(2);
  
    velocity = new PVector(0, 0);
  
    location.add(dir);
  }
  //Updates what tile the rabbit is on and moves each rabbit
  void updateBunny(TileType type) {

    super.update();
  
    Tile currentTile = getTile();
  
    if (currentTile.type == TileType.Trap) {
  
      currentTile.setType(TileType.Trapped);
  
      trapped.rewind();
      trapped.play();
  
      switchState(new TrappedState());
      return; 
    }
  
    currentState.updateState(this, type);
  
    if (path != null && pathIndex < path.size()) {
      followPath();
    }
 }
 //Switches the state the rabbit is in
 void switchState(State state) {
    path = null;                
    pathIndex = 0;
  
    velocity = new PVector(0,0); 
  
    currentState = state;
    state.enterState(this);
  }
}
