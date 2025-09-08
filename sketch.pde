/** t3ssel8or's semi-intuitive non-linear interpolator
 * A non-linear keyframeless interpolation thingy
 * Code from t3ssel8r, implemented by Benro75
 * Version: 1.3
 * Last edited: 2025/09/07
 */

Interp2D n;

int m = millis(); // A variable for timing
float mx, my; // The target position

Slider s, f, z, r; // The sliders
Button rset; // The reset button
float S; // A spacer

float[] G; // The values in the graph

void setup() {
  //size(500, 400);
  
  textSize(30);
  S = textWidth("speed");
  G = new float[round(width-S*2-20)];
  float F = 0.8;
  float Z = 0.99;
  float R = 0.5;
  
  n = new Interp2D(mx, my, F, Z, R);
  mreset();
  graphset();
  
  // Set up the gui objects
  s = new Slider(S + 20, 90, width - S*2 - 20, 30, 0.2);
  f = new Slider(S + 20, 140, width - S*2 - 20, 30, F/5.0); 
  z = new Slider(S + 20, 190, width - S*2 - 20, 30, Z/3.0);
  r = new Slider(S + 20, 240, width - S*2 - 20, 30, (R+3)/6);
  textSize(26);
  rset = new Button(width * 7/8 - S, 45, textWidth("reset") + 40, 30);
}

void draw() {
  background(0);
  noStroke();
  
  // Drawen de tekst
  fill(255);
  textSize(30);
  textAlign(RIGHT);
  textLeading(50);
  text("speed\nf\nζ\nr", S + 10, 113);
  textAlign(LEFT);
  text((int)(s.value * 99 + 1) + "\n" +
    round(f.value * 500)/100.0 + "\n" +
    round(z.value * 300)/100.0 + "\n" +
    round((r.value * 600 - 300))/100.0,
    width - S + 10, 113);
  
  // Update the slider positions
  s.hold(mouseX, mouseY);
  f.hold(mouseX, mouseY);
  z.hold(mouseX, mouseY);
  r.hold(mouseX, mouseY);
  //rset.click(mouseX, mouseY);
  
  // Repeat the calculations
  for (int i = 0; i < s.value * 99 + 1; i++) {
    n.run(mx, my, (i==0?(float)(millis() - m):1) / 500.0);
    //m - millis()
    //(i==0?(float)(millis() - m):1)
    //max(m-millis(), 1)
    //m = millis();
  }
  
  // Draw the graph
  stroke(255);
  for (int i = 1; i < G.length; i++) {
    line(i+S+10, height - height/20 - G[i-1]*2,
      i+S+10, height - height/20 - G[i]*2);
  }
  
  // Draw the target position
  noStroke();
  fill(180);
  ellipse(mx, my, 15, 15);
  
  // Draw the interpolated circle with goofy squash and stretch
  pushMatrix();
  translate(n.p.x, n.p.y);
  rotate(n.v.heading());
  fill(255);
  float sqsh = n.v.mag() / ((float)(millis()-m)) * 10;
  ellipse(0, 0, 20 + sqsh, 20 - min(sqsh / 2, 15));
  popMatrix();
  
  // Change the target position if you aren't clicking an object
  if (mousePressed &&
    !s.pressed &&
    !f.pressed &&
    !z.pressed &&
    !r.pressed &&
    !rset.pressed) {
    mx = mouseX;
    my = mouseY;
    
  // Update the interp variables and graph if you're moving the sliders
  } else if (mousePressed && !s.pressed) {
    n.set(f.value * 5.0,
      z.value * 3.0,
      r.value * 6.0 - 3);
    
    graphset();
  }
  
  // Reset the circle if it gets to NaN
  if (isNaN(n.p.x) || isNaN(n.p.y)) {
    n.p = new PVector(mx, my);
    n.v = new PVector(0, 0);
    //mreset();
  }
  
  // Draw the gui objects
  s.draw();
  f.draw();
  z.draw();
  r.draw();
  rset.draw();
  
  m = millis();
}

void mousePressed() {
  s.click(mouseX, mouseY);
  f.click(mouseX, mouseY);
  z.click(mouseX, mouseY);
  r.click(mouseX, mouseY);
  rset.click(mouseX, mouseY);
}

void mouseReleased() {
  s.unclick(mouseX, mouseY);
  f.unclick(mouseX, mouseY);
  z.unclick(mouseX, mouseY);
  r.unclick(mouseX, mouseY);
  
  // Make rset reset the circle and target
  boolean c = rset.click(mouseX, mouseY);
  if (c) {
    ///*
    // Steal the ks from n so I don't have to recalculate or write better code
    float k1 = n.k1;
    float k2 = n.k2;
    float k3 = n.k3;
    
    // Reset it
    mreset();
    n.k1 = k1;
    n.k2 = k2;
    n.k3 = k3;
    graphset();
    
    //*/*
    /*
    setup();
    */
  }
  rset.unclick(mouseX, mouseY);
}

void mreset() {
  mx = width/2;
  my = height/2;
  n.p = new PVector(mx, my);
  n.v = new PVector(0, 0);
}

boolean isNaN (float n) {
  return n != n;
}

void graphset() {
  Interp1D g = new Interp1D(0, 0, 0, 0);
  g.k1 = n.k1;
  g.k2 = n.k2;
  g.k3 = n.k3;
  for (int i = 0; i < G.length; i++) {
    g.run((float)(i < G.length/30 ? 0 : 100), .1);
    G[i] = g.p;
  }
}