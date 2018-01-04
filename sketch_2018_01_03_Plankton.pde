int index = 1;
boolean MouseBool = false;
ArrayList<Particle> particles = new ArrayList<Particle>();
int NextVersion = 1;
float velocityAvg;

void setup() {
  size(800, 700);
  background(0);
}

void draw() {
  stroke(255);
  float velocityX;
  float velocityY;
  int velocity;
  if (MouseBool) {
    // If you want to follow the mouse
    velocityX = mouseX - pmouseX;
    velocityY = mouseY - pmouseY;
    // If you want to run away from the mouse:
    //velocityX = pmouseX - mouseX;
    //velocityY = pmouseY - mouseY;
    velocityAvg = sqrt(velocityX*velocityX + velocityY*velocityY);
    velocity = int(velocityAvg/2);
    //ellipse(mouseX,mouseY,velocity,velocit y);
    for (int i = 0; i < velocity; i++) {
      Particle p = new Particle();
      particles.add(p);
      p.speedX = random(-abs(velocityAvg/2), abs(velocityAvg/2));
      p.speedY = random(-abs(velocityAvg/2), abs(velocityAvg/2));
      p.colorP = color(200 + random(55),255,200 + random(55));
    }
  }
  
  if (particles.size() > 1000) {
    int sizeNow = particles.size();
    for (int i = 0; i < sizeNow - 1000; i++) {
      Particle B = particles.get(0);
      particles.remove(B);
      }
    }
  
  if (NextVersion == 1) {
    for (Particle p : particles) {
      p.update();
      p.display();
    }
  } else if (NextVersion == 2) {
    background(0);
    for (Particle p : particles) {
      p.update();
      p.displayMany();
    }
  }
  println(particles.size());
  
}

class Particle {
  float speedX;
  float speedY;
  float posX;
  float posY;
  float gravity = 0.1;
  float viscousCoeff = 0.1;
  boolean exist;
  int NoParticles = 10;
  float[] posXa = new float[NoParticles];
  float[] posYa = new float[NoParticles];
  color colorP;
  
  Particle() {
    posX = mouseX;
    posY = mouseY;
    exist = true;
    // Initialize tail
    for (int i = 0; i < NoParticles; i++) {
      posXa[i] = mouseX;
      posYa[i] = mouseY;
    }
  }
  
  void update() {
    // For gravity controlled situation;
    //speedY += 0.1;
    
    // For viscous solution
    speedX -= (speedX) * viscousCoeff ;
    speedY -= (speedY) * viscousCoeff ;
    // (sX,sY) orthogonal (sY, -sX) or (-sY, sX)
    // For eddies
    //speedX -= (speedX + speedY*2) * viscousCoeff ;
    //speedY -= (speedY - speedX*2) * viscousCoeff ;
    
    posX += speedX;
    posY += speedY;
    
    if (posY > height) {
      //exist = false;
    }
    for (int i = 0; i < NoParticles - 1; i++) {
      posXa[i] = posXa[i+1];
      posYa[i] = posYa[i+1];
    }
    posXa[NoParticles-1] = posX;
    posYa[NoParticles-1] = posY;
    if (posYa[0] > height) {
      exist = false;
    }
  }
  
  void display() {    
    stroke(colorP);
    point(posX,posY);
  }
  
  void displayMany() {
    if (exist) {
      for (int i = 0; i < NoParticles; i++) {
        point(posXa[i],posYa[i]);
      }
    }
  }
}

void mousePressed() {
  MouseBool = true;
}

void mouseReleased() {
  MouseBool = false;
}

void keyPressed() {
  if (key == ' ') {
    background(0);
    particles = new ArrayList<Particle>();
    NextVersion++;
    if (NextVersion > 3) NextVersion = 1;
  }
}