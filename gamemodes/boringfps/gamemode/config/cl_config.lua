BoringFPS_CONFIG.Vars.ScrW = ScrW()
BoringFPS_CONFIG.Vars.ScrH = ScrH()

surface.CreateFont( "HudBoringFPS", {
    font = "Anton",
    size = 40
} )

surface.CreateFont( "HudTimerLeft", {
    font = "Anton",
    size = 80
} )

hook.Add( "OnScreenSizeChanged", "OnScreenSizeChanged.BoringFPS", function( oldWidth, oldHeight )
    BoringFPS_CONFIG.Vars.ScrW = ScrW()
    BoringFPS_CONFIG.Vars.ScrH = ScrH()
end )