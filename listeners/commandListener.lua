
include("command-parser/parse-args.lua");


local textureAliasMap = {
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
  hellstone = 16
};
local fillAvailableArgs = table.keys(textureAliasMap);
local clearAvailableArgs = {"obj","con","veg","all","abs"};

table.sort(fillAvailableArgs, function (a, b)
  return textureAliasMap[a] < textureAliasMap[b];
end);
table.insert(fillAvailableArgs, "#id");


local function weHelp(event, args)
  local helpContext = string.lower(args[1] or "");

  if helpContext == "select" then
    --print("Showing /we select help");
    event.player:sendTextMessage("[#33FF33]/we select");
    for k,line in pairs(string.wrap(i18n.t(event.player, "help.select.usage"), 80)) do
      event.player:sendTextMessage("[#FFFF00]"..line);
    end
  elseif helpContext == "cancel" then
    --print("Showing /we cancel help");
    event.player:sendTextMessage("[#33FF33]/we cancel");
    for k,line in pairs(string.wrap(i18n.t(event.player, "help.cancel.usage"), 80)) do
      event.player:sendTextMessage("[#FFFF00]"..line);
    end
  elseif helpContext == "clear" then
    --print("Showing /we clear help");
    event.player:sendTextMessage("[#33FF33]/we clear ["..table.concat(clearAvailableArgs, '|').."] [-p]");
    for k,line in pairs(string.wrap(i18n.t(event.player, "help.clear.usage"), 80)) do
      event.player:sendTextMessage("[#FFFF00]"..line);
    end
  elseif helpContext == "fill" then
    --print("Showing /we fill help");
    event.player:sendTextMessage("[#33FF33]/we fill <texture> [-p]");
    for k,line in pairs(string.wrap(i18n.t(event.player, "help.fill.usage", table.concat(fillAvailableArgs, ', ')), 80)) do
      event.player:sendTextMessage("[#FFFF00]"..line);
    end
  elseif helpContext == "place" then
    --print("Showing /we place help");
    event.player:sendTextMessage("[#33FF33]/we place <blocktype> <id> [north|east|south|west] [sideway|flipped] [-p]");
    for k,line in pairs(string.wrap(i18n.t(event.player, "help.place.usage", "blocktype", table.concat(getBlockTypes(), ', ')), 80)) do
      event.player:sendTextMessage("[#FFFF00]"..line);
    end
  else
    event.player:sendTextMessage("[#33FF33]/we <help|select|cancel|clear|fill|place> [args]");
    for k,line in pairs(string.wrap(i18n.t(event.player, "help.usage", "/we help fill"), 80)) do
      event.player:sendTextMessage("[#FFFF00]"..line);
    end
  end
end



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
      local coords = getCoordsFromMarkEvent(markingEvent);

      if clearObjType == "obj" then
        --print("Clearing area of objects");
        removeObjects(coords);
      elseif clearObjType == "con" then
        --print("Clearing area of construction");
        removeConstr(coords);
      elseif clearObjType == "veg" then
        --print("Clearing area of vegetation");
        removeVeg(coords);
      elseif clearObjType == "all" then
        --print("Clearing area of all");
        removeAll(coords, false);
      elseif clearObjType == "abs" then
        --print("Clearing area of absolutely everything");
        removeAll(coords, true);
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
  local blockId = args[2] and getBlockId(tonumber(args[2]), blockType, direction, orientation);

  if blockType and blockId then

    if blockId < 21 then
      --print("Block id adjusted from "..blockId.." to 21");
      blockId = 21;
    end;

    event.player:getMarkingSelectorStatus(function(markingEvent)
      if markingEvent ~= false then
        local coords = getCoordsFromMarkEvent(markingEvent);

        --print("Placing "..blockType.." in area with id "..blockId..(cleanup ~= nil and " with cleanup" or ""));
        fillWithBlock(coords, blockId);

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


local function weFill(event, args, flags)
  local cleanup = flags["c"] or flags["clean"];
  local id = tonumber(args[1]) or textureAliasMap[string.lower(args[1] or "")];

  if id then

    if id < 0 or id > 16 then
      --print("Terrain id adjusted from "..id.." to 0");
      id = 0;
    end;

    event.player:getMarkingSelectorStatus(function(markingEvent)
      if markingEvent ~= false then
        local coords = getCoordsFromMarkEvent(markingEvent);

        --print("Filling area with id "..id..(cleanup ~= nil and " with cleanup" or ""));
        fillWith(coords, id, cleanup);

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
    event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.use.args", table.concat(fillAvailableArgs, ", ")));
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
      else
        event.player:sendTextMessage("[#FF0000]"..i18n.t(event.player, "cmd.unknown"));
      end
    end
  end
end
addEvent("PlayerCommand", onPlayerCommand);
