/**
 * Author: Zih-Yun, Chiou.
 * The goal of this project is to draw a ecosystem on the canvas.
 * The appearance of the organism depends on the input string.
 */
import java.awt.Color;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;
import tech.metacontext.ocnhfa.antsomg.impl.StandardGraph;
import tech.metacontext.ocnhfa.antsomg.model.Vertex;
import art.cctcc.c1635.antsomg.demo.LifeSystem;
import art.cctcc.c1635.antsomg.demo.LifeAnt;

/*----basic setting-----*/
int wid = 1440;
int hei = 855;

final int MAX_GENERATION = 300; // Max generation of GA
final int MAX_LENGTH = 32; // Max input length
final int MAX_ORGANISM = 8; // Max population of organisms.
final int MAX_DUMMY = 7; // Max population of dummys.

GeneticAlgorithm ga;  // GA object
LifeSystem lfs[] = new LifeSystem[MAX_ORGANISM]; // ant system
Population population;  // Initialize population

int generation = 1;  // Current generation

/*-----------------------------*/
/*------global parameters------*/

int chromosomeLength = 50; // Length of chromosome

String input = ""; // The input string
final String MSG1 = "Who are you?"; // The prompt messages
final String MSG2 = "Creating...";
final String MSG3 = "Creating..";
final String MSG4 = "Creating.";
final String MSG5 = "Welcome,";
String msg = "";
String target = ""; // To store the input message after user hits ENTER
String result = "";
int target_ascii[]; // Convert the input string into binary array



Organism organism_system[] = new Organism[MAX_ORGANISM];
Organism dummys[] = new Organism[MAX_DUMMY];
int num_organism = 0;

// Current state
int status = 0; // 0: Waiting input, 1: Dealing with input, 2: Running GA, 3: Finished GA, 4: Reset, 5: Full.

int sum_sharpness = 0; // sum of sharpness of each fittest individual in every generation.
float avg_sharpness = 1.0;

// frame count
int frame_cnt = 0;
int start_clk = 0;
int clk = 0;
int frame_30 = 0;
int frame_100 = 0;
int frame_200 = 0;

// text position
int leftmost = 50;
int lineone = 775;
int linetwo = 810;

// opacity
final float opacity = 120;

Map<LifeAnt, Float> map = new HashMap();
/*---end of global parameters---*/
/*------------------------------*/

void settings() {
  size(wid, hei);
}

void setup() {
  frameRate(30);
  // Set up the organism system
  for (int i = 0; i < MAX_ORGANISM; i++) {
      Organism organism = new Organism();
      organism_system[i] = organism;
  }
  
  for(int i=0; i< MAX_DUMMY/2+1; ++i){
      Organism dummy = new Organism();
      dummys[i] = dummy;
      dummys[i].setOrganism("BACKGROUND", "SMOOTH", "BACKGROUND", "ARC", 0, random(100, wid-100), random(100, hei-100));
      if(dummys[i].getColor() == "PURPLE" || dummys[i].getColor() == "BLUE"){
        dummys[i].change_color_to("GRAY");
      }
      dummys[i].setDead(0);
      dummys[i].resetLifetime();
      dummys[i].GotoRandom(float(wid), float(hei));
  }
  for(int i=MAX_DUMMY/2+2; i< MAX_DUMMY; ++i){
      Organism dummy = new Organism();
      dummys[i] = dummy;
      dummys[i].setOrganism("SIMPLE", "SMOOTH", "MEDIUM", "ARC", i-MAX_DUMMY/2, random(100, wid-100), random(100, hei-100));
      dummys[i].setDead(0);
      dummys[i].resetLifetime();
      dummys[i].GotoRandom(float(wid), float(hei));
  }
  Organism dummy = new Organism();
  dummys[MAX_DUMMY/2+1] = dummy;
  dummys[MAX_DUMMY/2+1].setOrganism("NORMAL", "RANDOM", "MEDIUM", "ARC", 5, random(100, wid-100), random(100, hei-100));
  dummys[MAX_DUMMY/2+1].setDead(0);
  dummys[MAX_DUMMY/2+1].resetLifetime();
  dummys[MAX_DUMMY/2+1].GotoRandom(float(wid), float(hei));
}

