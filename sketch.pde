import static javax.swing.JOptionPane.*;
// file name for saving into ./data 
String file = "";
// structure of json, msut be followed
JSONObject json;
JSONArray grid;
// seperate sketch windows
Tab t;
Map m;
// action variables
int clickType = 0;
boolean clickAction = true; // true is add, false is remove
// colors for types
String[] cols = {
  "ff0000",
  "00ff00",
  "0000ff",
  "ffff00",
  "00ffff",
  "ff00ff",
  "ffcc00",
  "00ffcc",
  "cc00ff",
  "cccccc"
};

// creates/loads a json depeneding
// on user input and instructs them
void settings() {
  String[] opts = { "Create New Board", "Load Board" };
  int c = showOptionDialog(null,
    "Choose an option!", "Prompt", 
    YES_NO_OPTION, INFORMATION_MESSAGE,
  null, opts, opts[0]);
  
  // 0 is creates a new board and asks
  // the user to assign the specs of
  // their board
  // 1 loads a json file of a certain 
  // name from the data file
  if (c == 0) {
    // collecting the specifications for the board
    int w = int(showInputDialog(null, "How wide would you like your screen?"));
    int h = int(showInputDialog(null, "How tall would you like your screen?"));
    int gs = int(showInputDialog(null, "What would you like the size of each block?"));
    
    // creating the json object
    JSONObject j = new JSONObject();
    // setting the values of the board
    j.setInt("width", w);
    j.setInt("height", h);
    j.setInt("grid-size", gs);
    // creating an empty grid of the board
    JSONArray g = new JSONArray();
    j.setJSONArray("grid", g);
    // saving the json to a file
    file = showInputDialog(null, "What would you like the name of your file to be?\n(Do not include .json)") + ".json";
    saveJSONObject(j, "/data/"+file);
    
    showMessageDialog(null, "Your data is saved under the ./data folder as "+file);
    
    // loading the file that was just saved
    json = loadJSONObject(file);
    grid = json.getJSONArray("grid");
    
    size(json.getInt("width"), json.getInt("height"));
  } else if (c == 1) {
    showMessageDialog(null, 
      "Instructions:\nThis program uses only .json files to store board data."+
      "\nDrop your file into the ./data folder under this directory."+
      "\nEnter the name of the file into the following prompt to load it."
    );
    // saves the file name with extension
    file = showInputDialog(null, "Enter the name of your file!\n(Do not include the .json)") + ".json";
    
    // loads file that user specified
    // if name is invalid will return nullpointer
    json = loadJSONObject(file);
    grid = json.getJSONArray("grid");
    
    size(json.getInt("width"), json.getInt("height"));
  }
  // controls for the boardbuilder
  showMessageDialog(null, 
    "Controls for the BoardBuilder"+
    "\n - Click on each grid block to add a block."+
    "\n - Use arrow keys to move around the board."+
    "\n - Use the number keys to select type."+
    "\n - Press the spacebar to change action."+
    "\n - Press e to export the json to the selected file."
  );
}

// moves the window to the middle
// of the screen and creates the 
// seperate tab
void setup() {
  surface.setLocation(displayWidth / 12, displayHeight / 12); 
  
  t = new Tab(json, cols, 
    json.getInt("width") + displayWidth / 12 + 10, displayHeight / 12,
    json.getInt("width") / 5, json.getInt("height")
  );
  runSketch(new String[]{ "Tab" }, t);
  
  m = new Map(json, cols, 
    json.getInt("width") + displayWidth / 12 + json.getInt("width") / 5 + 20, displayHeight / 12, 
    json.getInt("width") / 3, json.getInt("height")
  ); 
  runSketch(new String[]{ "Map" }, m);
}

// draws the grid and blocks as 
// well as handles the cursor 
// changing depending on action type
void draw() {
  background(0);
  if (clickAction) {
    cursor(ARROW);
  } else if (!clickAction) {
    cursor(CROSS);
  }
  
  // loads blocks from json
  loadGrid(json);
  
  m.updateBox(-(xoff / json.getInt("grid-size")), -(yoff / json.getInt("grid-size")));
}

