AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

hook.Add("OnGameLoaded", "BoringFPS:OnGameLoaded", function()
    BoringFPS.NewGame()
end)