/**
 * 
 * 
 */
void draw() {

  // Count frame
  frame_cnt = (frame_cnt > 50000) ? 0 : frame_cnt + 1;
  frame_30 = (frame_cnt % 30 == 0) ? 1 : 0;
  frame_100 = (frame_cnt % 100 == 0) ? 1 : 0;
  frame_200 = (frame_cnt % 200 == 0) ? 1 : 0;
  
  drawBackground();
  
  for(int i=0; i<MAX_ORGANISM; ++i){
    if( organism_system[i].isDead() == 1) continue;
    int life = organism_system[i].getLifetime();
    float x = organism_system[i].getX();
    float y = organism_system[i].getY();
    if((life >= 5000 ) || ((x > width+100 || x < -100) && ( y > hei+100 || y < -80))){ // Deal with dead organisms
      organism_system[i].setDead(1);
      organism_system[i].resetLifetime();
      --num_organism;
      //System.out.println("DEAD");
    }
  }
  
  // Draw organisms
  for(int i=0; i<MAX_ORGANISM; ++i){
    if(organism_system[i].isDead() == 1) continue;
    drawOrganism(organism_system[i]);
    organism_system[i].MoveToTarget();
    if(organism_system[i].isMature()==0){ // if not mature, grow
      organism_system[i].setMature(organism_system[i].grow());
    }
  }
  
  // Set organism behavior
  for(int i=0; i<MAX_ORGANISM; ++i){
    if(organism_system[i].isDead() == 1) continue;
    for (LifeAnt ant : lfs[i].getAnts()) {
      if (frame_200 == 1) {//!ant.isCompleted()
        Vertex move_x = ant.getCurrentTrace().getDimension("x");
        switch(move_x.getName()) {
          case "SPREAD":
            if(organism_system[i].getCurrentSize() < organism_system[i].getMaxSize()*1.5)
              organism_system[i].setCurrentSize(0.005*organism_system[i].getCurrentSize());
            //System.out.println("SPREAD");
            break;
          case "SHRINK":
            if(organism_system[i].getCurrentSize() > organism_system[i].getMaxSize()*0.8)
              organism_system[i].setCurrentSize(-0.005*organism_system[i].getCurrentSize());
            //System.out.println("SHRINK");
            break;
          case "CHANGE":
            if(frame_cnt % 150 != 0)
              break;
            //System.out.println("CHANGE");
            int temp = findNearest(i);
            //int temp = (int)random(0, MAX_ORGANISM); //organism_system[temp].isDead() == 0
            if(temp != -1){
              organism_system[i].change_color_to(organism_system[temp].getColor());
            }
            break;
          case "FIND":
            int find_target = (int) random(0, num_organism);
            if(organism_system[find_target].isDead() == 0){ //  && organism_system[i].isNear()==1
              organism_system[i].FindFriend(organism_system[find_target]);
              //System.out.println("FIND");
            }
            break;
          case "ESCAPE":
            int escape_target = (int) random(0, num_organism);
            if(organism_system[escape_target].isDead() == 0){ // && organism_system[i].isNear()==1
               organism_system[i].EscapeFrom(organism_system[escape_target]);
               //System.out.println("ESCAPE");
             }
            break;
          case "SPEED_UP":
            //System.out.println("SPEED_UP");
            organism_system[i].speedUpX(0.01);
            organism_system[i].speedUpY(0.01);
            break;
          case "SPEED_DOWN":
            //System.out.println("SPEED_DOWN");
            organism_system[i].speedUpX(0.01);
            organism_system[i].speedUpY(0.01);
            break;
          case "IDLE":
          //go to random place
          if(random(0, 1) > 0.7 && organism_system[i].isNear()==1){
            organism_system[i].GotoRandom(float(wid), float(hei));
            //System.out.println("GO RANDOM");
          }
          //System.out.println("IDLE");
            break;
          default:            //
          //System.out.println("DEFAULT");
          }
        }
    lfs[i].navigate();
    }
  }

  if(status == 0){
    // Show prompt message
    textSize(20);
    scale(-1, 1);
    fill(31, 31, 88);
    msg = MSG1;
    text(msg, -(wid-leftmost), lineone);
    // Show user input
    textSize(20);
    fill(68, 84, 144);
    if(frame_cnt % 50 < 25){
      text(input+"_", -(wid-leftmost), linetwo);
    }else{
      text(input, -(wid-leftmost), linetwo);
    }
  // End of status 0 : User input
  }else if(status == 1){
    if(deal_with_input() == 1){
      status = 2;
      msg = MSG2;
    }else{
      status = 0;
    }
    
    ga = new GeneticAlgorithm(100, 0.001, 0.95, 2, target_ascii);
    population = ga.initPopulation(chromosomeLength);
  // End of status 1 : Deal with input string and start GA
  }else if(status == 2){
    if(frame_cnt % 30 == 0){
      if(msg == MSG2){
        msg = MSG3;
      }else if(msg == MSG3){
        msg = MSG4;
      }else{
        msg = MSG2;
      }
    }
    // Show "Creating..." message.
    textSize(20);
    scale(-1, 1);
    fill(31, 31, 88);
    text(msg, -(wid-leftmost), lineone);
    
    // Evaluate population
    ga.evalPopulation(population);
    // get the fittest solution
    Individual fittest = population.getFittest(0);
    // Add sharpness to sum_sharpness
    sum_sharpness += fittest.getSharpness();
    
    // Show current fittest (in ascii)
    String chromosome_b = "";
    int chromosome[] = fittest.getChromosome();
    for(int i = 0; i< chromosomeLength; ++i){
      if(i % 7 == 0){
        chromosome_b += "0";
      }
      if (chromosome[i] == 1){
        chromosome_b += "1";
      }else{
        chromosome_b += "0";
      }
    }
   
    //System.out.println(chromosome_b);
    String s2 = "";   
    char next;

    for(int i = 0; i <= chromosome_b.length()-8; i += 8){
         next = (char)Integer.parseInt(chromosome_b.substring(i, i+8), 2);
         if(next < ' ' || next > '~'){
           next = '?';
         }
         s2 += next;
         
    }
    // show progress
    textSize(20);
    fill(68, 84, 144);
    text(s2, -(wid-leftmost), linetwo);
    
    
    if(generation == 500 && ga.isTerminationConditionMet(population) == false){
      /* Solution not found in 500 generations, end GA*/
      //System.out.println("700 generations");
      avg_sharpness = (float) sum_sharpness / (generation+1);
      status = 3;
      result = s2;
    }else if(ga.isTerminationConditionMet(population) == false) {    
      // Crossover
      population = ga.crossoverPopulation(population);
      // Mutation
      population = ga.mutatePopulation(population);
      // Go to next generation
      generation++;
    }else{
      /* Solution found.*/
      //System.out.println("Found solution in " + generation + " generations");
      avg_sharpness = (float) sum_sharpness / (generation+1);
      status = 3;
      result = s2;
    }
  // End of status 2 : Running GA
  }else if(status == 3){
    if(start_clk == 0){
      int j;
      for(j=0; j<MAX_ORGANISM; ++j){
        if(organism_system[j].isDead() == 0){
          continue;
        }else{
          setOrganism_main(j);
          //if(organism_system[j].getType()=="SIMPLE")
          //  lfs[j] = new LifeSystem(5);
          //else if (organism_system[j].getType()=="NORMAL")
            lfs[j] = new LifeSystem(10);
          //else
          //  lfs[j] = new LifeSystem(25);
          lfs[j].init_graphs();
          lfs[j].init_population();
          for (LifeAnt ant : lfs[j].getAnts()) {
            map.put(ant, 10.0);
          }
          break;
        }
      }     
      ++num_organism;
      
      start_clk = 1;
      clk = frame_cnt;
    }
    if(frame_cnt - clk >= 150){ // wait 150 frames
      status = 4;
    }
    // Show welcome message.
    textSize(20);
    fill(68, 84, 144);
    scale(-1, 1);
    msg = MSG5+" "+target+".";
    text(msg, -(wid-leftmost), lineone);
  // End of status 3 : Generate organism 
  }else if(status == 4){
    sum_sharpness = 0;
    start_clk = 0;
    generation = 0;
    result = "";
    status = (num_organism == MAX_ORGANISM-1) ? 5 : 0;
    input = "";
  // End of status 4 : Reset parameters
  }else if(status == 5){
    if(num_organism < MAX_ORGANISM-1){
      status = 0;
    }   
  // End of status 5 : Full, wait until avaliable
  }

  
}

