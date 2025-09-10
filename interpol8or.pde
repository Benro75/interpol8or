abstract class interpol8r {
  Object p; // The current position
  Object v; // The current velocity
  Object pin; // The past input position
  float k1, k2, k3; // Three style variables
  
  //abstract void run(Object in, float t);
}










class Interp1D extends interpol8r {
  float p, v;
  float pin;
  float k1, k2, k3;
  
  Interp1D (float in, float f, float z, float r) {
    init(in, f, z, r);
  }
  
  void init (float in, float f, float z, float r) {
    p = in;
    v = 0;
    pin = in;
    set(f, z, r);
  }
  
  void run (float in, float t) {
    p += v * t;
    v = calc(in, t);
  }
  
  float calc (float in, float t) {
    float poo = v + (in - p + ((in - pin) * k3 / t) - k1 * v) / k2 * t;
     // v + (in - p + ((in - pin) * k3 / t) - k1 * v) / k2 * t
     pin = in;
     return poo;
  }
  
  // Big thanks to t3ssel8or for this; go check out his youtube channel
  void set (float f, float z, float r) {
    k1 = z / (PI * f);
    k2 = 1 / (TAU * f) * (TAU * f);
    k3 = (r * z) / (TAU * f);
  }
}










class Interp2D extends interpol8r {
  PVector p, v;
  PVector pin;
  float k1, k2, k3;
  
  Interp2D (PVector in, float f, float z, float r) {
    init(in, f, z, r);
  }
  
  Interp2D (float x, float y, float f, float z, float r) {
    init(new PVector(x, y), f, z, r);
  }
  
  void init (PVector in, float f, float z, float r) {
    p = in;
    v = new PVector(0, 0);
    pin = new PVector(in.x, in.y);
    set(f, z, r);
  }
  
  void run (PVector i, float t) {
    PVector in = new PVector(i.x, i.y);
    p.add(PVector.mult(v, t));
    v = calc(in, t);
  }
  
  void run (float x, float y, float t) {
    run(new PVector(x, y), t);
    //println(p.x, p.y);
    //println(v.x, v.y);
    //println();
  }
  
  PVector calc (PVector in, float t) {
    PVector poo = calcu(in, t);
    pin = new PVector(in.x, in.y);
    return poo;
  }
  
  private PVector calcu (PVector in, float t) {
    PVector poo = PVector.add(v,
      PVector.mult(
        PVector.add(
          PVector.add(
            PVector.sub(in, p), 
            PVector.mult(
             PVector.sub(in, pin), 
             k3 / t)), 
          PVector.mult(v, -k1)), 
        t / k2));
     // v + (in - p + ((in - pin) * k3 / t) - k1 * v) / k2 * t
    return poo;
  }
  
  void set (float f, float z, float r) {
    k1 = z / (PI * f);
    k2 = 1 / (TAU * f) * (TAU * f);
    k3 = (r * z) / (TAU * f);
  }
}










class Interp3D extends Interp2D {
  PVector p, v;
  PVector pin;
  float k1, k2, k3;
  
  Interp3D (PVector in, float f, float z, float r) {
    super(in, f, z, r);
    v = new PVector(0, 0, 0);
    pin = new PVector(in.x, in.y, in.z);
  }
  
  Interp3D (float x, float y, float f, float z, float r) {
    super(new PVector(x, y, 0), f, z, r);
    v = new PVector(0, 0, 0);
    pin = new PVector(x, y, 0);
  }
  
  Interp3D (float x, float y, float Z, float f, float z, float r) {
    super(new PVector(x, y, Z), f, z, r);
    v = new PVector(0, 0, 0);
    pin = new PVector(x, y, Z);
  }
  
  void init (PVector in, float f, float z, float r) {
    super.init(in, f, z, r);
  }
  
  void run (PVector i, float t) {
    super.run(i, t);
  }
  
  void run (float x, float y, float t) {
    super.run(new PVector(x, y, 0), t);
  }
  
  void run (float x, float y, float z, float t) {
    super.run(new PVector(x, y, z), t);
  }
  
  PVector calc (PVector in, float t) {
    PVector poo = super.calcu(in, t);
    pin = new PVector(in.x, in.y, in.z);
    return poo;
  }
}
