class FoodState extends State {
  int startTime = -1;

  void enterState(Rabbit bunny) {
    println("Entered the eating state!");
  }
  //checks if the rabbit is on a food tile, and makes it wait 3 seconds before finishing eating and deleting the food tile and creating a new one. 
  //If it enters the state (which it kept doing for no reason) and is not on a food tile, it will find a food tile. After it waits 3 seconds it switches to the waterState to go drink water
  void updateState(Rabbit bunny, TileType type) {
    if (type == TileType.Food) {
      bunny.velocity = new PVector(0,0);
      if (startTime == -1) {
        startTime = millis();
      }
      int timeElapsed = millis() - startTime;
      if (timeElapsed >= 3000) {
        println("All full!");
        bunny.path = null;
        bunny.pathIndex = 0;
        
        Tile currentTile = bunny.getTile();
        currentTile.setType(TileType.Empty);
        getRandomValidTile().setType(TileType.Food);
      
        bunny.switchState(new WaterState());
        startTime = -1;
      }
    } 
    else {
      if (bunny.path == null || bunny.pathIndex >= bunny.path.size()) {
        bunny.path = getClosestTileDijkstra(bunny, TileType.Food);
        println(getClosestTileDijkstra(bunny, TileType.Food));
        bunny.pathIndex = 0;
      }
    }
  }
}