void keyPressed() {

  // If not creating, accept keyboard input.
  if(status == 0){
    if ((key>=' ' && key<='~')&& input.length() < MAX_LENGTH + 1){
      input+=key;
    }else if(key == BACKSPACE && input.length() > 0){
      // Delete one character
       input = input.substring(0, input.length()-1);
    }else if(key == ENTER && input.length() >0){
      status = 1;
      target = input;
      input = "";
    }
  }
  
}

int deal_with_input(){
  chromosomeLength = target.length()*7;
  
  char temp[] = target.toCharArray();
  String target_to_bi = "";
  for(int i=0; i<target.length(); ++i){
    target_to_bi += binary(temp[i], 7);
  }
  target_ascii = new int[chromosomeLength];
  temp = target_to_bi.toCharArray();
  for(int i=0; i< chromosomeLength; ++i){
    if(temp[i] == '0'){
      target_ascii[i] = 0;
    }else{
      target_ascii[i] = 1;
    }
  }
  return 1;
}

void setOrganism_main(int idx){
    Individual fittest = population.getFittest(0);
    int[] chromosome = fittest.getChromosome();
    
    String TYPE = "";
    if(generation < 50){
      TYPE = "SIMPLE";
    }else if(generation < 300){
      TYPE = "NORMAL";
    }else{
      TYPE = "COMPLICATED";
    }
    
    String SHARPNESS = "";
    if(avg_sharpness > 2.0){
      SHARPNESS = "SHARP";
    }else if(avg_sharpness > 0.5){
      SHARPNESS = "RANDOM";
    }else{
      SHARPNESS = "SMOOTH";
    }
    
    int feet = 0;
    int ones = 0;
    for(int i=0; i<chromosomeLength - 2; ++i){
      if(chromosome[i] == 1 && chromosome[i+1] == 1 && chromosome[i+2] == 1){
        ++feet;
      }
    }
    for(int i=0; i<chromosomeLength; ++i){
      if(chromosome[i] == 1){
        ++ones;
      }
    }
    
    int FEET = (feet > 10) ? 10 : feet;
    
    float ones_percentage = (float) ones / chromosomeLength;
    String SIZE = "";
    if(ones_percentage > 0.7){
      SIZE = "LARGE";
    }else if(ones_percentage > 0.5){
      SIZE = "MEDIUM";
    }else{
      SIZE = "SMALL";
    }
    
    String CORE = "";
    int vowel = 0, not_en = 0;
    char temp;
    for(int i=0; i<result.length(); ++i){
      temp = result.charAt(i);
      if(temp == 'A' || temp == 'E' || temp == 'I' ||
         temp == 'O' || temp == 'U' || temp == 'a' ||
         temp == 'e' || temp == 'i' || temp == 'o' ||
         temp == 'u'){
           ++vowel;
         }else if((temp>=' ' && temp<='/') ||
                  (temp>=':' && temp<='@') ||
                  (temp>='[' && temp<'a') ||
                  (temp>='{' && temp<='~')){
                    ++not_en;
         }
    }
    
    float vowel_p = (float) vowel/result.length();
    float not_en_p = (float) not_en/result.length();
    if(vowel_p >= 0.5){
      CORE = "ARC";
    }else if(not_en_p >= 0.2){
      CORE = "TRIANGLE";
    }else{
      CORE = "SQUARE";
    }
    //System.out.println("Created: " + TYPE + " " + SHARPNESS + " " + SIZE + " " + CORE + " " + FEET);
    //System.out.println("sharpness: " + avg_sharpness);
    
    organism_system[idx].setOrganism(TYPE, SHARPNESS, SIZE, CORE, FEET, random(100, wid-100), random(100, hei-100));
    organism_system[idx].setDead(0);
    organism_system[idx].resetLifetime();
}

