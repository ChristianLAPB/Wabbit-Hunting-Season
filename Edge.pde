class Edge {
  
  Node startNode;
  Node endNode;
  float cost;
  boolean wall;
  
  PVector startPos, endPos;
  
  Edge(Node sN, Node eN, float c) {
    startNode = sN;
    endNode = eN;
    cost = c;
    wall = true;
  }
  
  void breakdown() {
    wall = false;
    for (Edge endEdge : endNode.edges) {
      if (endEdge.endNode == startNode) {
        endEdge.wall = false;
      }
    }
  }
  
  void drawWall() {
    stroke(color(255,0,0));
    
    float xdiff = endNode.position.x - startNode.position.x;
    float ydiff = endNode.position.y - startNode.position.y;
    
    println(this.startNode.id + ", " + this.endNode.id + ", xdiff: " + xdiff + ", ydiff: " + ydiff);
    
    if (xdiff > 0) {
      startPos = new PVector(endNode.position.x, startNode.position.y);
      endPos = new PVector(endNode.position.x, startNode.position.y + startNode.size);
      
    }
    else if (xdiff < 0) {
      startPos = new PVector(startNode.position.x, startNode.position.y);
      endPos = new PVector(startNode.position.x, startNode.position.y + startNode.size);
    
    } 
    else if (ydiff > 0) {
      startPos = new PVector(startNode.position.x, endNode.position.y);
      endPos = new PVector(startNode.position.x + startNode.size, endNode.position.y);

    } 
    else if (ydiff < 0) {
      startPos = new PVector(startNode.position.x, startNode.position.y);
      endPos = new PVector(startNode.position.x + startNode.size, startNode.position.y);
      
    }
    line(startPos.x, startPos.y, endPos.x, endPos.y); 
    stroke(0);
  }
}
