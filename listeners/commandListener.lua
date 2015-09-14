
include("command-parser/parse-args.lua");

-- set maximum number of plants to be planted at once
local MAX_PLANTS_COUNT = 500;

-- set maximum distance plants can be planted from character
local MAX_PLANTS_DISTANCE = 64;


local textureAliasMap = {
  grass9 = -10,
  grass8 = -9,
  grass7 = -8,
  grass6 = -7,
  grass5 = -6,
  grass4 = -5,
  grass3 = -4,
  grass2 = -3,
  grass1 = -2,

  air = 0,
  dirt = 1,
  grass = 2,
  stone = 3,
  gravel = 4,
  rock = 5,
  farmland = 6,
  mud = 7,
  snow = 8,
  sand = 9,
  desertdirt = 10,
  desertstone = 11,
  clay = 12,
  dungeonwall = 13,
  dungeonfloor = 14,
  bonewall = 15,
  hellstone = 16,
  iron = -101,
  copper = -102,
  aluminium = -103,
  silver = -104,
  gold = -105,
  tungsten = -106,
  cobalt = -107,
  mithril = -108
};
local fillAvailableArgs = table.keys(textureAliasMap);
local clearAvailableArgs = {"obj","con","veg","block","all","abs"};

table.sort(fillAvailableArgs, function (a, b)
  return textureAliasMap[a] < textureAliasMap[b];
end);
table.insert(fillAvailableArgs, "#id");


local function setLabel(event, text)
  local label = event.player:getAttribute("weStateLabel");

  if text then
    label:setText(text);
    label:setVisible(true);
  else
    label:setText("");
    label:setVisible(false);
  end
end


local function weAbout(event)
  event.player:sendTextMessage("[#FFFF00]World-Edit "..VERSION);
end


local function weHelp(event, args)
  local helpContext = string.lower(args[1] or "");

  if helpContext == "select" then
    --print("Showing /we select help");
    event.player:sendTextMessage("[#33FF33]/we select");
    event.player:sendTextMessage("[#FFFF00]"..i18n.t(event.player, "help.select.usage"));
  elseif helpContext == "cancel" then
    --print("Showing /we cancel help");
    event.player:sendTextMessage("[#33FF33]/we cancel");
    event.player:sendTextMessage("[#FFFF00]"..i18n.t(event.player, "help.cancel.usage"));
  elseif helpContext == "clear" then
    --print("Showing /we clear help");
    event.player:sendTextMessage("[#33FF33]/we clear ["..table.concat(clearAvailableArgs, '|').."] [-p]");
    event.player:sendTextMessage("[#FFFF00]"..i18n.t(event.player, "help.clear.usage"));
  elseif helpContext == "fill" then
    --print("Showing /we fill help");
    event.player:sendTextMessage("[#33FF33]/we fill <texture> [-p]");
    event.player:sendTextMessage("[#33FF33]"..i18n.t(event.player, "help.fill.usage", table.concat(fillAvailableArgs, ', ')));
  elseif helpContext == "place" then
    --print("Showing /we place help");
    event.player:sendTextMessage("[#33FF33]/we place <blocktype> <id> [north|east|south|west] [sideway|flipped] [-p]");
    event.player:sendTextMessage("[#33FF33]"..i18n.t(event.player, "help.place.usage", "blocktype", table.concat(getBlockTypes(), ', ')));
  elseif helpContext == "plant" then
    --print("Showing /we place help");
    event.player:sendTextMessage("[#33FF33]/we plant <areatype> <ids>");
    event.player:sendTextMessage("[#FFFF00]"..i18n.t(event.player, "help.plant.usage"));
    event.player:sendTextMessage("[#FFFF00]"..i18n.t(event.player, "help.plant.example"));
  elseif helpContext == "about" then
    weAbout(event);
  else
    event.player:sendTextMessage("[#33FF33]/we <help|about|select|cancel|clear|fill|place/plant> [args]");
    event.player:sendTextMessage("[#FFFF00]"..i18n.t(event.player, "help.usage", "/we help fill"));
  end
end


local function weSelect(event)
  event.player:enableMarkingSelector(function()
    --print("Area selection start");
    setLabel(event, i18n.t(event.player, "select.start"));
  end);
end


local function weCancel(event)
  event.player:disableMarkingSelector(function(markingEvent)
    setLabel(event);

    if markingEvent ~= false then
      --print("Area selection cancelled");
      event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "select.cancelled"));
    end
  end);
end


