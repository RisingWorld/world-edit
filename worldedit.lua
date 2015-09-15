---
--- World Edit script
---
VERSION = "v0.5.85";


-- load dependencies
include("i18n/i18n.lua");
include("security.lua");
include("lua-ext/table-ext.lua");
include("lua-ext/string-ext.lua");
include("blocks.lua");
include("listeners/playerListener.lua");
include("listeners/commandListener.lua");


local world = getWorld();


function onEnable()
	local config = getProperty("config.properties");

	i18n.init(config);

	-- The console already prepend the script name on every log output
  print("Script "..VERSION.." loaded.");
end


---
-- Find nearest floor terrain for the given global position as a Vector3f
-- NOTE : 512 blocks high restricted when searching
-- @param x number
-- @param y number
-- @param z number
-- @return terrainGlobalPosition Vector3f, terrainId number
--
function findNearestTerrainFloor(x, y, z)
	local chunkPos = Vector:createVector3i(0, 0, 0);
	local blockPos = Vector:createVector3i(0, 0, 0);
	local pos = Vector:createVector3f(x, y, z);
	local increment = 5;
	local precision = 0.05;
	local maxHeight = 512;
	local terrainId;

	local moveUp = function ()
		while terrainId ~= 0 and pos.y > y - maxHeight do
			pos.y = pos.y + increment;
			ChunkUtils:getChunkAndBlockPosition(pos, chunkPos, blockPos);
			terrainId = world:getTerrainData(chunkPos.x, chunkPos.y, chunkPos.z, blockPos.x - 2, blockPos.y - 2, blockPos.z - 2);
		end
	end
	local moveDown = function ()
		while terrainId == 0 and pos.y < y + maxHeight do
			pos.y = pos.y - increment;
			ChunkUtils:getChunkAndBlockPosition(pos, chunkPos, blockPos);
			terrainId = world:getTerrainData(chunkPos.x, chunkPos.y, chunkPos.z, blockPos.x - 2, blockPos.y - 2, blockPos.z - 2);
		end
	end

	ChunkUtils:getChunkAndBlockPosition(pos, chunkPos, blockPos);
	terrainId = world:getTerrainData(chunkPos.x, chunkPos.y, chunkPos.z, blockPos.x - 2, blockPos.y - 2, blockPos.z - 2);

	while (terrainId == 0 or increment > precision) and pos.y < y + maxHeight and pos.y > y - maxHeight do
		if terrainId == 0 then
			moveDown();
		else
			moveUp();
		end

		increment = increment / 2;
	end

	return pos, terrainId;
end


-- NOTE: NOT USED.... YET!
-- also, this implementation is crap
local function findTerrainData(globalPosition)
	local chunkPos = Vector:createVector3i(0, 0, 0);
	local blockPos = Vector:createVector3i(0, 0, 0);
	local terrainId = 0;

	while terrainId == 0 do
		ChunkUtils:getChunkAndBlockPosition(globalPosition, chunkPos, blockPos);

		terrainId = world:getTerrainData(chunkPos.x, chunkPos.y, chunkPos.z, blockPos.x, blockPos.y, blockPos.z);

		if terrainId == 0 then
			globalPosition.y = globalPosition.y - 1;
		end
	end

	return terrainId;
end

-- NOTE: NOT USED.... YET!
local function getWorldData(globalPosition)
	local chunkPos = Vector:createVector3i(0, 0, 0);
	local blockPos = Vector:createVector3i(0, 0, 0);

	ChunkUtils:getChunkAndBlockPosition(globalPosition, chunkPos, blockPos);

	return {
		terrainId = world:getTerrainData(chunkPos.x, chunkPos.y, chunkPos.z, blockPos.x, blockPos.y, blockPos.z),
		block = getBlockTypeAndId(world:getBlockData(chunkPos.x, chunkPos.y, chunkPos.z, blockPos.x, blockPos.y, blockPos.z))
	};
end


