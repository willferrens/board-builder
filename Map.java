import processing.core.*;

public class Map extends PApplet {
 
  private final int wx, wy, ww, wh;
  private processing.data.JSONObject json;
  private processing.data.JSONArray grid;
  
  private float sgs;
  private String[] cols;
  private int w, h, gs, bx, by;
  private int sw, sh, xscl, yscl, yran;
  
  public Map(processing.data.JSONObject j, String[] cs, int x, int y, int w, int h) {
    this.wx = x;
    this.wy = y;
    this.ww = w;
    this.wh = h;
    
    this.json = j;
    this.cols = cs;
  }
  
  public void settings() {
    size(this.ww, this.wh); 
  }
  
  public void setup() {
    surface.setLocation(this.wx, this.wy);
    
    this.w = json.getInt("width");
    this.h = json.getInt("height");
    this.gs = json.getInt("grid-size");
    
    this.grid = json.getJSONArray("grid");
    
    // gets the highest/max x
    // which is the also the scale
    xscl = highX();
    // gets the lowest/min y
    yscl = lowY();
    // finds the max y and adds the low y
    // creates the total length of the ys
    yran = highY() + abs(lowY());
    
    // how many squares are per screen for both the width and height
    sw = parseInt(json.getInt("width") / json.getInt("grid-size"));
    sh = parseInt(json.getInt("height") / json.getInt("grid-size"));
  }
  
  public void draw() {
    background(0);
    
    loadGrid();
    
    // overlay square
    fill(255, 155, 0, 75);
    noStroke();
    rect(
      this.bx * this.sgs, 
      this.by * this.sgs, 
      sw * this.sgs, 
      sh * this.sgs
    );
  }
  
  public void loadGrid() {
    // creates a scaled grid size
    this.sgs = this.wh / (yran == 0 ? sh : yran);
    
    stroke(0);
    if (yran > 50) {
      strokeWeight(3/4);
    } else {
      strokeWeight(1); 
    }
    // draws empty squares from the bottom left
    for (int i = yran; i >= yscl; i--) {
      for (int j = 0; j <= xscl + sw; j++) {
        fill(255);
        square(
          j * this.sgs,
          (i - lowY()) * this.sgs,
          this.sgs
        );
      }
    }
    // draws blocks from gird
    for (int k = 0; k < this.grid.size(); k++) {
      processing.data.JSONObject block = grid.getJSONObject(k);
        
      int type = block.getInt("type");
      int c = Integer.parseInt(cols[type == 10 ? 9 : type], 16);
      fill(red(c), green(c), blue(c));
      square(
        block.getInt("x") * this.sgs, 
        (block.getInt("y") - yscl) * this.sgs, 
        this.sgs
      );
    }
  }
  
  // calculates the highest x in the grid
  public int highX() {
    this.grid = json.getJSONArray("grid");
    
    int highX = 0;
    for (int i = 0; i < this.grid.size(); i++) {
      processing.data.JSONObject block = this.grid.getJSONObject(i);
      if (block.getInt("x") > highX) {
        highX = block.getInt("x"); 
      }
    }
    
    return highX;
  }
  
  // calculates the highest y in the grid
  public int highY() {
    this.grid = json.getJSONArray("grid");
    
    int highY = 0;
    for (int i = 0; i < this.grid.size(); i++) {
      processing.data.JSONObject block = this.grid.getJSONObject(i);
      if (block.getInt("y") > highY) {
        highY = block.getInt("y");
      }
    }
    
    return highY;
  }
  
  // calculates the lowest y in the grid
  public int lowY() {
    this.grid = json.getJSONArray("grid");
    
    int lowY = 0;
    for (int i = 0; i < this.grid.size(); i++) {
      processing.data.JSONObject block = this.grid.getJSONObject(i);
      if (block.getInt("y") < lowY) {
        lowY = block.getInt("y");
      }
    }
    
    return lowY;
  }
  
  // updates the overlay box
  public void updateBox(int x, int y) {
    this.bx = x;
    this.by = y + (yran - sh);
    
    xscl = highX();
    yscl = lowY();
    yran = sh + abs(yscl);
  }
  
}
