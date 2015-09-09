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
   ./string-ext
      ./string-ext.lua
   ./table-ext
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
  * air (id `0`)
  * dirt (id `1`)
  * grass (id `2`)
  * stone (id `3`)
  * gravel (id `4`)
  * rock (id `5`)
  * farmland (id `6`)
  * mud (id `7`)
  * snow (id `8`)
  * sand (id `9`)
  * desertdirt (id `10`)
  * desertstone (id `11`)
  * clay (id `12`)
  * dungeonwall (id `13`)
  * dungeonfloor (id `14`)
  * bonewall (id `15`)
  * hellstone (id `16`)    
  Ex: `/we fill -c grass`

* `clear [obj|con|veg|all|abs]` : clear the selected area of (obj)ects, (con)structions, (veg)etations, (all), or (abs)olutely everything. (Default `all`)  
  Ex: `/we clear veg`

* `place <blockType> id [north|east|south|west [sideway|flipped]]` : place a block with the given `id`, optionally facing the given direction and put `sideway` or `flipped`.  
  Ex: `/we place ramp 121 east flipped`


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