void drawOrganism(Organism organism){
    String TYPE = organism.getType();
    String CORE = organism.getCore();
    String SHARPNESS = organism.getSharpness();
    int FEET = organism.getFeet();
    float size = organism.getCurrentSize();
    float x = organism.getX();
    float y = organism.getY();
    float speed_x = organism.getSpeedX();
    float speed_y = organism.getSpeedY();
    float angle = organism.getAngle();
    color CORECOLOR = organism.getCoreColor();
    color COLOR0 = organism.getColor0();
    color COLOR1 = organism.getColor1();
    color COLOR2 = organism.getColor2();
    int life = organism.getLifetime();
   
    noStroke();
    fill(COLOR2, 10);
    circle(x, y, size*2+5);
    circle(x, y, size*2-15);/*
    fill(CORECOLOR, 20);
    circle(x, y, size/2.5);*/
    noFill();
    
    float stroke_weight = size/30.0;
    strokeWeight(stroke_weight);
    switch(TYPE){
      case "NORMAL":
        noFill();
        if(SHARPNESS == "SMOOTH"){
          stroke(COLOR2, opacity);
          circle(x, y, size*1.3);
          if(CORE == "ARC"){
            stroke(CORECOLOR, opacity-40);
            strokeWeight(0.5);
            fill(COLOR1, opacity);
            float arc_width = random(5, size);
            arc(x, y, arc_width, arc_width, angle+random(0, 2*PI), angle+random(0, 2*PI));
          }else if(CORE == "TRIANGLE"){
            stroke(COLOR0, opacity);
            fill(CORECOLOR, opacity-40);
            triangle(x+size*cos(angle)*0.5, y+size*sin(angle)*0.5, x+size*cos(angle+PI/1.5)*0.5, y+size*sin(angle+PI/1.5)*0.5, x+size*cos(angle+PI/0.75)*0.5, y+size*sin(angle+PI/0.75)*0.5);
          }else{
            strokeWeight(0.5);
            stroke(CORECOLOR, opacity-40);
            fill(COLOR1, opacity);
            beginShape();
            float a = random(x-size/2, x+size/2), b = random(x-size/2, x+size/2), c = random(y-size/2, y+size/2), d = random(y-size/2, y+size/2);
            vertex(a,c);
            vertex(b,c);
            vertex(b,d);
            vertex(a,d);
            endShape(CLOSE); 
          }
        }else if(SHARPNESS == "SHARP"){
          stroke(COLOR2, opacity);
          triangle(x+size*cos(angle), y+size*sin(angle), x+size*cos(angle+PI/1.5), y+size*sin(angle+PI/1.5), x+size*cos(angle+PI/0.75), y+size*sin(angle+PI/0.75));
          if(CORE == "ARC"){
            stroke(CORECOLOR, opacity-40);
            strokeWeight(0.5);
            fill(COLOR1, opacity);
            float arc_width = random(5, size);
            arc(x, y, arc_width, arc_width, angle+random(0, 2*PI), angle+random(0, 2*PI));
          }else if(CORE == "TRIANGLE"){
            stroke(CORECOLOR, opacity-40);
            fill(COLOR1, opacity);
            triangle(x+size*cos(angle)*0.5, y+size*sin(angle)*0.5, x+size*cos(angle+PI/1.5)*0.5, y+size*sin(angle+PI/1.5)*0.5, x+size*cos(angle+PI/0.75)*0.5, y+size*sin(angle+PI/0.75)*0.5);
          }else{
            strokeWeight(0.5);
            stroke(COLOR0, opacity);
            fill(CORECOLOR, opacity-40);
            beginShape();
            float a = random(x-size/2, x+size/2), b = random(x-size/2, x+size/2), c = random(y-size/2, y+size/2), d = random(y-size/2, y+size/2);
            vertex(a,c);
            vertex(b,c);
            vertex(b,d);
            vertex(a,d);
            endShape(CLOSE); 
          }
        }else{
          // random
          stroke(COLOR2, opacity);
          beginShape();
          vertex(x+size*cos(angle), y+size*sin(angle));
          vertex(x+size*cos(angle-PI/5), y+size*sin(angle-PI/5));
          vertex(x+size*cos(angle-PI/2.5), y+size*sin(angle-PI/2.5));
          vertex(x+size*cos(angle-PI/1.66), y+size*sin(angle-PI/1.66));
          vertex(x+size*cos(angle-PI/1.25), y+size*sin(angle-PI/1.25));
          vertex(x+size*cos(angle-PI), y+size*sin(angle-PI));
          vertex(x+size*cos(angle-PI/0.833), y+size*sin(angle-PI/0.833));
          vertex(x+size*cos(angle-PI/0.713), y+size*sin(angle-PI/0.713));
          vertex(x+size*cos(angle-PI/0.625), y+size*sin(angle-PI/0.625));
          vertex(x+size*cos(angle-PI/0.555), y+size*sin(angle-PI/0.555));
          endShape(CLOSE); 
          if(CORE == "ARC"){
            stroke(CORECOLOR, opacity-40);
            strokeWeight(0.5);
            fill(COLOR1, opacity);
            float arc_width = random(5, size);
            arc(x, y, arc_width, arc_width, angle+random(0, 2*PI), angle+random(0, 2*PI));
          }else if(CORE == "TRIANGLE"){
            stroke(COLOR0, opacity);
            fill(CORECOLOR, opacity-40);
            for(float i=1.0; i<2.0; i += 1.0){
              triangle(x+size*cos(angle)*0.5/i, y+size*sin(angle)*0.5/i, x+size*cos(angle+PI/1.5)*0.5/i, y+size*sin(angle+PI/1.5)*0.5/i, x+size*cos(angle+PI/0.75)*0.5/i, y+size*sin(angle+PI/0.75)*0.5/i);
            }
          }else{
            strokeWeight(0.5);
            stroke(COLOR0, opacity);
            fill(CORECOLOR, opacity-40);
            beginShape();
            float a = random(x-size/2, x+size/2), b = random(x-size/2, x+size/2), c = random(y-size/2, y+size/2), d = random(y-size/2, y+size/2);
            vertex(a,c);
            vertex(b,c);
            vertex(b,d);
            vertex(a,d);
            endShape(CLOSE); 
          }        
         }
        break;
      case "COMPLICATED":
        noFill();
        if(SHARPNESS == "SMOOTH"){
          stroke(COLOR2, opacity);
          circle(x, y, size*1.3);
          if(CORE == "ARC"){
            stroke(COLOR0, opacity);
            strokeWeight(0.5);
            fill(CORECOLOR, opacity-40);
            for(int i=1; i<3; ++i){
                float arc_width = random(5, size);
                arc(x, y, arc_width, arc_width, angle+random(0, 2*PI), angle+random(0, 2*PI));
            }
          }else if(CORE == "TRIANGLE"){
            stroke(COLOR0, opacity);
            fill(CORECOLOR, opacity-40);
            for(float i=1.0; i<4.0; i += 1.0){
              triangle(x+size*cos(angle)*0.5/i, y+size*sin(angle)*0.5/i, x+size*cos(angle+PI/1.5)*0.5/i, y+size*sin(angle+PI/1.5)*0.5/i, x+size*cos(angle+PI/0.75)*0.5/i, y+size*sin(angle+PI/0.75)*0.5/i);
            }
          }else{
            strokeWeight(0.5);
            stroke(COLOR0, opacity);
            fill(CORECOLOR, opacity-40);
            for(int i=1; i<5; ++i){
                beginShape();
                float a = random(x-size/2, x+size/2), b = random(x-size/2, x+size/2), c = random(y-size/2, y+size/2), d = random(y-size/2, y+size/2);
                vertex(a,c);
                vertex(b,c);
                vertex(b,d);
                vertex(a,d);
                endShape(CLOSE);          
            }
          }
        }else if(SHARPNESS == "SHARP"){
          stroke(COLOR2, opacity);
          triangle(x+size*cos(angle), y+size*sin(angle), x+size*cos(angle+PI/1.5), y+size*sin(angle+PI/1.5), x+size*cos(angle+PI/0.75), y+size*sin(angle+PI/0.75));
          if(CORE == "ARC"){
            stroke(COLOR0, opacity);
            strokeWeight(0.5);
            fill(CORECOLOR, opacity-40);
            for(int i=1; i<3; ++i){
                float arc_width = random(5, size);
                arc(x, y, arc_width, arc_width, angle+random(0, 2*PI), angle+random(0, 2*PI));
            }
          }else if(CORE == "TRIANGLE"){
            stroke(COLOR0, opacity);
            fill(CORECOLOR, opacity-40);
            for(float i=1.0; i<4.0; i += 1.0){
              triangle(x+size*cos(angle)*0.5/i, y+size*sin(angle)*0.5/i, x+size*cos(angle+PI/1.5)*0.5/i, y+size*sin(angle+PI/1.5)*0.5/i, x+size*cos(angle+PI/0.75)*0.5/i, y+size*sin(angle+PI/0.75)*0.5/i);
            }
          }else{
            strokeWeight(0.5);
            stroke(COLOR0, opacity);
            fill(CORECOLOR, opacity-40);
            for(int i=1; i<3; ++i){
                beginShape();
                float a = random(x-size/2, x+size/2), b = random(x-size/2, x+size/2), c = random(y-size/2, y+size/2), d = random(y-size/2, y+size/2);
                vertex(a,c);
                vertex(b,c);
                vertex(b,d);
                vertex(a,d);
                endShape(CLOSE);          
            }
          }
        }else{
          // random
          stroke(COLOR2, opacity);
          beginShape();
          vertex(x+size*cos(angle), y+size*sin(angle));
          vertex(x+size*cos(angle-PI/5), y+size*sin(angle-PI/5));
          vertex(x+size*cos(angle-PI/2.5), y+size*sin(angle-PI/2.5));
          vertex(x+size*cos(angle-PI/1.66), y+size*sin(angle-PI/1.66));
          vertex(x+size*cos(angle-PI/1.25), y+size*sin(angle-PI/1.25));
          vertex(x+size*cos(angle-PI), y+size*sin(angle-PI));
          vertex(x+size*cos(angle-PI/0.833), y+size*sin(angle-PI/0.833));
          vertex(x+size*cos(angle-PI/0.713), y+size*sin(angle-PI/0.713));
          vertex(x+size*cos(angle-PI/0.625), y+size*sin(angle-PI/0.625));
          vertex(x+size*cos(angle-PI/0.555), y+size*sin(angle-PI/0.555));
          endShape(CLOSE); 
          if(CORE == "ARC"){
            stroke(COLOR0, opacity);
            strokeWeight(0.5);
            fill(CORECOLOR, opacity-40);
            for(int i=1; i<3; ++i){
                float arc_width = random(5, size);
                arc(x, y, arc_width, arc_width, angle+random(0, 2*PI), angle+random(0, 2*PI));
            }
          }else if(CORE == "TRIANGLE"){
            stroke(COLOR0, opacity);
            fill(CORECOLOR, opacity-40);
            for(float i=1.0; i<4.0; i += 1.0){
              triangle(x+size*cos(angle)*0.5/i, y+size*sin(angle)*0.5/i, x+size*cos(angle+PI/1.5)*0.5/i, y+size*sin(angle+PI/1.5)*0.5/i, x+size*cos(angle+PI/0.75)*0.5/i, y+size*sin(angle+PI/0.75)*0.5/i);
            }
          }else{
            strokeWeight(0.5);
            stroke(COLOR0, opacity);
            fill(CORECOLOR, opacity-40);
            for(int i=1; i<3; ++i){
                beginShape();
                float a = random(x-size/2, x+size/2), b = random(x-size/2, x+size/2), c = random(y-size/2, y+size/2), d = random(y-size/2, y+size/2);
                vertex(a,c);
                vertex(b,c);
                vertex(b,d);
                vertex(a,d);
                endShape(CLOSE);          
            }
          }
         }
        break;
      case "SIMPLE":
        if(SHARPNESS == "SMOOTH"){
          stroke(COLOR2, opacity);
          circle(x, y, size*1.3);
        }else if(SHARPNESS == "SHARP"){
          stroke(COLOR2, opacity);
          triangle(x+size*cos(angle), y+size*sin(angle), x+size*cos(angle+PI/1.5), y+size*sin(angle+PI/1.5), x+size*cos(angle+PI/0.75), y+size*sin(angle+PI/0.75));
        }else{
          stroke(COLOR2, opacity);
          beginShape();
          vertex(x+size*cos(angle), y+size*sin(angle));
          vertex(x+size*cos(angle-PI/5), y+size*sin(angle-PI/5));
          vertex(x+size*cos(angle-PI/2.5), y+size*sin(angle-PI/2.5));
          vertex(x+size*cos(angle-PI/1.66), y+size*sin(angle-PI/1.66));
          vertex(x+size*cos(angle-PI/1.25), y+size*sin(angle-PI/1.25));
          vertex(x+size*cos(angle-PI), y+size*sin(angle-PI));
          vertex(x+size*cos(angle-PI/0.833), y+size*sin(angle-PI/0.833));
          vertex(x+size*cos(angle-PI/0.713), y+size*sin(angle-PI/0.713));
          vertex(x+size*cos(angle-PI/0.625), y+size*sin(angle-PI/0.625));
          vertex(x+size*cos(angle-PI/0.555), y+size*sin(angle-PI/0.555));
          endShape(CLOSE);
        }
        break;
      default:
          
    }
    
    drawFeet(x, y, speed_x, speed_y, size, FEET, angle, COLOR1, life);
    
}

