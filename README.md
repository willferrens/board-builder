<div align="center">

# **2D Platformer Board Builder**

*General Information:*

![Last Commit](https://img.shields.io/badge/last%20commit-5%2F29%2F2025-orange)
![JavaScript](https://img.shields.io/badge/processing-58.7%25-blue)
![Languages](https://img.shields.io/badge/languages-2-yellow)

</div>

## Overview

An interactive program built in [Processing](https://processing.org/) that allows users to build custom 2D platformer worlds and import/export them as custom JSON files to implement into their own respective programs. The builder is equipt with a block key and overall world map (currently a work in progress), that utilizes my own customer JSON format to allow users to drop their worlds into their 2D platformers with little headache.

## Usage

In order to run my program, you will need to download the [Processing](https://processing.org/) software. Once you have it downloaded, download all the proper files and folders using `git clone` or doing so manually and then open the main `sketch.pde` or any of the corresponding files to open the project in the Processing IDE.
Once opened, running the program and following all prompts properly will allow for the best overall functionality of the program. Each section has directions that should be read carefully and needed to be adhered to in order for the world editor to work as intended.

### Example JSON File

```perl
[
    "grid": [
        { "x": 1, "y": 1, "type": 0 },
        { "x": 4, "y": 7, "type": 2 },
        { ... },
    ],
    "width": 800,
    "grid-size": 40,
    "height": 600
]
```
Each json file contains an overall `grid` array that contains block objects with their respective `(x, y)` coordinate and `block type`. Along with the overall array, the JSON also contains a `width`, `height`, and `grid-size` value for the overall implementation of the world. The `width` and `height` values are meant to be used as the overall window size of the program, and the way to properly map each block object to a 2D platformer world is to multiply its x or y coordinate by the map's grid size value. See the example below for further guidance.

### Example Implementation in Processing

```java
JSONObject json;
JSONArray grid;

void setup() {
    json = loadJSONObject("data.json");
    grid = json.getJSONArray("grid");

    size(json.getInt("width"), json.getInt("height"));
}

void draw() {
    background(0);

    for (int i = 0; i < grid.size(); i++) {
        JSONObject block = grid.getJSONObject(i);
        int blockSize = json.getInt("grid-size");

        int xPosition = block.getInt("x") * blockSize;
        int yPosition = block.getInt("y") * blockSize;

        fill(255);
        rect(xPosition, yPosition, blockSize, blockSize);
    }
}

```