local function weClear(event, args, flags)
  local clearObjType = string.lower(args[1] or "all");

  event.player:getMarkingSelectorStatus(function(markingEvent)
    if markingEvent ~= false then
      if clearObjType == "obj" then
        --print("Clearing area of objects");
        removeObjects(markingEvent);
      elseif clearObjType == "con" then
        --print("Clearing area of construction");
        removeConstr(markingEvent);
      elseif clearObjType == "veg" then
        --print("Clearing area of vegetation");
        removeVeg(markingEvent);
      elseif clearObjType == "block" then
        --print("Clearing area of Blocks");
        fillBlock(markingEvent, 0);
      elseif clearObjType == "all" then
        --print("Clearing area of all");
        removeAll(markingEvent, false);
      elseif clearObjType == "abs" then
        --print("Clearing area of absolutely everything");
        removeAll(markingEvent, true);
      else
        return event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.use.args", table.concat(clearAvailableArgs, ", ")));
      end

      if not flags["p"] then
        event.player:disableMarkingSelector(function()
          setLabel(event);
        end);
      end
    else
      event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.no.selection"));
    end
  end);

end


local function wePlaceBlock(event, args, flags)
  local blockType = args[1] and string.lower(args[1]);
  local direction = args[3] and string.lower(args[3]) or "north";
  local orientation = args[4] and string.lower(args[4]) or "";
  local blockId = args[2] and getBlockId(tonumber(args[2]) or 0, blockType, direction, orientation);

  if blockType and blockId then

    if blockId < 21 and blockId ~= 0 then
      --print("Block id adjusted from "..blockId.." to 21");
      blockId = 21;
    end;

    event.player:getMarkingSelectorStatus(function(markingEvent)
      if markingEvent ~= false then
        --print("Placing "..blockType.." in area with id "..blockId..(cleanup ~= nil and " with cleanup" or ""));
        fillBlock(markingEvent, blockId);

        if not flags["p"] then
          event.player:disableMarkingSelector(function()
            setLabel(event);
          end);
        end
      else
        event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.no.selection"));
      end
    end);
  elseif blockType == nil then
    event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.missing.arg", "type"));
  elseif blockId == nil then
    event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.missing.arg", "id"));
  end
end


