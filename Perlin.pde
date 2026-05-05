class Perlin {

  PVector[][] gradients;
  int dims;

  Perlin(int d) {
  
    dims = d;
    gradients = new PVector[dims][dims];
    
    for (int i = 0; i < dims; i++) {
      for (int j = 0; j < dims; j++) {
        gradients[i][j] = PVector.random2D();
        gradients[i][j].normalize();
      }
    }
    
  }
  
  float noise(float x, float y, float zoom) {
    
    x = (x * zoom) % dims;
    y = (y * zoom) % dims;
    
    int x0 = floor(x);
    int y0 = floor(y);
    
    int x1 = (x0 + 1) % dims; 
    int y1 = (y0 + 1) % dims;
    
    float xoffset = x - x0;
    float yoffset = y - y0;
    
    PVector offsetVector = new PVector(xoffset, yoffset);
    
    PVector dx0y0 = PVector.sub(offsetVector, new PVector(0,0));
    PVector dx1y0 = PVector.sub(offsetVector, new PVector(1,0));
    PVector dx0y1 = PVector.sub(offsetVector, new PVector(0,1));
    PVector dx1y1 = PVector.sub(offsetVector, new PVector(1,1));
    
    float dot1 = gradients[x0][y0].dot(dx0y0);
    float dot2 = gradients[x1][y0].dot(dx1y0);
    float dot3 = gradients[x0][y1].dot(dx0y1);
    float dot4 = gradients[x1][y1].dot(dx1y1);
    
    float lerp1 = lerp(dot1, dot2, fade(xoffset));
    float lerp2 = lerp(dot3, dot4, fade(xoffset));
    float average = lerp(lerp1, lerp2, fade(yoffset));
   
    return map(average, -1, 1, 0, 1);
  
  }

  float fade(float t) {
    return t * t * t * (t * (t * 6 - 15) + 10); 
  }
  
  float octaveNoise(float x, float y, float zoom, int numOctaves, float persistence) {
    float total = 0;
    float localzoom = 1;
    float amplitude = 1;
    float maxValue = 0;
    
    for (int i = 0; i < numOctaves; i++) {
      total = total + noise(x,y,localzoom*zoom) * amplitude;
      maxValue = maxValue + amplitude;
      
      amplitude = amplitude * persistence;
      localzoom = localzoom * 2;
    }
    return total/maxValue; 
  }
}