function fillTerrain(e, terrainId)
	world:setTerrainDataInArea(
		e.startChunkpositionX, e.startChunkpositionY, e.startChunkpositionZ,
		e.startBlockpositionX, e.startBlockpositionY, e.startBlockpositionZ,

		e.endChunkpositionX, e.endChunkpositionY, e.endChunkpositionZ,
		e.endBlockpositionX, e.endBlockpositionY, e.endBlockpositionZ,

		terrainId
	);
end

function fillTerrainGlobal(s, e, terrainId)
	local startChunkPos = Vector:createVector3i(0, 0, 0);
	local startBlockPos = Vector:createVector3i(0, 0, 0);
	local endChunkPos = Vector:createVector3i(0, 0, 0);
	local endBlockPos = Vector:createVector3i(0, 0, 0);

	-- convert into chunk + block positions
	ChunkUtils:getChunkAndBlockPosition(s, startChunkPos, startBlockPos);
	ChunkUtils:getChunkAndBlockPosition(e, endChunkPos, endBlockPos);

	world:setTerrainDataInArea(
		startChunkPos.x, startChunkPos.y, startChunkPos.z,
		startBlockPos.x - 2, startBlockPos.y - 2, startBlockPos.z - 2,

		endChunkPos.x, endChunkPos.y, endChunkPos.z,
		endBlockPos.x - 2, endBlockPos.y - 2, endBlockPos.z - 2,

		terrainId
	);
end

function fillTerrainRadiusGlobal(s, radius, terrainId)
	local chunkPos = Vector:createVector3i(0, 0, 0);
	local blockPos = Vector:createVector3i(0, 0, 0);

	ChunkUtils:getChunkAndBlockPosition(s, chunkPos, blockPos);

	world:setTerrainDataInRadius(chunkPos.x, chunkPos.y, chunkPos.z, blockPos.x - 2, blockPos.y - 2, blockPos.z - 2, radius, terrainId);
end


function fillBlock(e, blockID)
	world:setBlockDataInArea(
		e.startChunkpositionX, e.startChunkpositionY, e.startChunkpositionZ,
		e.startBlockpositionX, e.startBlockpositionY, e.startBlockpositionZ,

		e.endChunkpositionX, e.endChunkpositionY, e.endChunkpositionZ,
		e.endBlockpositionX, e.endBlockpositionY, e.endBlockpositionZ,

		blockID
	);
end


function placeVegetation(x, y, z, a, id)
	world:placeVegetation(x, y, z, a or math.random(0,360), id or 1);
end


function removeObjects(e)
	world:removeAllObjectsInArea(
		e.startChunkpositionX, e.startChunkpositionY, e.startChunkpositionZ,
		e.startBlockpositionX, e.startBlockpositionY, e.startBlockpositionZ,

		e.endChunkpositionX, e.endChunkpositionY, e.endChunkpositionZ,
		e.endBlockpositionX, e.endBlockpositionY, e.endBlockpositionZ
	);
end


function removeConstr(e)
	world:removeAllConstructionsInArea(
		e.startChunkpositionX, e.startChunkpositionY, e.startChunkpositionZ,
		e.startBlockpositionX, e.startBlockpositionY, e.startBlockpositionZ,

		e.endChunkpositionX, e.endChunkpositionY, e.endChunkpositionZ,
		e.endBlockpositionX, e.endBlockpositionY, e.endBlockpositionZ
	);
end


function removeVeg(e)
	world:removeAllVegetationsInArea(
		e.startChunkpositionX, e.startChunkpositionY, e.startChunkpositionZ,
		e.startBlockpositionX, e.startBlockpositionY, e.startBlockpositionZ,

		e.endChunkpositionX, e.endChunkpositionY, e.endChunkpositionZ,
		e.endBlockpositionX, e.endBlockpositionY, e.endBlockpositionZ
	);
end


function removeAll(e, clearAll)
	removeObjects(e);
	removeConstr(e);
	removeVeg(e);
	fillBlock(e, 0);

	if clearAll then
		fillTerrain(e, 0);
	end
end
