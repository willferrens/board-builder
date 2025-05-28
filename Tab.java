import processing.core.*;

// acts as a display for the 
// different types of blocks
// displays the actiontype 
// for the user
public class Tab extends PApplet {
  
  private final int w, h, px, py;
  private int active;
  private boolean action = true;
  private String[] cols;
  private processing.data.JSONObject json;
  
  public Tab(processing.data.JSONObject j, String[] cs, int x, int y, int w, int h) {
    this.w = w;
    this.h = h;
    this.px = x;
    this.py = y;
    this.json = j;
    
    this.cols = cs;
  }
  
  public void settings() {
    size(this.w, this.h);
  }
  
  public void setup() {
    surface.setLocation(this.px, this.py); 
  }
  
  public void draw() {
    background(255); 
    textAlign(CENTER, CENTER);
    
    // TYPES LIST
    for (int i = 0; i < this.cols.length; i++) {

      int col = Integer.parseInt(this.cols[i], 16);
      fill(color(red(col), green(col), blue(col)));
      if (this.active == i) {
        strokeWeight(6);
      } else {
        strokeWeight(1);
      }
      rect(0, i * (this.h / 12), this.w, this.h / 12);
      
      fill(0);
      text((i < 9 ? i + 1 : 0) + "", 0, i * (this.h / 12), this.w, this.h / 12);
    }
    
    // ACTION TYPE INDICATOR
    fill(255);
    strokeWeight(1);
    rect(0, 10 * (this.h / 12), this.w, 2 * (this.h / 12));
    fill(0);
    text((this.action == true ? "Add Blocks" : " Remove Blocks"), 0, 10 * (this.h / 12), this.w, 2 * (this.h / 12));
  }
  
  public void toggleAction() {
    if (this.action) {
      this.action = false;
    } else {
      this.action = true; 
    }
  }
  
  public void setActive(int x) {
    this.active = x; 
  }
  
}
