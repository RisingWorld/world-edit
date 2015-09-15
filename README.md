# World Edit

Rising World editing tool.


## Introduction

This script is based on the original World Edit script by andyzee. The main difference with the original script are the commands.

Instead of `/we-select`, players must type `/we select` (no dash). Also, `/we-fillblock` has been replaced with `/we place` with extended arguments parameters.


## Installation

This modules has dependencies, therefore you need to make sure that all of them are properly installed before using this script!

### Using Git

Go to the `scripts` folder of your Rising World installation and type

```
git clone --recursive https://github.com/RisingWorld/world-edit.git
```

### Manually

Download the Zip file for [this](https://github.com/RisingWorld/world-edit/archive/master.zip) repository and extract it to your Rising World's `scripts/world-edit` folder.

Download the Zip file for the [i18n](https://github.com/RisingWorld/i18n/archive/master.zip) sub-module, and extract it inside the `i18n` folder of this script.

Download the Zip file for the [command parser](https://github.com/RisingWorld/command-parser/archive/master.zip) sub-module, and extract it inside the `command-parser` folder of this script.

Download the Zip file for the [table-ext](https://github.com/RisingWorld/table-ext/archive/master.zip) sub-module, and extract it inside the `table-ext` folder of this script.

Download the Zip file for the [string-ext](https://github.com/RisingWorld/string-ext/archive/master.zip) sub-module, and extract it inside the `string-ext` folder of this script.

Your final script folder should look somewhat like this

```
./risingworld/scripts/world-edit
   ./command-parser
      ./parse-args.lua
   ./i18n
      ./i18n.lua
   ./lc_messages
      ./en.locale
      ./de.locale
   ./listeners
      ./commandListener.lua
      ./playerListener.lua
   ./lua-ext
      ./string-ext.lua
      ./table-ext.lua
   ./definition.xml
   ./blocks.lua
   ./config.properties
   ./security.lua
   ./worldedit.lua
```

(**Note**: there are more files, but only the necessary ones are shown, here.)


## Updating

Whenever world-edit is updated, you should also update your server. To keep up-to-date with the newest features, but more importantly to stay up-to-date with the most recent patches of Rising World, and correct any security issues. You may also consider automating this process. The updates will take effect only after server restart.

### Using Git

Go to your `world-edit` script folder and type

```
git fetch --recurse-submodules origin master
```

### Manually

Repeat manual installation process, overwrite any existing files.


## Usage

In-game, in chat, type `/we <command>` where `<command>` is one of the following :

### Commands

* `help [command]` : dipslay help. If `command` is specified, display help for that command.  

  Ex: `/we help fill`

* `select` : start area selection  
* `cancel` : cancel area selection
* `fill <texture|#id> [-c]` : fill the selected area with the specified terrain.  Add `-c` to clear everything, first. All available textures are 
  
  Ex: `/we fill -c grass`

* `clear [obj|con|veg|block|all|abs]` : clear the selected area of (obj)ects, (con)structions, (veg)etations, (block)s, (all), or (abs)olutely everything. (Default `all`)  

  Ex: `/we clear veg`

* `paint <start|stop> <texture> [size] [height]` : paint the terrain as the player walks using the specified terrain and brush size (defaults to `1`) and height adjustement (defaults to `0`). (**Note**: the brush is square at the moment. And the terrain can only be raised.) Use `/we paint stop` to stop. It is possible to call `/we start ...` multiple times in a row, changing texture and brush size at will.
  
  Ex: `/we paint start 6 3` ... `/we paint stop`

  Ex: `/we paint start 1` ... `/we paint stop`

  Ex: `/we paint start 9 2 1` ... `/we paint stop`

* `place <blockType> id [north|east|south|west [sideway|flipped]]` : place a block with the given `id`, optionally facing the given direction and put `sideway` or `flipped`.  

  Ex: `/we place ramp 121 east flipped`

* `plant <areatype> <plants>` : plant vegetations (trees, flowers, etc.). 
  * `<areatype>` may be one of the following :
    * `single` plant a single plant right in front of the character.
    * `line <distance> <count>` plant in a straight line to the nearest axis, up to `distance` blocks. The value `count` may be an absolute value or a percentage of the total `distance`.
    * `freeline <distance> <count>` plant in the direction the character is facing, where `distance` and `count` are the same as for the above.
    * `rect <ns> <ew> <count> [-b]` plant in a rectangle **around** the character (character at the very center of the area). Both `ns` and `ew` are mandatory and determine the total width of each side. The amount of vegetation planted is determined by `count` and may be an absolute value or a percentage of the rectangle area. Use the optional `-b` (border) flag to plant at the edge of the area only, and `count` will be the perimeter instead of the area.
    * `circle <diameter> <count> [-b]` plant in a circle with the specified `diameter` around the character (character at the very center of the area). The amount of vegetation planted is determined by `count` and may be an absolute value or a percentage of the circle area. Use the `-b` (border) flag to plant at the edge of the area only, and `count` will be based on the circonference instead of the area.
  * `<plants>` is a space delimited list of plants ids to plant. To specify a range of plants, use `..` between two numbers (no space). For example `1 2 3 4 7 9 10 11 12` is the same as `1..4 7 9..12`.

  Ex: `/we plant single 13..27` plant a single random flower

  Ex: `/we plant line 10 7 29` plant 7 trees at random on a single straight line of 10 blocks long, on the nearest axis, in front of the character

  Ex: `/we plant freeline 10 50% 6 -e` plant 5 pine trees (50% of 10) spaced evenly on a single straight line, 10 blocks long, facing and in front of the character.

  Ex: `/we plant rect 30 10 100 2..4 6 7 -b` plant 100 trees at random around a perimeter of a rectangle of 30 blocks (north-south) by 10 blocks (east-west)

  Ex: `/we plant circle 20 30% 2 3 4` plant maple trees in a circle area with a diameter of 20 blocks filling it at 30%


### Textures

+ air (id `0`)
+ dirt (id `1`)
+ grass (id `2`)
+ stone (id `3`)
+ gravel (id `4`)
+ rock (id `5`)
+ farmland (id `6`)
+ mud (id `7`)
+ snow (id `8`)
+ sand (id `9`)
+ desertdirt (id `10`)
+ desertstone (id `11`)
+ clay (id `12`)
+ dungeonwall (id `13`)
+ dungeonfloor (id `14`)
+ bonewall (id `15`)
+ hellstone (id `16`)
+ iron (id `-101`)
+ copper (id `-102`)
+ aluminium (id `-103`)
+ silver (id `-104`)
+ gold (id `-105`)
+ tungsten (id `-106`)
+ cobalt (id `-107`)
+ mithril (id `-108`)
+ grass9 (id `-10`)
+ grass8 (id `-9`)
+ grass7 (id `-8`)
+ grass6 (id `-7`)
+ grass5 (id `-6`)
+ grass4 (id `-5`)
+ grass3 (id `-4`)
+ grass2 (id `-3`)
+ grass1 (id `-2`)


### Block Types

* `block` (aliases: `b`, `blk`)
* `cylinder` (aliases: `c`, `cyl`)
* `cylinderhalf` (aliases: `ch`, `cylh`)
* `stair` (aliases: `s`, `s1`, `stair1`)
* `stair2` (aliases: `s2`)
* `stair3` (aliases: `s3`)
* `staircorner` (aliases: `sc`, `stairc`)
* `stairinnercorner` (aliases: `sic`, `stairic`)
* `ramp` (aliases: `r`)
* `ramphalfcorner` (aliases: `rhc`, `ramphc`, `ramphalfc`)
* `rampinnercorner` (aliases: `ric`, `rampic`)
* `rampcorner` (aliases: `rc`, `rampc`)
* `halfblockbottom` (aliases: `hb`, `hb1`, `hbb`, `halfblk`, `halfblk1`, `halfblkb`, `halfblock`, `halfblock1` `halfblockb`)
* `halfblockcenter` (aliases: `hb2`, `hbc`, `halfblk2`, `halfblkc`, `halfblock2`, `halfblockc`)
* `halfblocktop` (aliases: `hb3`, `hbt`, `halfblk3`, `halfblkt`, `halfblock3`, `halfblockt`)
* `pyramid` (aliases: `p`, `pyr`)
* `arc` (aliases: `a`)


### Plants

+ scrub1 (id `1`)
+ mapletree1 (id `2`)
+ mapletree2 (id `3`)
+ mapletree3 (id `4`)
+ dead1 (id `5`)
+ pine1 (id `6`)
+ forestpine (id `7`)
+ flower1_s (id `8`)
+ flower1_m (id `9`)
+ flower1_l (id `10`)
+ fern1 (id `11`)
+ pumpkin1 (id `12`)
+ flower2_s (id `13`)
+ flower2_m (id `14`)
+ flower2_l (id `15`)
+ flower3_s (id `16`)
+ flower3_m (id `17`)
+ flower3_l (id `18`)
+ flower4_s (id `19`)
+ flower4_m (id `20`)
+ flower4_l (id `21`)
+ flower5_s (id `22`)
+ flower5_m (id `23`)
+ flower5_l (id `24`)
+ flower6_s (id `25`)
+ flower6_m (id `26`)
+ flower6_l (id `27`)
+ maplesapling_s0 (id `28`)
+ maplesapling_s1 (id `29`)
+ pinesapling_s0 (id `30`)
+ pinesapling_s1 (id `31`)
+ watermelon1 (id `32`)
+ watermelon2 (id `33`)
+ tomato_s0 (id `34`)
+ tomato_s1 (id `35`)
+ tomato_s2 (id `36`)
+ tomato_s3 (id `37`)
+ tomato (id `38`)
+ carrot_s0 (id `39`)
+ carrot_s1 (id `40`)
+ carrot (id `41`)


## Contributors

* LordFoobar (Yanick Rochon)
* Yahgiggle (Deon Hamilton)
* andyzee (Andy Zee)

### Translators

* NDMR (German)


## License

Copyright (c) 2015 Rising World Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
