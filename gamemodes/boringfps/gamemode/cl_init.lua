include( "shared.lua" )

hook.Add("OnGameLoaded", "BoringFPS:OnGameLoadedClient", function()
    BoringFPS.FetchData(BoringFPS_CONFIG.Links.PatchNote, function(success, data, code)
        BoringFPS_CONFIG.Vars.LastPatch = success and data or "ERROR FETCHING PATCH NOTE"
    end)
end)