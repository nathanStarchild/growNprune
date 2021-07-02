//One process grows, another process prunes.
//hhmmmmmmmmmmmmm
ArrayList<Leader> leaders = new ArrayList<Leader>();
Grower oneProcessGrows;
Pruner oneProcessPrunes;
float startingScale = 0.02;
float myScale = startingScale;
boolean tooMany;

Palette myPalette;

float xmag, ymag = 0;
float newXmag, newYmag = 0; 

void setup() {
    // size(1080, 1350, P3D);
    size(1920, 1080, P3D);
    rectMode(RADIUS);
    fill(255, 0, 255);
    stroke(0, 255, 255);
    background(0);
    myPalette = new Palette();
    myPalette.setPalette(27);
    leaders.add(
        new Leader(PI/2, 
            PI/2,
            new PVector(0,0,0),
            25
        )
    );
    oneProcessGrows = new Grower(0.16);
    oneProcessPrunes = new Pruner(0.05);
    tooMany = false;

}

void draw(){
    background(0);
    pushMatrix();
    translate(width/2, height/2, -1000);
    scale(myScale);
    mouseCamera(0);
    for (Leader leader : leaders){ //does this work??
    // for (int i=0; i<leaders.size(); i++){
        // Leader leader = leaders.get(i);
        leader.extend(20);
        leader.drawIt();
    }
    popMatrix();
    oneProcessGrows.letsGetSpawning();
    oneProcessPrunes.pruneThatBiz();
    if (leaders.size() > 10000){
        println("so Many!");
        tooMany = true;
        oneProcessPrunes.pruneProb *= 3;
    }
    if (leaders.size() < 1000 & tooMany){
        println("so Few!");
        tooMany = false;
        oneProcessPrunes.pruneProb /= 9;
    }
}

class Leader {
    //x = r * cos(theta) * sin(phi)
    //y = r * sin(theta) * sin(phi)
    //z = r * coes(phi)
    float theta, phi, size;
    PVector location, birthPlace;
    int age;
    color col;

    Leader (float thetaIn, float phiIn, PVector locationIn, float sizeIn){
        theta = thetaIn;
        phi = phiIn;
        location = locationIn;
        birthPlace = new PVector(
            location.x,
            location.y,
            location.z
        );
        age = 0;
        size = sizeIn;
        col = myPalette.getColor(int(abs(location.z/300))%256, 200);
    }

    void extend(float l) {
        //grow by length l in the current heading
        PVector growBy = new PVector(
            l * cos(theta) * sin(phi),
            l * sin(theta) * sin(phi),
            l * cos(phi)
        );
        location.add(growBy);
        age++;
    }

    void drawIt() {
        pushMatrix();
            translate(location.x, location.y, location.z);
            rotateY(xmag);
            rotateX(ymag); 
            rect(0, 0, size, size);
        popMatrix();

        pushStyle();
            strokeWeight(size);
            stroke(this.col);
            line(
                birthPlace.x,
                birthPlace.y,
                birthPlace.z,
                location.x,
                location.y,
                location.z
                );
        popStyle();
    }

    void setHeadingAbout(Leader lIn) {
        //get a vector in the current heading
        PVector n = new PVector(
            cos(theta) * sin(phi),
            sin(theta) * sin(phi),
            cos(phi)
        );
        //rotate about the y axis by phi
        PVector tmp = rotate3D(n, new PVector(0, 1, 0), lIn.phi);
        //rotate about the z axis by theta
        PVector nDash = rotate3D(tmp, new PVector(0, 0, 1), lIn.theta);
        //now nDash is a vector in the new heading.
        //Let's extract phi and theta from it
        phi = acos(nDash.z/nDash.mag());
        theta = atan2(nDash.y, nDash.x);
    }
}

//Lucky I have already written a snippet for rotating PVectors
// by a given angle about a given axis in 3D
PVector rotate3D(PVector vIn, PVector axis, float theta){
  axis.normalize();
  float ct = cos(theta);
  float st = sin(theta);
  PVector[] R = { //https://en.wikipedia.org/wiki/Rotation_matrix#Rotation_matrix_from_axis_and_angle
    new PVector(ct + axis.x * axis.x * (1 - ct), 
                (axis.x * axis.y * (1 - ct)) - (axis.z * st), 
                (axis.x * axis.z * (1 - ct)) + (axis.y * st)),
    new PVector((axis.x * axis.y * (1 - ct)) + (axis.z * st), 
                ct + axis.y * axis.y * (1 - ct), 
                (axis.y * axis.z * (1 - ct)) - (axis.x * st)),
    new PVector((axis.x * axis.z * (1 - ct)) - (axis.y * st), 
                (axis.y * axis.z * (1 - ct)) + (axis.x * st), 
                ct + axis.z * axis.z * (1 - ct))
  };
  PVector mOut = new PVector();
  mOut.x = R[0].dot(vIn);
  mOut.y = R[1].dot(vIn);
  mOut.z = R[2].dot(vIn);
  return mOut;
}


