
--- Thank you yahgiggle !!
--- https://forum.rising-world.net/index.php/Thread/1210-SCRIPT-World-Edit/?postID=12454#post12454
local blockDef = {
  block = { north = 0, east = 0,  south = 0, west = 0 },

  cylinder = { north = 3, east = 3,  south = 3, west = 3 },
  cylindersideway = { north = 204, east = 207,  south = 204, west = 207 },

  cylinderhalf = { north = 6, east = 9,  south = 12, west = 15 },

  stair = {  north = 39, east = 42,  south = 45, west = 48 },
  stairsideway = { north = 273, east = 276,  south = 279, west = 282 },
  stairflipped = { north = 285, east = 288,  south = 291, west = 294 },

  stair2 = { north = 51, east = 54,  south = 57, west = 60 },

  stair3 = { north = 63, east = 66,  south = 69, west = 72 },

  staircorner = { north = 75, east = 78,  south = 81, west = 84 },
  staircornerflipped = { north = 297, east = 300,  south = 303, west = 306 },

  stairinnercorner = { north = 87, east = 90,  south = 93, west = 96 },
  stairinnercornerflipped = { north = 309, east = 312,  south = 315, west = 318 },

  ramp = { north = 99, east = 102,  south = 105, west = 108 },
  rampsideway = { north = 225, east = 228,  south = 231, west = 234 },
  rampflipped = { north = 111, east = 114,  south = 117, west = 120 },

  ramphalfcorner = { north = 123, east = 126,  south = 129, west = 132 },
  ramphalfcornerflipped = { north = 147, east = 150,  south = 153, west = 156 },

  rampinnercorner = { north = 135, east = 138,  south = 141, west = 144 },
  rampinnercornerflipped = { north = 159, east = 162,  south = 165, west = 168 },

  rampcorner = { north = 171, east = 174,  south = 177, west = 180 },
  rampcornerflipped = { north = 183, east = 186,  south = 189, west = 192 },

  halfblockbottom = { north = 195, east = 195,  south = 195, west = 195 },
  halfblockcenter = { north = 198, east = 198,  south = 198, west = 198 },
  halfblocktop = { north = 201, east = 201,  south = 201, west = 201 },

  pyramid = { north = 219, east = 219,  south = 219, west = 219 },
  pyramidflipped = { north = 222, east = 222,  south = 222, west = 222 },

  arc = { north = 237, east = 240,  south = 243, west = 246 },
  arcflipped = { north = 249, east = 252,  south = 255, west = 258 },
  arcsideway = { north = 261, east = 264,  south = 267, west = 270 }
};
local directionOrder = { "north", "east", "south", "west" };
local UNKNOWN_BLOCK_ID = 99999999;

--- Add any alias blocks may have to the blockDef table
local blockAliasMap = {
  b = "block",
  blk = "block",

  c = "cylinder",
  cyl = "cylinder",

  ch = "cylinderhalf",
  cylh = "cylinderhalf",

  s = "stair",
  s1 = "stair",
  stair1 = "stair",

  s2 = "stair2",

  s3 = "stair3",

  sc = "staircorner",
  stairc = "staircorner",

  sic = "stairinnercorner",
  stairic = "stairinnercorner",

  r = "ramp",

  rhc = "ramphalfcorner",
  ramphc = "ramphalfcorner",
  ramphalfc = "ramphalfcorner",

  ric = "rampinnercorner",
  rampic = "rampinnercorner",

  rc = "rampcorner",
  rampc = "rampcorner",

  hb = "halfblockbottom",
  hbb = "halfblockbottom",
  hb1 = "halfblockbottom",
  halfblk = "halfblockbottom",
  halfblkb = "halfblockbottom",
  halfblk1 = "halfblockbottom",
  halfblock = "halfblockbottom",
  halfblockb = "halfblockbottom",
  halfblock1 = "halfblockbottom",
  hbc = "halfblockcenter",
  hb2 = "halfblockcenter",
  halfblkc = "halfblockcenter",
  halfblockc = "halfblockcenter",
  halfblock2 = "halfblockcenter",
  hbt = "halfblocktop",
  hb3 = "halfblocktop",
  halfblkt = "halfblocktop",
  halfblockt = "halfblocktop",
  halfblock3 = "halfblocktop",

  p = "pyramid",
  pyr = "pyramid",

  a = "arc"
};


--- Return the absolute block id for the given variation, type, orientation and direction
-- @param id the variation texture id of the block
-- @param blockType a block type as string (see aliasses)
-- @param direction may be "north", "south", "east", or "west"
-- @param orientation may be "", "sideway" or "flipped"
-- @return a numeric id
function getBlockId(id, blockType, direction, orientation)
  local idDef;

  if id == nil then
    return nil;
  end;

  blockType = blockType and blockAliasMap[blockType] or blockType;
  direction = direction and direction or "north";
  orientation = orientation and orientation or "";

  idDef = blockDef[blockType..orientation] or blockDef[blockType];

  if idDef and idDef[direction] then
    id = (idDef[direction] * 100) + id;
  end

  return id;
end


--- Return all valid block types
-- @return table
function getBlockTypes()
  local types = {};
  for key,val in pairs(blockDef) do
    if string.sub(key, -7) ~= "flipped" and string.sub(key, -7) ~= "sideway" then
      table.insert(types, key);
    end
  end

  table.sort(types);

  return types;
end


--- Reverse function to return the block id, type, and orientation from
--- an absolute block id
-- @param absId the absolute block id
-- @return table
function getBlockTypeAndId(absId)
  local id = UNKNOWN_BLOCK_ID;
  local blockType = "block";
  local direction = "north";
  local orientation = nil;

  for type,def in pairs(blockDef) do
    for k,dir in next, directionOrder do
      local baseId = def[dir];

      if absId > (baseId*100) and id > math.abs(absId - (baseId*100)) then
        id = absId - (baseId * 100);
        direction = dir;

        if string.sub(type, -7) == "flipped" or string.sub(type, -7) == "sideway" then
          blockType = string.sub(type, 0, -8);
          orientation = string.sub(type, -7);
        else
          blockType = type;
          orientation = nil;
        end
      end
    end
  end

  if id == UNKNOWN_BLOCK_ID then
    id = absId;
  end

  return {
    absId = absId,
    id = id,
    type = blockType,
    direction = direction,
    orientation = orientation
  };
end
