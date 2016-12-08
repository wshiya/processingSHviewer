/**
 * This code is based on the folowing processing sample code:
 * "Noise Sphere 
 * by David Pena.  
 * Uniform random distribution on the surface of a sphere. "
 * https://github.com/processing/processing-docs/blob/master/content/examples/Topics/Geometry/NoiseSphere/NoiseSphere.pde
 */

int cuantos = 12000;
Pelo[] lista ;
float[] z = new float[cuantos]; 
float[] phi = new float[cuantos]; 
float[] largos = new float[cuantos]; 
float radio;
float rx = 0;
float ry =0;

// sh calc
//SHCalculator SHExpansions;
int shParam_l = 0; // positive integer
int shParam_m = 0; // -l to l 

void setup() {
  //size(640, 360, P3D);
   size(1280, 720, P3D);
  // size(2660, 1440, P3D);
  radio = height/4;
  lista = new Pelo[cuantos];
  for (int i=0; i<cuantos; i++) {
    lista[i] = new Pelo();
  }
  noiseDetail(3);
}
  boolean pressedFlag =false ;
  void keyReleased() {
    pressedFlag=false;
  }
  
void draw() {
  background(0);
  translate(width/2, height/2);
  fill(255);
  textSize(20.0);
  text("push key (j,k) and (m, i) -> (l, m) = ("+ shParam_l +","+ shParam_m +")", -width/2, -height/2 + 25);
  //text("hello world", 15, 50);
  
  if ((keyPressed == true) && (key == 'k')) {
    if (pressedFlag != true) {
    shParam_l++;
    if(shParam_m > shParam_l) shParam_m = shParam_l;
    if(shParam_m < -shParam_l) shParam_m = -shParam_l;    
    pressedFlag=true;
    }
  }

  if ((keyPressed == true) && (key == 'j')) {
    if (pressedFlag != true) {
    shParam_l--;
    if(shParam_l<0) shParam_l=0;
    if(shParam_m > shParam_l) shParam_m = shParam_l;
    if(shParam_m < -shParam_l) shParam_m = -shParam_l;
     pressedFlag=true;
    }
  }
  
   if ((keyPressed == true) && (key == 'i')) {
   if (pressedFlag != true) {
    shParam_m++;
    if(shParam_m > shParam_l) shParam_m = shParam_l;
      pressedFlag=true;   
    }
  }
  
  if ((keyPressed == true) && (key == 'm')) {
   if (pressedFlag != true) {
    shParam_m--;
    if(shParam_m < -shParam_l) shParam_m = -shParam_l;
       pressedFlag=true;   
    }
  }

  float rxp = ((mouseX-(width/2))*0.005);
  float ryp = ((mouseY-(height/2))*0.005);
  
  rx = (rx*0.9)+(rxp*0.1);
  ry = (ry*0.9)+(ryp*0.1);
  
  rotateY(rx);
  rotateX(ry);
  
  fill(0); // line or fill polygon
  //noStroke(); // draw line or not
  stroke(200, 150);
  for (int i = 0;i < cuantos; i++) {
    lista[i].dibujar();
  }
}

class Pelo {
  float z = random(-radio, radio);
  float phi = random(TWO_PI);
  float largo = 1.2;//random(1.15, 1.2);
  float theta = acos(z/radio);

  void dibujar() {
    float off = (noise(millis() * 0.0005, sin(phi))-0.5) * 0.3;
    float offb = (noise(millis() * 0.0007, sin(z) * 0.01)-0.5) * 0.3;

    float thetaff = theta;//+off;
    float phff = phi;//+offb;
    float x = 0;//radio * cos(theta) * cos(phi);
    float y = 0;//radio * cos(theta) * sin(phi);
    float z = 0;//radio * sin(theta);
    float msx= screenX(x, y, z);
    float msy= screenY(x, y, z);

    radio = 200.0;
    float xo = radio * sin(thetaff) * cos(phff);
    float yo = radio * sin(thetaff) * sin(phff);
    float zo = radio * cos(thetaff);
    boolean posNegSW = true;
    
   float shResult = 2.0 * ( ComputeSH(shParam_l, shParam_m, thetaff, phff) );
    if(shResult< 0.0) posNegSW = false;

    float xb = xo * largo * abs(shResult);
    float yb = yo * largo * abs(shResult);
    float zb = zo * largo * abs(shResult);
    beginShape(LINES);
    //stroke(0);
    strokeWeight(1);
    stroke(50,120,255);
    if(posNegSW==false) stroke(255, 50, 50);
    vertex(x, y, z);
    vertex(xb, yb, zb);
    endShape();
  }
}