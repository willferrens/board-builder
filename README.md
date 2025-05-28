<div align="center">

# **2D Platformer Board Builder**

*General Information:*

![Last Commit](https://img.shields.io/badge/last%20commit-5%2F28%2F2025-orange)
![JavaScript](https://img.shields.io/badge/processing-58.7%25-blue)
![Languages](https://img.shields.io/badge/languages-2-yellow)

</div>

## Overview

An interactive program built in [Processing](https://processing.org/) that allows users to build custom 2D platformer worlds and import/export them as custom JSON files to implement into their own respective programs. The builder is equipt with a block key and overall world map (currently a work in progress), that utilizes my own customer JSON format to allow users to drop their worlds into their 2D platformers with little headache.

## Usage

In order to run my program, you will need to download the Processing software. Once you have it downloaded, download all the proper files and folders and then open the main sketch.pde or any of the corresponding files to open the project in the Processing IDE.
Once opened, running the program and following all prompts properly will allow for the best overall functionality of the program. Each section has directions that should be read carefully and needed to be adhered to in order for the world editor to work as intended.

### Example JSON File

```json
[
    { "x": 1, "y": 1, "type": 0 },
    { "x": 4, "y": 7, "type": 2 },
    { ... },
    "width": 800,
    "grid-size": 40,
    "height": 600
]
```
