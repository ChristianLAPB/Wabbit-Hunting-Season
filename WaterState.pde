class WaterState extends State {
  int startTime = -1;

  void enterState(Rabbit bunny) {
    println("Entered the drinking state!");
  }
//Checks if the rabbit is beside a water tile, and then makes the rabbit wait 3 seconds to drink before changing states and making it move again to find home to rest
  void updateState(Rabbit bunny, TileType type) {
        if (startTime == -1) {
          startTime = millis();
        }
        int timeElapsed = millis() - startTime;
        if (timeElapsed >= 3000) {
          println("All hydrated!");
          bunny.switchState(new HomeState());
          startTime = -1;
        }

    else {
      if (bunny.path == null || bunny.pathIndex >= bunny.path.size()) {
    
        ArrayList<Node> newPath = getClosestTileDijkstra(bunny, TileType.Water);
        if (newPath != null) {
          bunny.path = newPath;
          bunny.pathIndex = 0;
        } 
        else {
          PVector wander = bunny.wander();
          bunny.applyForce(wander);
        }
      }
    }
  }
}
