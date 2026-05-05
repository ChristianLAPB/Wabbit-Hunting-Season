class HomeState extends State {
  int startTime = -1;

  void enterState(Rabbit bunny) {
    println("Entered the resting state!");
  }
  //checks if the rabbit is on a home tile, and makes it wait 3 seconds before it finishes resting. 
  //If it enters the state and is not on a home tile, it will find a home tile. After it waits 3 seconds it switches to the wanderState to potentially come across food
  void updateState(Rabbit bunny, TileType type) {
    if (type == TileType.Home) {
      bunny.velocity = new PVector(0,0);
      if (startTime == -1) {
        startTime = millis();
      }
      int timeElapsed = millis() - startTime;
      if (timeElapsed >= 3000) {
        println("All rested up!");
        bunny.switchState(new WanderState());
        startTime = -1;
      }
    } 
    else {
      if (bunny.path == null || bunny.pathIndex >= bunny.path.size()) {
        bunny.path = getClosestTileDijkstra(bunny, TileType.Home);
        bunny.pathIndex = 0;
      }
    }
  }
}
