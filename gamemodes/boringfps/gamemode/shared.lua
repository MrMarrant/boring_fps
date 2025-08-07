GM.Name = "Boring FPS"
GM.Author = "MrMarrant"
GM.Email = "N/A"
GM.Website = "https://mrmarrant.fr"

-- Functions
BoringFPS = BoringFPS or {}
-- Global Variable
BoringFPS_CONFIG = BoringFPS_CONFIG or {}
-- Lang
BoringFPS_LANG = BoringFPS_LANG or {}
-- Actual lang server
SCP_1025_CONFIG.LangServer = GetConVar("gmod_language"):GetString()

local root = GM.FolderName

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
	BoringFPS.NewGame()
end