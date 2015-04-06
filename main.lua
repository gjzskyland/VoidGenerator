local verbose = true

local ConfigIni = cIniFile()
local VoidWorlds = {}

local Name = "VoidGenerator"
local VersionMajor = 1
local VersionMinor = 0
local PluginFolder = ""

function Initialize(Plugin)
	Plugin:SetName(Name)
	Plugin:SetVersion(VersionMajor)
	PluginFolder = Plugin:GetLocalFolder()

	-- Hooks here you scrub...
	
	cPluginManager:AddHook(cPluginManager.HOOK_CHUNK_GENERATING, OnChunkGenerating)

	LoadWorlds()

	LOG("Initialized " .. Plugin:GetName() .. " v" .. VersionMajor .. "." .. VersionMinor)
	return true
end

function OnChunkGenerating(World, ChunkX, ChunkZ, ChunkDesc)
	for c = 1, #VoidWorlds do
		if World:GetName() == VoidWorlds[c] then
			ChunkDesc:UpdateHeightmap()
			ChunkDesc:SetUseDefaultBiomes(false)
			ChunkDesc:SetUseDefaultComposition(false)
			ChunkDesc:SetUseDefaultFinish(false)
			ChunkDesc:FillBlocks(E_BLOCK_AIR, 0)
			if verbose == true then LOG("Filling chunk " .. ChunkX .. ", " .. ChunkZ .. " in world '" .. World:GetName() .. "'") end
			return true
		end
	end
	return false
end

function LoadWorlds()
	if ConfigIni:ReadFile(PluginFolder .. "/worlds.ini") == false then
		ConfigIni:AddKeyName("Worlds")
		ConfigIni:WriteFile(PluginFolder .. "/worlds.ini")
	end

	for c = 1, ConfigIni:GetNumValues("Worlds") do
		local WorldName = ConfigIni:GetValue("Worlds", "world" .. tostring(c))
		table.insert(VoidWorlds, WorldName)
	end
end