// controls the adding/removing of 
// grid blocks and saving of the json
// but only when the mouse is clicked
void mouseClicked() {
  manageBlock();
}

// controls the adding/removing of 
// grid blocks and saving of the json
// but only when the mouse is dragged
void mouseDragged() {
  manageBlock();
}

// controls the toggling of actiontype,
// exporting the json, moving around the
// board and changing the clicktype
void keyPressed() {
  if (key == ' ') {
    if (clickAction) {
      clickAction = false;
      t.toggleAction();
    } else {
      clickAction = true; 
      t.toggleAction();
    }
  }
  
  if (key == 'e') {
    saveJSONObject(json, "/data/"+file); 
    showMessageDialog(null, "Saved "+file+" to the ./data folder!");
  }
  
  if (keyCode == LEFT) {
    if (!(xoff == 0)) xoff += json.getInt("grid-size");
  } else if (keyCode == RIGHT) {
    xoff -= json.getInt("grid-size");
  }
  
  if (keyCode == UP) {
    yoff += json.getInt("grid-size");
  } else if (keyCode == DOWN) {
    if (!(yoff == 0)) yoff -= json.getInt("grid-size");
  }

  if (int(key) >= 48 && int(key) <= 57) {
    int k = int(String.valueOf(key)); // KEY AS INT
    if (k == 0) {
      clickType = 10;
      t.setActive(9);
    } else {
      clickType = k - 1;
      t.setActive(k - 1);
    }
  }
}

// block offsets for drawing
int xoff = 0;
int yoff = 0;
// displays grid according to the block offsets
// draws empty blocks then draws over them with
// blocks in the grid array of the json
void loadGrid(JSONObject json) {
  int gw = int(json.getInt("width") - abs(xoff) / json.getInt("grid-size"));
  int gh = int(json.getInt("height") / json.getInt("grid-size"));
  
  grid = json.getJSONArray("grid");
  
  for (int i = -yoff / json.getInt("grid-size"); i < gh; i++) {
    for (int j = 0; j < gw; j++) {
      fill(255);
      square(
        json.getInt("grid-size") * j + xoff,
        json.getInt("grid-size") * i + yoff,
        json.getInt("grid-size")
      );
      for (int k = 0; k < grid.size(); k++) {
        JSONObject block = grid.getJSONObject(k);
        
        if (j == block.getInt("x") && i == block.getInt("y")) {
          int type = block.getInt("type");
          int c = Integer.parseInt(cols[type == 10 ? 9 : type], 16);
          fill(red(c), green(c), blue(c));
          square(
            json.getInt("grid-size") * block.getInt("x") + xoff, 
            json.getInt("grid-size") * block.getInt("y") + yoff, 
            json.getInt("grid-size")
          );
        }
      }
    }
  }
}

// block managing function
void manageBlock() {
  int gridX = floor((mouseX - xoff) / json.getInt("grid-size"));
  int gridY = floor((mouseY + -yoff) / json.getInt("grid-size")) - (mouseY - yoff < 0 ? 1 : 0);
  
  if (clickAction) {
    if (grid.size() == 0) {
      JSONObject j = new JSONObject();
      j.setInt("x", gridX);
      j.setInt("y", gridY);
      j.setInt("type", clickType);
      
      grid.setJSONObject(0, j); 
    } else {
      boolean newB = false;
      for (int i = 0; i < grid.size(); i++) {
        JSONObject block = grid.getJSONObject(i);
        
        if (block.getInt("x") == gridX && block.getInt("y") == gridY) {
          newB = false;
        } else {
          newB = true;
        }
      }
      
      if (newB) {
        JSONObject j = new JSONObject();
        j.setInt("x", gridX);
        j.setInt("y", gridY);
        j.setInt("type", clickType);
      
        grid.setJSONObject(grid.size(), j);
      }
    }
  } else if (!clickAction) {
    for (int i = 0; i < grid.size(); i++) {
      JSONObject block = grid.getJSONObject(i);
      if (block.getInt("x") == gridX && block.getInt("y") == gridY) {
        grid.remove(i);
      }
    }
  } 
}
