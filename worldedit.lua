---
--- World Edit script
---
VERSION = "v0.5.71";


-- load dependencies
include("i18n/i18n.lua");
include("security.lua");
include("table-ext/table-ext.lua");
include("string-ext/string-ext.lua");
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


local function fillTerrainGlobal(s, e, terrainId)
	local startChunkPos = Vector:createVector3f(0.0, 0.0, 0.0);
	local startBlockPos = Vector:createVector3f(0.0, 0.0, 0.0);
	local endChunkPos = Vector:createVector3f(0.0, 0.0, 0.0);
	local endBlockPos = Vector:createVector3f(0.0, 0.0, 0.0);

	-- convert into chunk + block positions
	ChunkUtils:getChunkAndBlockPosition(s, startChunkPos, startBlockPos);
	ChunkUtils:getChunkAndBlockPosition(e, endChunkPos, endBlockPos);

	world:setTerrainDataInArea(
		startChunkPos.x, startChunkPos.y, startChunkPos.z,
		startBlockPos.x, startBlockPos.y, startBlockPos.z,

		endChunkPos.x, endChunkPos.y, endChunkPos.z,
		endBlockPos.x, endBlockPos.y, endBlockPos.z,

		terrainId
	);
end


function getWorldData(globalPosition)
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


function fillBlock(e, blockID)
	world:setBlockDataInArea(
		e.startChunkpositionX, e.startChunkpositionY, e.startChunkpositionZ,
		e.startBlockpositionX, e.startBlockpositionY, e.startBlockpositionZ,

		e.endChunkpositionX, e.endChunkpositionY, e.endChunkpositionZ,
		e.endBlockpositionX, e.endBlockpositionY, e.endBlockpositionZ,

		blockID
	);
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