Leader spawn(Leader lIn) {
    // float someTheta = random(-PI, PI);
    // float somePhi = random(-PI, PI);
    // float someTheta = ceil(random(5)) * ( PI - asin((sqrt(6)/3)));
    // float someTheta = 3*PI/2;
    // float somePhi = ceil(random(12)) *  PI/6;
    float someTheta = random(-PI, PI);
    float somePhi = random(-PI/3, PI/3);
    if (random(1) < 0.03){
        somePhi += PI;
    }
    int someSize = 90;

    Leader lOut = new Leader(
        someTheta, 
        somePhi,
        new PVector(lIn.location.x, lIn.location.y, lIn.location.z),
        someSize
    );
    lOut.setHeadingAbout(lIn);
    return lOut;
}

class Grower {
    //one process grows.....
    //maybz it makes the leaders spawn a new leader
    //sometimes.
    float spawnProb;

    Grower (float probIn) {
        spawnProb = probIn;
    }

    void letsGetSpawning() {
        int attempts = 1 + leaders.size() / 30;
        for (int i=0; i<attempts; i++) {
            int n = floor(random(leaders.size()));
            Leader l = leaders.get(n);
            if (spawnCondition(l)) {
                leaders.add(spawn(l));
            } 
        }
    }

    boolean spawnCondition(Leader lIn){
        float probability = random(1);
        boolean spawning = probability < spawnProb;
        return spawning; 
    }
}

class Pruner {
    //one process prunes....
    //maybz it prunes them when they get too old
    float pruneProb;

    Pruner (float probIn) {
        pruneProb = probIn;
    }

    void pruneThatBiz() {
        int attempts = leaders.size() / 30;
        for (int i=0; i<attempts; i++) {
            int n = floor(random(leaders.size()));
            Leader l = leaders.get(n);
            if (pruneCondition(l)) {
                leaders.remove(n);
            } 
        }
    }

    boolean pruneCondition(Leader lIn) {
        float probability = random(1);// / (1 + lIn.age / 10);
        boolean pruning = probability < pruneProb;
        return pruning;
    }
}


void mouseCamera(int action) {
  
  if (action == 3) {
    rotateX(-ymag); 
    rotateZ(-xmag);
    return;
  }
    


  newXmag = mouseX/float(width) * TWO_PI;
  newYmag = mouseY/(float(height) * 0.9) * TWO_PI;

  float diff = xmag-newXmag;
  if (abs(diff) >  0.01) { 
    xmag -= diff/4.0;
  }

  diff = ymag-newYmag;
  if (abs(diff) >  0.01) { 
    ymag -= diff/4.0;
  }

  if (action == 1) { //rotate
    rotateX(-ymag); 
    rotateY(-xmag);
  } else if (action ==0 ) {
    // translate(frameCount*30-25000, 0, frameCount*100-70000);
    if (frameCount/(30) >= 2 && frameCount/(30) < 12) {
      //scale((frameCount+30)/(30.0*6));
      
      //scale(0.1);
      //println("scaling");
    //   myScale = map(frameCount, 30*2, 30*12, startingScale, 0.03);
    } else if (frameCount/(30) >= 12 && frameCount/(30) < 35) {
    //   scale((frameCount+30)/(30.0*6));
      
      //scale(0.1);
      //println("scaling");
    //   myScale = map(frameCount, 30*12, 30*95, 0.03, 0.01);
    }
    if (frameCount/30 >= 0) {
    //   counter++;
    //   float theta = 2*PI * (counter/(30.0*10));
      float theta = map(frameCount, 30*30, 30*60, 0, 0.5 * PI);
      //theta = min(theta, 10*PI/6);
      rotateX(theta);
    }
    //if (frameCount/30 >= 40) {
    //  dymag = map(frameCount, 30*40, 30*90, 0, 5000);
    //  dymag = min(dymag, 5000);
    //}
    rotateZ(2*PI * frameCount/(30*65*900));
  } else {
    translate(xmag, ymag, 0);
  }
}

void keyPressed() {
    switch(key){
        case('-'):
            myScale = myScale / 1.1;
            break;
        case('='):
            myScale = myScale * 1.1;
            break;
    }
}