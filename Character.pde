class Character {
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  float topspeed;
  
  float mass = 1;
  float maxforce = 0.05;
  float wanderAngle = 0;
  
  PImage sprite;
  
  boolean isVisible = true;
  
  Character() {
    location = new PVector(random(width),random(height));
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    topspeed = 3;
  }
  
  /**
  Display character
  **/
  void display() {
    
    if (isVisible == false){
      return;
    }
    
    pushMatrix();
    translate(location.x, location.y);
    
    sprite = rabbitSprite;
    
    imageMode(CENTER);
    image(sprite, 0, 0, tileSize, tileSize);
    popMatrix();
  }

  /*
  Apply steering force
  */
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  /*
  Update character's physics
  */
  void update() {
    velocity.add(acceleration);
    velocity.limit(topspeed);
  
    PVector nextPos = PVector.add(location, velocity);
  
    if (nextPos.x >= width) nextPos.x = 0;
    if (nextPos.x < 0) nextPos.x = width - 1;
    if (nextPos.y >= height) nextPos.y = 0;
    if (nextPos.y < 0) nextPos.y = height - 1;
  
    int tx = int(nextPos.x / tileSize);
    int ty = int(nextPos.y / tileSize);
  
    tx = constrain(tx, 0, cols - 1);
    ty = constrain(ty, 0, rows - 1);
  
    if (!world[tx][ty].isBlocked()) {
      location = nextPos.copy();
    } 
    else {
      PVector tryX = new PVector(velocity.x, 0);
      PVector posX = PVector.add(location, tryX);
  
      if (posX.x >= width) posX.x = 0;
      if (posX.x < 0) posX.x = width - 1;
  
      int txX = constrain(int(posX.x / tileSize), 0, cols - 1);
      int tyX = constrain(int(posX.y / tileSize), 0, rows - 1);
  
      if (!world[txX][tyX].isBlocked()) {
        location = posX.copy();
      } else {
        PVector tryY = new PVector(0, velocity.y);
        PVector posY = PVector.add(location, tryY);
  
        if (posY.y >= height) posY.y = 0;
        if (posY.y < 0) posY.y = height - 1;
  
        int txY = constrain(int(posY.x / tileSize), 0, cols - 1);
        int tyY = constrain(int(posY.y / tileSize), 0, rows - 1);
  
        if (!world[txY][tyY].isBlocked()) {
          location = posY.copy();
        } else {
          velocity.mult(-0.5);
  
          PVector randomPush = PVector.random2D();
          randomPush.mult(1.5);
          velocity.add(randomPush);
        }
      }
    }
  
    acceleration.mult(0);
  }
  
  /* 
  Seek steering behaviour
  */
  PVector seek(PVector target) {
    
    PVector desired = PVector.sub(target,location);
    desired.normalize();
    desired.mult(topspeed);
    
    PVector steer = PVector.sub(desired,velocity);
    
    steer.limit(maxforce);
    return steer;
    
  }
  
  /*
  Wander steering behaviour
  */
  PVector wander() {
  
    float wanderRadius = 25;         
    float wanderDist = 80;         
    float change = 0.3;
    
    PVector prediction = velocity.copy();
    prediction.normalize();
    prediction.mult(wanderDist);
    prediction.add(location);
    
    wanderAngle += random(-change, change);
    
    float currentDirection = atan2(velocity.y, velocity.x);
    float newDirection = currentDirection + wanderAngle;
    
    float x = wanderRadius * cos(newDirection);
    float y = wanderRadius * sin(newDirection);
    
    PVector targetOffset = new PVector(x, y);
    PVector target = PVector.add(prediction, targetOffset);
    
    return seek(target);
  }
  
  /*
  Arrive steering behaviour
  */
  PVector arrive(PVector target, float r) {
    PVector desired = PVector.sub(target,location);
    float distance = desired.mag();
    desired.normalize();
    
    if (distance < r) {
      float speed = (distance/r) * topspeed;
      desired.mult(speed);
    } else {
      desired.mult(topspeed);
    }
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    return steer;
    
  }
  
  /**
  Get the tile the character is on
  */
  Tile getTile() {
    int tileX = floor(location.x / tileSize);
    int tileY = floor(location.y / tileSize);
  
    tileX = constrain(tileX, 0, cols - 1);
    tileY = constrain(tileY, 0, rows - 1);
  
    return world[tileX][tileY];
  }
  
  /*
  Test if the character has stopped moving
  */
  boolean stopped() {
    return (velocity.mag() < 0.01);
  }
}
