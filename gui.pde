interface GUIElement {
  final boolean pressed = false;
  void draw();
  boolean click(float mx, float my);
  boolean hold(float mx, float my);
  void unclick(float mx, float my);
}










class Button implements GUIElement {
  boolean pressed;
  float x, y, w, h;
  
  Button (float X, float Y, float W, float H) {
    x = X;
    y = Y;
    w = W;
    h = H;
    pressed = false;
  }
  
  @Override void draw() {
    pushMatrix();
    translate(x, y);
    noStroke();
    textSize(h - 4);
    textAlign(CENTER, CENTER);
    if (pressed) {
      fill(255, 0, 0);
      rect(4, 4, w - 8, h - 8, 20);
      fill(255, 220, 180);
      text("reset", w/2, h/2 - 3);
    }
    else {
      fill(120, 0, 0);
      rect(2, 2, w - 4, h - 4, 20);
      fill(255, 0, 0);
      text("reset", w/2, h/2 - 3);
    }
    popMatrix();
  }
  
  @Override boolean click(float mx, float my) {
    if (mx >= x && mx <= x + w) {
      if (my >= y && my <= y + h) {
        pressed = true;
        return true;
      }
    }
    pressed = false;
    return false;
  }
  
  @Override boolean hold(float mx, float my) {
    return click(mx, my);
  }
  
  @Override void unclick(float mx, float my) {
    pressed = false;
  }
}










class Slider implements GUIElement {
  float x, y;
  float w, h;
  boolean pressed;
  float value;
  
  Slider (float X, float Y, float W, float H) {
    x = X;
    y = Y;
    w = W;
    h = H;
    pressed = false;
    value = 0;
  }
  
  Slider (float X, float Y, float W, float H, float V) {
    x = X;
    y = Y;
    w = W;
    h = H;
    pressed = false;
    value = V;
  }
  
  void draw() {
    pushMatrix();
    translate(x, y);
    noStroke();
    fill(180);
    rect(0, 0, w, h, 50);
    fill(255);
    if (w > h) {
      ellipse(value * w, h/2, h * 1.5, h * 1.5);
    } else {
      ellipse(w/2, value * h, w * 1.5, w * 1.5);
    }
    popMatrix();
  }
  
  boolean click (float mx, float my) {
    if (mx >= x && mx <= x + w) {
      if (my >= y && my <= y + h) {
        pressed = true;
        hold(mx, my);
        return true;
      }
    }
    pressed = false;
    return false;
  }
  
  boolean hold (float mx, float my) {
    if (pressed) {
      if (w > h) {
        value = constrain(map(mx, x, x + w, 0, 1), 0, 1);
      } else {
        value = constrain(map(my, y, y + h, 0, 1), 0, 1);
       }
       return true;
    }
    return false;
  }
  
  void unclick (float mx, float my) {
    pressed = false;
  }
}