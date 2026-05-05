class TrappedState extends State {
  //When a rabbit gets trapped, values that impact the score board get updated and the rabbit is turned invisible
  void enterState(Rabbit bunny) {
    println("Entered the trapped state");
    bunny.isVisible = false;
    trappedCount++;
    rabbits--;
    println(trappedCount);
  }
  
  void updateState(Rabbit bunny, TileType type) {
    bunny.velocity = new PVector(0,0);
  }
}
