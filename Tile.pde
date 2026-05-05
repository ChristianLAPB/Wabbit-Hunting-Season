enum TileType {
  Food,
  Water,
  Forest,
  Mountain,
  Home,
  Trap,
  Trapped,
  Empty
}

class Tile {
  
  PVector location;
  float size;
  
  PImage sprite;
  
  TileType type;
  color fillcolor;
  
  Tile(float x, float y, float mSize) {
    location = new PVector(x,y);
    size = mSize;
    setType(TileType.Empty);
    
  }
  
  PVector getTileCenter() {
    return new PVector(location.x + size/2, location.y + size/2);
  }
  //Sets the tile types
  void setType(TileType t) {
    type = t;
    
    switch (type) {
      case Food:
        sprite = foodSprite;
        break;
      case Water:
        sprite = waterSprite;
        break;
      case Forest:
        sprite = forestSprite; 
        break;
      case Mountain:
        sprite = mountainSprite; 
        break;
      case Home:
        sprite = homeSprite;
        break;
      case Trap:
        sprite = trapSprite;
        break;
      case Trapped:
        sprite = trappedSprite;
        break;
      case Empty:
        sprite = null;
        break;
    }
  }
  //Takes the blocked tiles from the grpah and converts them into water tiles
  boolean isBlocked() {
    return type == TileType.Water;
  }
  //Displays the sprite/colour for each tile
  void display() {
    noStroke();
    
    imageMode(CORNER);
  
    if (type == TileType.Water) {
      image(waterSprite, location.x, location.y, size, size);
    } 
    else if (type == TileType.Forest) {
      image(forestSprite, location.x, location.y, size, size);
    }
    else if (type == TileType.Mountain) {
      image(mountainSprite, location.x, location.y, size, size);
    }
    else if (type == TileType.Empty) {
      fill(20, 80, 40);
      rect(location.x, location.y, size, size);
    } 
    else if (type == TileType.Food) {
      image(foodSprite, location.x, location.y, size, size);
    } 
    else if (type == TileType.Home) {
      image(homeSprite, location.x, location.y, size, size);
    } 
    else if (type == TileType.Trap) {
      image(trapSprite, location.x, location.y, size, size);
    }
    else if (type == TileType.Trapped) {
      image(trappedSprite, location.x, location.y, size, size);
    }
  }
}