void drawFeet(float x, float y, float speed_x, float speed_y, float size, int feet, float angle, color c, int life){
  stroke(c, opacity-20);
  strokeWeight(2);
  noFill();
  for(int i=0; i<feet; ++i){
    float angle_feet = i*2*PI/feet + PI/2;
    if(life % 100 < 50){
      bezier(x+size*cos(angle_feet+angle), y+size*sin(angle_feet+angle), x+size*cos(angle_feet+angle)+size*(speed_x)/5.0, y+size*sin(angle_feet+angle)+size*(speed_y)/5.0 , x+(size*1.3)*cos(angle_feet+angle), y+(size*1.3)*sin(angle_feet+angle), x-size*(speed_x)/5.0+(size*1.3)*cos(angle_feet+angle), y-size*(speed_y)/5.0+(size*1.3)*sin(angle_feet+angle));
    }else{
      line(x+size*cos(angle_feet+angle), y+size*sin(angle_feet+angle), x+(size*1.3)*cos(angle_feet+angle), y+(size*1.3)*sin(angle_feet+angle));
    }
  }
}

int findNearest(int a){
  float min_distance = 6000;
  float distance;
  int current = -1;
  float x, y, x1, y1, x2, y2;
  x1 = organism_system[a].getX();
  y1 = organism_system[a].getY();
  for(int i=0; i<MAX_ORGANISM; ++i){
    if(i==a || organism_system[i].isDead()==1) continue;
    x2 = organism_system[i].getX();
    y2 = organism_system[i].getY();
    x = x1-x2;
    y = y1-y2;
    distance = x*x+y*y;
    if(distance < min_distance){
      min_distance = distance;
      current = i;
    }
  }
  if(min_distance < 6000)
    return current;
  //System.out.println("min_distance of "+ a + " is " + min_distance);
  return -1;
}

void drawBackground(){
  
  // Background color
  background(243, 240, 230);
  for(int i=0; i<MAX_DUMMY; ++i){
    drawOrganism(dummys[i]);
    dummys[i].MoveToTarget();
    if(dummys[i].getLifetime() % 200 == 0){
      dummys[i].GotoRandom((float)wid, (float)hei);
    }  
    if(dummys[i].isMature()==0){ // if not mature, grow
      dummys[i].setMature(dummys[i].grow());
    }
  }
  noStroke();
  fill(243, 240, 230, 130);
  rect(0, 0, wid, hei);

}
