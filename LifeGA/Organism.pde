import java.util.Arrays;
import java.util.Comparator;
import java.util.Random;

public class Organism {
  // Appearance
  private String _type = "SIMPLE";
  private String _sharpness = "RANDOM";
  private String _core = "ARC";
  private int _feet = 3;
  private String _size = "MEDIUM";
  private float max_size_f = 1.0;
  private float current_size = 1.0;
  
  // Life
  private int lifetime = 0;
  private int dead = 1;
  private int mature = 0;
  
  // Position
  private float x = 0.0;
  private float y = 0.0;
  private float angle = 0.0;
  private float feet_position[];
  
  // Target position
  private float target_x = 100.0;
  private float target_y = 100.0;
  
  // Speed
  private float speed_x = 0.5;
  private float speed_y = 0.5;
  private float speed_rotation = 0.03;
  
  // Color
  private color color_set[];
  private color core_color;
  private String _color = "GRAY";
  // purple set : (238, 236, 246) (181, 179, 208)  (62, 57, 83)
  // blue set : (185, 244, 252) (68, 84, 144) (31, 31, 88)
  // red set : (219, 97, 70) (235, 169, 155) (246, 213, 206)
  // green set :  (229, 246, 208) (157, 201, 107) (116, 161, 54)
  // gray set :  (206, 207, 208) (164, 164, 165) (151, 129, 106) 
  
  public Organism(){
    this.color_set = new color[3];
    int temp = (int)random(0,5);
    switch(temp){
      case 0: // purple
        this.color_set[0] = color(238, 236, 246);
        this.color_set[1] = color(181, 179, 208);
        this.color_set[2] = color(62, 57, 83);
        this._color = "PURPLE";
        break;
      case 1: // blue
        this.color_set[0] = color(185, 244, 252);
        this.color_set[1] = color(68, 84, 144);
        this.color_set[2] = color(31, 31, 88);  
        this._color = "BLUE";
        break;
      case 2: // red
        this.color_set[0] = color(246, 213, 206);
        this.color_set[1] = color(235, 169, 155);
        this.color_set[2] = color(219, 97, 70);
        this._color = "RED";
        break;
      case 3: // green
        this.color_set[0] = color(229, 246, 208);
        this.color_set[1] = color(157, 201, 107);
        this.color_set[2] = color(116, 161, 54); 
        this._color = "GREEN";
        break;
      default: // gray
        this.color_set[0] = color(206, 207, 208);
        this.color_set[1] = color(164, 164, 165);
        this.color_set[2] = color(151, 129, 106);
        this._color = "GRAY";
    }
    this.core_color = color(random(0, 256), random(0, 256), random(0, 256));
  }
  
  public void setOrganism(String type, String sharpness, String size, String core, int feet, float x, float y){
    this._type = type;
    this._sharpness = sharpness;
    this._size = size;
    this._core = core;
    this._feet = feet;
    this.x = x;
    this.y = y;
    this.lifetime = 0;
    this.dead = 0;
    this.current_size = 1.0;
    this.mature = 0;
    switch(this._size){
      case "MEDIUM":
        this.max_size_f = 50.0;
        break;
      case "LARGE":
        this.max_size_f = 90.0;
        break;
      default:
        this.max_size_f = 30.0;
        break;
    }
  }
  
  public void speedUpX(float value){
    this.speed_x += value; // if value < 0, decrease speed_x
    if(this.speed_x < -1.5) this.speed_x = -1.5;
    if(this.speed_x > 1.5) this.speed_x = 1.5;
    //this.speed_rotation = (this.speed_rotation > PI/4) ? 0.01 : this.speed_rotation + value/100.0;
  }
  
  public void speedUpY(float value){
    this.speed_y += value; // if value < 0, decrease speed_y
    if(this.speed_y < -1.5) this.speed_y = -1.5;
    if(this.speed_y > 1.5) this.speed_y = 1.5;
    //this.speed_rotation = (this.speed_rotation > PI/4) ? 0.01 : this.speed_rotation + value/100.0;
  }
  
  public int grow(){
    switch(this._size){
      case "MEDIUM":
        if(this.current_size < 50.0){
          this.current_size += 2.0;
          return 0;
        }
        return 1;
      case "LARGE":
        if(this.current_size < 90.0){
          this.current_size += 3.0;
          return 0;
        }
        return 1;
      case "SMALL":
        if(this.current_size < 30.0){
          this.current_size += 0.5;
          return 0;
        }
        return 1;
      default:
        if(this.current_size < 130.0){
          this.current_size += 5.0;
          return 0;
        }
        return 1;
    }
  }
  public String getType(){
    return this._type;
  }
  
  public String getSharpness(){
    return this._sharpness;
  }
  