local function wePlant(event, args, flags)
  local precision = 10000;
  local ids = {};
  local total;
  local count;
  local originPos = event.player:getPosition();
  local getPosition;
  local plantAngle;
  local id, pos;

  local function _scanIds(argIndex)
    -- build ids table of all the possible ids to use
    for i = argIndex, #args do
      local id = args[i];

      -- TODO : check for alias range

      local a, b = string.match(id, "(%d+)..(%d+)");

      if a and b then
        a = math.max(tonumber(a) or 1, 1);
        b = math.min(tonumber(b) or 1, 41);

        for i = a, b do
          table.insert(ids, i);
        end
      else
        id = tonumber(id);

        if id == nil then
          return event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.invalid.arg", "range"));
        end

        table.insert(ids, math.max(math.min(id, 41), 1));
      end
    end
  end

  local function _count(argIndex, total)
    local count, percent = string.match(args[argIndex], "(%d+)(%%?)");

    if count == nil then
      return nil;
    elseif percent == "%" then
      count = (count / 100) * total;
    end

    return math.min(math.ceil(count), MAX_PLANTS_COUNT);
  end


  if args[1] == "single" then
    count = 1;
    getPosition = function ()
      local localPos = originPos:add(event.player:getViewDirection():setY(0):mult(1.5));
      return localPos.x, localPos.y - 2, localPos.z;
    end;

    _scanIds(2);
  elseif args[1] == "line" or args[1] == "freeline" then
    local distance = math.min(tonumber(args[2]) or 1, MAX_PLANTS_DISTANCE);
    local direction = event.player:getViewDirection():clone():setY(0);

    count = _count(3, distance);

    if flags["e"] then
      local increment = distance / count;
      local step = increment / 2;

      --print("COUNT / DISTANCE = INCREMENT = ".. count .. " / " .. distance .. " = " .. increment);
      getPosition = function ()
        local localPos = originPos:add(direction:mult(step));

        step = step + increment;

        return localPos.x, localPos.y - 2, localPos.z;
      end;
    else
      getPosition = function ()
        local localPos = originPos:add(direction:mult(math.random(1, distance * precision) / precision));
        return localPos.x, localPos.y - 2, localPos.z;
      end;
    end

    -- lock direction to nearest axis
    if args[1] == "line" then
      direction.x =  direction.x >= 0 and math.floor(direction.x + 0.5) or math.ceil(direction.x - 0.5);
      direction.z =  direction.z >= 0 and math.floor(direction.z + 0.5) or math.ceil(direction.z - 0.5);
    end

    print("Direction vector");
    print(direction);

    _scanIds(4);
  elseif args[1] == "rect" then
    local sizeZ = math.min(tonumber(args[2]) or 1, MAX_PLANTS_DISTANCE);  -- north south
    local sizeX = math.min(tonumber(args[3]) or 1, MAX_PLANTS_DISTANCE);  -- east west

    if flags["b"] then
      count = _count(4, (sizeX * 2) + (sizeZ * 2));
      getPosition = function ()
        local x;
        local y = originPos.y - 2;
        local z;
        local s = math.random(0, 19) % 4;

        if s == 0 or s == 2 then
          x = originPos.x + math.random(-math.floor(sizeX / 2) * precision, math.ceil(sizeX / 2) * precision) / precision;
          if s == 0 then
            z = originPos.z - sizeZ;
          else
            z = originPos.z + sizeZ;
          end
        else
          if s == 1 then
            x = originPos.x - sizeX;
          else
            x = originPos.x + sizeX;
          end
          z = originPos.z + math.random(-math.floor(sizeZ / 2) * precision, math.ceil(sizeZ / 2) * precision) / precision;
        end

        return x, y, z;
      end;
    else
      count = _count(4, sizeX * sizeZ);
      getPosition = function ()
        local x = originPos.x + math.random(-math.floor(sizeX / 2) * precision, math.ceil(sizeX / 2) * precision) / precision;
        local y = originPos.y - 2;
        local z = originPos.z + math.random(-math.floor(sizeZ / 2) * precision, math.ceil(sizeZ / 2) * precision) / precision;

        return x, y, z;
      end;
    end
    _scanIds(5);
  elseif args[1] == "circle" then
    local radius = math.min((tonumber(args[2]) or 1) / 2, MAX_PLANTS_DISTANCE);

    if flags["b"] then
      count = _count(3, math.pi * radius * 2);
      getPosition = function ()
        local angle = (math.random(0, 359 * precision) / precision) * math.pi / 180;
        local x = originPos.x + (radius * math.cos(angle));
        local y = originPos.y - 2;
        local z = originPos.z + (radius * math.sin(angle));

        return x, y, z;
      end;
    else
      count = _count(3, math.pi * radius * radius);
      getPosition = function ()
        local angle = (math.random(0, 359 * precision) / precision) * math.pi / 180;
        local x = originPos.x + ((math.random(0, radius * precision) / precision) * math.cos(angle));
        local y = originPos.y - 2;
        local z = originPos.z + ((math.random(0, radius * precision) / precision) * math.sin(angle));

        return x, y, z;
      end;
    end

    _scanIds(4);
  else
    return event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.invalid.arg", "areatype"));
  end

  if #ids == 0 then
    return event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.missing.arg", "plants"));
  elseif count == nil then
    return event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.invalid.arg", "count"));
  end

  for i = 1, count do
    id = ids[math.random(1, #ids)];
    plantAngle = math.random(0, 359 * precision) / precision;
    pos = findNearestTerrainFloor(getPosition());

    --print("Planting #" .. i .. " / " .. count .. ": " .. id .. " @ " .. pos.x .. "," .. pos.y .. "," .. pos.z .. " : " .. plantAngle);

    placeVegetation(pos.x, pos.y - (0.2 + (math.random(0, 20) / 100)), pos.z, plantAngle, id);
  end

end



local function weFill(event, args, flags)
  local cleanup = flags["c"] or flags["clean"];
  local id = tonumber(args[1]) or textureAliasMap[string.lower(args[1] or "")];

  if id then

    if not table.contains(textureAliasMap, id) then
      --print("Terrain id adjusted from "..id.." to "..textureAliasMap["air"]);
      id = textureAliasMap["air"];
    end;

    event.player:getMarkingSelectorStatus(function(markingEvent)
      if markingEvent ~= false then
        --print("Filling area with id "..id..(cleanup ~= nil and " with cleanup" or ""));
        if cleanup then
          removeAll(markingEvent);
        end

        fillTerrain(markingEvent, id);

        if not flags["p"] then
          event.player:disableMarkingSelector(function()
            setLabel(event);
          end);
        end
      else
        event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.no.selection"));
      end
    end);
  else
    event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.use.args", table.concat(fillAvailableArgs, ', ')));
  end
end


local function onPlayerCommand(event)
  local args, flags = parseArgs(event.command);
  local cmd;

  if #args >= 1 then

    if string.lower(args[1]) == "/we" then
      -- command handled
      event:setCancel(true);

      cmd = string.lower(args[2] or "");

      if cmd == "help" then
        if checkPlayerAccess(event.player, "help") then weHelp(event, table.slice(args, 3)); end;
      elseif cmd == "select" then
        if checkPlayerAccess(event.player, "select") then weSelect(event); end;
      elseif cmd == "cancel" then
        weCancel(event); -- no player access necessary...
      elseif cmd == "clear" then
        if checkPlayerAccess(event.player, "clear") then weClear(event, table.slice(args, 3), flags); end;
      elseif cmd == "fill" then
        if checkPlayerAccess(event.player, "fill") then weFill(event, table.slice(args, 3), flags); end;
      elseif cmd == "place" then
        if checkPlayerAccess(event.player, "place") then wePlaceBlock(event, table.slice(args, 3), flags); end;
      elseif cmd == "plant" then
        if checkPlayerAccess(event.player, "plant") then wePlant(event, table.slice(args, 3), flags); end;
      elseif cmd == "about" then
        if checkPlayerAccess(event.player, "about") then weAbout(event); end;
      else
        event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.unknown"));
      end
    end
  end
end
addEvent("PlayerCommand", onPlayerCommand);
