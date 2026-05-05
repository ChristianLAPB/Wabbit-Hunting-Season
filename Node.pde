import java.util.*;

class Node {
  
  int id;
  
  String name;
  ArrayList<Edge> edges;
  PVector position;
  float size;
  
  boolean visited;
  boolean block;
  
  int fillcolor = 255;
  
  Node(String n, ArrayList<Edge> e, float x, float y, float mSize) {
    name = n;
    edges = e;
    visited = false;
    block= false;  
    position = new PVector(x, y);
    size = mSize;
    
  }
  
  void display() {
    noStroke();
    rectMode(CORNER);
    fillcolor = color(fillcolor);
    fill(fillcolor);

    rect(position.x, position.y, size, size);
  }
  
  void block() {
    block = true;
    fillcolor = color(0);
  }

  void visit() {
    fillcolor = color(255,0,0);
  }
  
  boolean isBlocked() {
    return block;
  }
  
  void drawWalls() {
    stroke(0);
    for (Edge e : edges) {
      if (e.wall) {
        e.drawWall();
      }
    }
  }
  
  PVector getTileCenter() {
    return new PVector(position.x + tileSize/2, position.y + tileSize/2);
  }
  
  Edge getRandomEdge() {
    Collections.shuffle(edges);
    for (Edge e : edges) {
      if (e.endNode.visited != true) {
        return e;
      }
    }
    return null;
  }
  
  Edge getEdgeTo(Node n) {
    for (Edge e : edges) {
      if (e.endNode == n) {
        return e;
      }
    }
    return null;
  }
}