  public String getSize(){
    return this._size;
  }
  
  public String getCore(){
    return this._core;
  }
  
  public int getFeet(){
    return this._feet;
  }
  
  public void Move(){
    this.x += speed_x;
    this.y += speed_y;
    if(this.isNear() == 0){
      this.angle = (this.angle + speed_rotation >= 2*PI) ? 0.0 : this.angle + speed_rotation;
    }
    if(this.dead == 0) ++this.lifetime;
  }
  
  public void MoveToTarget(){
    if((this.x > this.target_x && this.speed_x > 0) ||
        this.x < this.target_x && this.speed_x < 0){
      speedUpX(-this.speed_x*2);
    }
    if((this.y > this.target_y && this.speed_y > 0) ||
        this.y < this.target_y && this.speed_y < 0){
      speedUpY(-this.speed_y*2);
    }
    this.x += speed_x;
    this.y += speed_y;
    if(this.isNear() == 0){
      this.angle = (this.angle + speed_rotation >= 2*PI) ? 0.0 : this.angle + speed_rotation;
    }
    if(this.dead == 0) ++this.lifetime;
  }
  
  public void Goto(float x, float y){
    this.target_x = x;
    this.target_y = y;
  }
  
  public void GotoRandom(float x, float y){
    this.target_x = random(0, x);
    this.target_y = random(0, y);
  }
  
  public void FindFriend(Organism organism){
    this.target_x = organism.x;
    this.target_y = organism.y;
  }
  
  public void EscapeFrom(Organism organism){
    float vec_x = this.x - organism.x; 
    float vec_y = this.y - organism.y;
    this.target_x = this.x + vec_x;
    this.target_y = this.y + vec_y;
  }
  
  public int isNear(){
    if( distanceBetweenTarget() < 100)
      return 1;
    else
      return 0;
  }
  
  public float getX(){
    return this.x;
  }
  
  public float getY(){
    return this.y;
  }
  
  public float getAngle(){
    return this.angle;
  }
  
  public float getCurrentSize(){
    return this.current_size;
  }
  
  public color getCoreColor(){
    return this.core_color;
  }
 
  public String getColor(){
    return this._color;
  }
  
  public color getColor0(){
    return this.color_set[0];
  }
  
  public color getColor1(){
    return this.color_set[1];
  }
  
  public color getColor2(){
    return this.color_set[2];
  }
  
  public float[] getFeetPos(){
    return this.feet_position;
  }
  
  public float getSpeedX(){
    return speed_x;
  }
  
  public float getSpeedY(){
    return speed_y;
  }
  
  public int getLifetime(){
    return lifetime;
  }
  
  public void setDead(int i){
    this.dead = i;
  }
  
  public int isDead(){
    return this.dead;
  }
  
  public void resetLifetime(){
    this.lifetime = 0;
  }
  
  public float distanceBetweenTarget(){
    return sqrt((this.x - this.target_x)*(this.x - this.target_x)+(this.y - this.target_y)*(this.y - this.target_y));
  }
  
  public void setMature(int i){
    this.mature = i;
  }
  
  public int isMature(){
    return this.mature;
  }
  
  public void setCurrentSize(float val){
    this.current_size += val;
    if(this.current_size < 0) this.current_size = 1.0;
  }
  
  public float getMaxSize(){
    return this.max_size_f;
  }
  
  public void change_color(int idx, float r, float g, float b){
    float new_red = (red(this.color_set[idx])+r)/2;
    float new_green = (green(this.color_set[idx])+g)/2;
    float new_blue = (blue(this.color_set[idx])+b)/2;
    this.color_set[idx] = color(new_red, new_green, new_blue);
    this.lifetime += 10;
  }
  
  public void change_color_to(String target){
    switch(target){
      case "PURPLE":
        change_color(0, 238, 236, 246);
        change_color(1, 181, 179, 208);
        change_color(2, 62, 57, 83);
        this._color = "PURPLE";
      break;
      case "BLUE":
        change_color(0, 185, 244, 252);
        change_color(1, 68, 84, 144);
        change_color(2, 31, 31, 88);
        this._color = "BLUE";
      break;
      case "RED":
        change_color(0, 246, 213, 206);
        change_color(1, 235, 169, 155);
        change_color(2, 219, 97, 70);
        this._color = "RED";
      break;
      case "GREEN":
        change_color(0, 229, 246, 208);
        change_color(1, 157, 201, 107);
        change_color(2, 116, 161, 54);
        this._color = "GREEN";
      break;
      case "GRAY":
        change_color(0, 206, 207, 208);
        change_color(1, 164, 164, 165);
        change_color(2, 151, 129, 106);
        this._color = "GRAY";
      break;
      default:
    }
  }
}  
