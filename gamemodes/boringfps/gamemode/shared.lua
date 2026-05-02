GM.Name = "Boring FPS"
GM.Author = "MrMarrant"
GM.Email = "N/A"
GM.Website = "https://mrmarrant.fr"

DeriveGamemode("base")

-- Functions
BoringFPS = BoringFPS or {}
-- Global Variable
BoringFPS_CONFIG = BoringFPS_CONFIG or {}
-- Lang
BoringFPS_LANG = BoringFPS_LANG or {}
-- Actual lang server
BoringFPS_CONFIG.LangServer = GetConVar("gmod_language"):GetString()
cvars.AddChangeCallback("gmod_language", function(convar_name, value_old, value_new)
	BoringFPS_CONFIG.LangServer = value_new
end)
BoringFPS.Version = "v1.0.3"

local root = GM.FolderName
local prefixOrder = {
    sh = 1,
    sv = 2,
    cl = 3
}

local function SortFiles(a, b)
    local prefixA = string.sub(a, 1, 2)
    local prefixB = string.sub(b, 1, 2)

    local orderA = prefixOrder[prefixA] or 99
    local orderB = prefixOrder[prefixB] or 99

    if orderA ~= orderB then
        return orderA < orderB
    end

    return a < b
end

local function AddFile( File, directory )
	local prefix = string.lower( string.Left( File, 3 ) )

	if SERVER and prefix == "sv_" then
		include( directory .. File )
	elseif prefix == "sh_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
		end
		include( directory .. File )
	elseif prefix == "cl_" then
		if SERVER then
			AddCSLuaFile( directory .. File )
		elseif CLIENT then
			include( directory .. File )
		end
	end
end

local function LoadDirectory( directory )
	directory = directory .. "/"

	local files, directories = file.Find( directory .. "*", "LUA" )
	table.sort( files, SortFiles )

	for _, v in ipairs( files ) do
		if string.EndsWith( v, ".lua" ) then
			AddFile( v, directory )
		end
	end

	for _, v in ipairs( directories ) do
		LoadDirectory( directory .. v )
	end
end

print("Boring FPS Loading . . .")
	LoadDirectory( root .. "/gamemode/config" )
	LoadDirectory( root .. "/gamemode/language" )
	LoadDirectory( root .. "/gamemode/modules" )
print("Boring FPS Config Loaded !")

function GM:InitPostEntity()
	-- Do stuff
	hook.Call( "OnGameLoaded" )
end