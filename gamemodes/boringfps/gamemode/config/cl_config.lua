BoringFPS_CONFIG.Vars.ScrW = ScrW()
BoringFPS_CONFIG.Vars.ScrH = ScrH()

hook.Add( "OnScreenSizeChanged", "OnScreenSizeChanged.BoringFPS", function( oldWidth, oldHeight )
    BoringFPS_CONFIG.Vars.ScrW = ScrW()
    BoringFPS_CONFIG.Vars.ScrH = ScrH()
end )