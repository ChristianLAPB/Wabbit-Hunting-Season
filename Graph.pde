import java.util.Iterator;

class Graphs {
  
  ArrayList<Node> nodes;
  int rows, cols, tileSize;
  
  Graphs() {
    nodes = new ArrayList<Node>();
  }
  
  void addNode(Node n) {
    int id = nodes.size();
    n.id = id;
    nodes.add(n);
  }
  
  Node getNode(int tileX, int tileY) {
    for (Node n : nodes) {
      PVector loc = n.getTileCenter();
      int nx = int(loc.x / tileSize);
      int ny = int(loc.y / tileSize);
  
      if (nx == tileX && ny == tileY) {
        return n;
      }
    }
    return null;
  }
  
  void initialize(int w, int h, int t) {
    tileSize = t;
    cols = w/tileSize;
    rows = h/tileSize;
    
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        Node n = new Node("", new ArrayList<Edge>(), i*tileSize, j*tileSize, tileSize);
        addNode(n);
    
      }
    }
    
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        int index = j * cols + i;
  
        if (i > 0) {
          Edge left = new Edge(nodes.get(index), nodes.get(index - 1), tileSize);
          nodes.get(index).edges.add(left);
          
        }
        if (i < cols - 1) {
          Edge right = new Edge(nodes.get(index), nodes.get(index + 1), tileSize);
          nodes.get(index).edges.add(right);
          
        }
        if (j > 0) {
          Edge top = new Edge(nodes.get(index), nodes.get(index - cols), tileSize);
          nodes.get(index).edges.add(top);
        }
        if (j < rows - 1) {
          Edge bottom = new Edge(nodes.get(index), nodes.get(index + cols), tileSize);
          nodes.get(index).edges.add(bottom);
        } 
      }
    }
  
  }
  
  Node getLocalizedNode(PVector vec) {
    return getLocalizedNode(vec.x, vec.y);
  }
  
  Node getLocalizedNode(float x, float y) {

    int i = floor(x/tileSize);
    int j = floor(y/tileSize);
    //println("Hello: " + i + ", " + j + ", " + nodes.get(i*rows+j).id + ", " + i*rows+j);
    return nodes.get(j * cols + i);
  }

  void handleBlockedNodes() {
    
    for (Node n : this.nodes) {
      if (n.block) {
        
        
        n.edges.clear();
      } else {  
        Iterator it = n.edges.iterator();
    
        while(it.hasNext()) {
          Edge e = (Edge) it.next();
          if (e.endNode.block) {
            it.remove();
          }
        }
      }
    }
  }
}
