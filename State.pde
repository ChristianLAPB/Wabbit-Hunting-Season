abstract class State {

  abstract void enterState(Rabbit bunny);
  
  abstract void updateState(Rabbit bunny, TileType type);
  
}
