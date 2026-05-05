import ddf.minim.*;

Tile[][] world;

ArrayList<Rabbit> bunnies;

int cols, rows, tileSize;

PImage foodSprite;
PImage homeSprite;
PImage trapSprite;
PImage rabbitSprite;
PImage trappedSprite;
PImage forestSprite;
PImage mountainSprite;
PImage waterSprite;

int trapCount = 0;
int maxTraps = 5;

int trappedCount = 0;
int rabbits = 5;

boolean gameOver = false;

int gameDuration = 60;
int startTime;

boolean timeUp = false;

Graphs graph;

Minim minim;
AudioPlayer trapped;
AudioPlayer music;
AudioPlayer win;
AudioPlayer place;
AudioPlayer lose;

void setup() {
  pixelDensity(1);
  
  size(900,900);
  surface.setIcon(loadImage("Icon.png"));
  //intializes the sound and sprites
  minim = new Minim(this);
  trapped = minim.loadFile("trapped.mp3");
  music = minim.loadFile("music.mp3");
  win = minim.loadFile("win.mp3");
  place = minim.loadFile("place.mp3");
  lose = minim.loadFile("lose.mp3");
  
  foodSprite = loadImage("food.png");
  homeSprite = loadImage("home.png");
  trapSprite = loadImage("trap.png");
  rabbitSprite = loadImage("rabbit.png");
  trappedSprite = loadImage("trapped.png");
  forestSprite = loadImage("forest.png");
  mountainSprite = loadImage("mountain.png");
  waterSprite = loadImage("water.png");
  
  music.loop();
  
  background(255);
  colorMode(HSB, 100);
  
  tileSize = 50;
  cols = (int) width/tileSize;
  rows = (int) height/tileSize;
  
  world = new Tile[cols][rows];
  
  Perlin perlin = new Perlin(50);
    
  int numFood = 20;
  int numHome = 5;
  
  //Uses perlin noise to help create the terrain for the map
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float valb = perlin.octaveNoise(i * tileSize, j * tileSize, 0.01, 10, 0.4);
      
      //println(valb);
  
      int px = i * tileSize;
      int py = j * tileSize;
  
      world[i][j] = new Tile(px, py, tileSize);
  
      if (valb < 0.4) {
        world[i][j].setType(TileType.Water);
      }
      else if (valb < 0.5) {
        world[i][j].setType(TileType.Empty);
      }
      else if (valb < 0.625) {
        world[i][j].setType(TileType.Forest);
      }
      else{
        world[i][j].setType(TileType.Mountain);
      }
    }
  }
  //Assigns randomly where the rabbit holes and carrots will appear so long as the tiles don't already have something on them
  for (int i = 0; i < numFood; i++) {
    getRandomValidTile().setType(TileType.Food);
  }
    
  for (int i = 0; i < numHome; i++) {
    getRandomValidTile().setType(TileType.Home); 
  }
  //Creates the rabbits
  bunnies = new ArrayList<Rabbit>();
    for (int i = 0; i < 5; i++) {
      Rabbit bunny = new Rabbit();

      Tile spawnTile = getRandomValidTile();
      bunny.location = spawnTile.getTileCenter();
      
      bunnies.add(bunny);
  }
  //Creates a graph to use for the Dijkstra 
  graph = new Graphs();
  graph.initialize(width, height, tileSize);
  
  for (Node n : graph.nodes) {
    PVector loc = n.getTileCenter();
    int tileX = int(loc.x / tileSize);
    int tileY = int(loc.y / tileSize);
    
    tileX = constrain(tileX, 0, cols - 1);
    tileY = constrain(tileY, 0, rows - 1);
  
    if (world[tileX][tileY].type == TileType.Water) {
      n.block();
    } 
    else {
      n.fillcolor = color(255);
    }
  }
  graph.handleBlockedNodes();
  
  startTime = millis();
  timeUp = false;
}
//draws the tiles on the screen
void draw() {
  background(20, 80, 40);

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      world[i][j].display();
    }
  }

  for (Rabbit b : bunnies) {
    int tileX = constrain(floor(b.location.x / tileSize), 0, cols - 1);
    int tileY = constrain(floor(b.location.y / tileSize), 0, rows - 1);

    b.updateBunny(world[tileX][tileY].type);
    b.display();
  }
  
  int elapsedTime = (millis() - startTime) / 1000;
  int remainingTime = gameDuration - elapsedTime;
  //Creates the score, game information, timer and win/loss screen. A sound and text appear when you win or lose
  fill(0, 0, 0);
  textSize(20);
  text("Rabbits: " + rabbits, 10, 50);
  text("Trapped: " + trappedCount, 10, 70);
  text("Traps: " + trapCount + "/" + maxTraps, 10, 90);
  text("Timer: " + max(remainingTime, 0), width - 90, 50);
  textSize(30);
  text("Wabbit Hunting Season", width/2 -150, 30);
  fill(0, 0, 100);
  textSize(20);
  text("Rabbits: " + rabbits, 11, 51);
  text("Trapped: " + trappedCount, 11, 71);
  text("Traps: " + trapCount + "/" + maxTraps, 11, 91);
  text("Timer: " + max(remainingTime, 0), width - 89, 51);
  textSize(30);
  text("Wabbit Hunting Season", width/2-149, 31);
  
  if (remainingTime <= 0 && !gameOver) {
    gameOver = true;
    timeUp = true;
    lose.rewind();
    lose.play();
  }
  if (trappedCount == 5 && !timeUp){
    if (!gameOver) {
      win.rewind();
      win.play();
      gameOver = true;
    }
    fill(0,0,0);
    textSize(40);
    text("You Caught all the Rabbits!", width/2-219, height/3+1);
    textSize(20);
    text("Click Anywhere to Play Again.", width/2-119, height/3*2+1);
    fill(0,100,100);
    textSize(40);
    text("You Caught all the Rabbits!", width/2-220, height/3);
    fill(0,0,100);
    textSize(20);
    text("Click Anywhere to Play Again.", width/2-120, height/3*2);
  }
  else if (timeUp) {
    fill(0,0,0);
    textSize(40);
    text("Game Over!", width/2-109, height/3+1);
    textSize(20);
    text("Click Anywhere to Try Again.", 181, height/3*2+1);
    fill(0,100,100);
    textSize(40);
    text("Game Over!", width/2-110, height/3);
    fill(0,0,100);
    textSize(20);
    text("Click Anywhere to Try Again.", 180, height/3*2);
  }
}
//Uses Dijkstra to find a path to closest tile of a certain tile type. Returns a path created by the buildpath function. I used Dijkstra over A star since it wasn't used much in class
ArrayList<Node> getClosestTileDijkstra(Rabbit bunny, TileType targetType) {

  int startX = int(bunny.location.x / tileSize);
  int startY = int(bunny.location.y / tileSize);
  Node start = graph.getNode(startX, startY);

  ArrayList<Node> open = new ArrayList<Node>();
  HashMap<Node, Float> dist = new HashMap<Node, Float>();
  HashMap<Node, Node> prev = new HashMap<Node, Node>();

  open.add(start);
  dist.put(start, 0.0);

  while (!open.isEmpty()) {
    Node current = open.get(0);
    for (Node n : open) {
      if (dist.get(n) < dist.get(current)) {
        current = n;
      }
    }

    open.remove(current);

    PVector loc = current.getTileCenter();
    int tx = int(loc.x / tileSize);
    int ty = int(loc.y / tileSize);

    if (tx >= cols) tx = 0;
    if (tx < 0) tx = cols - 1;
    
    if (ty >= rows) ty = 0;
    if (ty < 0) ty = rows - 1;

    if (targetType == TileType.Water) {
      
      if (isNextToWater(tx, ty)) {
        return buildPath(prev, current);
      }
    
    } 
    else {
      if (world[tx][ty].type == targetType) {
        return buildPath(prev, current);
      }
    }

    for (Edge e : current.edges) {
      Node neighbour = e.endNode;
    
      if (neighbour.block) continue;
    
      float newDist = dist.get(current) + 1;
    
      if (!dist.containsKey(neighbour) || newDist < dist.get(neighbour)) {
        dist.put(neighbour, newDist);
        prev.put(neighbour, current);
    
        if (!open.contains(neighbour)) {
          open.add(neighbour);
        }
      }
    }
  }

  return null;
}
//Changes the tile that gets clicked on to a trap tile so long as it isn't water, home or food as well as helps restart the game after winning
void mousePressed() {

  if (gameOver) {
    restartGame();
    return;
  }

  if (trapCount >= maxTraps) {
    return;
  }

  int tx = int(mouseX / tileSize);
  int ty = int(mouseY / tileSize);

  tx = constrain(tx, 0, cols - 1);
  ty = constrain(ty, 0, rows - 1);

  Tile clicked = world[tx][ty];

  if (clicked.type == TileType.Empty 
   || clicked.type == TileType.Forest 
   || clicked.type == TileType.Mountain) {

    place.rewind();
    place.play();

    clicked.setType(TileType.Trap);
    trapCount++;
  }
}
//Restarts the game
void restartGame() {

  music.pause();     
  music.rewind();    

  trapCount = 0;
  trappedCount = 0;
  rabbits = 5;

  bunnies.clear();

  setup();

  startTime = millis();
  timeUp = false;

  gameOver = false;
}
//Creates an array of tiles for the rabbit to follow as a path to get to water or home. Helper function for the Dijkstra function.
ArrayList<Node> buildPath(HashMap<Node, Node> prev, Node current) {
  ArrayList<Node> path = new ArrayList<Node>();
  Node temp = current;

  while (temp != null) {
    path.add(0, temp);
    temp = prev.get(temp);
  }

  return path;
}
//Checks for a tile beside water for the rabbit to stop at and drink.
boolean isNextToWater(int x, int y) {
  int[][] dirs = {
    {1,0}, {-1,0}, {0,1}, {0,-1}
  };

  for (int[] d : dirs) {
    int nx = x + d[0];
    int ny = y + d[1];

    if (nx >= 0 && nx < cols && ny >= 0 && ny < rows) {
      if (world[nx][ny].type == TileType.Water) {
        return true;
      }
    }
  }

  return false;
}
//Searches for a tile to spawn new food on. It wont spawn on or beside water, but will on empty tiles, forest tiles or mountain tiles. 
Tile getRandomValidTile() {
  int x = (int) random(1, cols - 1);
  int y = (int) random(1, rows - 1);

  Tile randomTile = world[x][y];

  while ((randomTile.type != TileType.Empty) || randomTile.isBlocked()) {
    x = (int) random(1, cols - 1);
    y = (int) random(1, rows - 1);
    randomTile = world[x][y];
  }

  return randomTile;
}
