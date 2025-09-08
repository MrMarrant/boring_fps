BoringFPS_CONFIG.Vars.ScrW = ScrW()
BoringFPS_CONFIG.Vars.ScrH = ScrH()

surface.CreateFont( "HudBoringFPS", {
    font = "Anton",
    size = 40
} )

surface.CreateFont( "NickAnton", {
    font = "Anton",
    size = 35
} )

surface.CreateFont( "StateGame", {
    font = "Anton",
    size = 30
} )

surface.CreateFont( "AnnouncerTurn", {
    font = "Anton",
    size = 1200
} )

surface.CreateFont( "HudTimerLeft", {
    font = "Anton",
    size = 80
} )

hook.Add( "OnScreenSizeChanged", "OnScreenSizeChanged.BoringFPS", function( oldWidth, oldHeight )
    BoringFPS_CONFIG.Vars.ScrW = ScrW()
    BoringFPS_CONFIG.Vars.ScrH = ScrH()
end )