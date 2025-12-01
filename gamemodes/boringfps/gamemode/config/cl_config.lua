BoringFPS_CONFIG.Vars.ScrW = ScrW()
BoringFPS_CONFIG.Vars.ScrH = ScrH()

surface.CreateFont( "LargeVT", {
    font = "VT323",
    size = 70
} )

surface.CreateFont( "DefaultVT", {
    font = "VT323",
    size = 40
} )

surface.CreateFont( "SmallVT", {
    font = "VT323",
    size = 35
} )

surface.CreateFont( "VerySmallVT", {
    font = "VT323",
    size = 25
} )

surface.CreateFont( "HudBoringFPS", {
    font = "Anton",
    size = 40
} )

surface.CreateFont( "NickAnton", {
    font = "Anton",
    size = 35
} )

surface.CreateFont( "Version", {
    font = "Anton",
    size = 20
} )

surface.CreateFont( "AnnouncerTurn", {
    font = "Anton",
    size = 1200
} )

surface.CreateFont( "HudTimerLeft", {
    font = "Anton",
    size = 80
} )

surface.CreateFont( "TabHUDLarge", {
    font = "DefaultFixed",
    size = 30
} )

surface.CreateFont( "TabHUDSmall", {
    font = "DefaultFixed",
    size = 25
} )

hook.Add( "OnScreenSizeChanged", "OnScreenSizeChanged.BoringFPS", function( oldWidth, oldHeight )
    BoringFPS_CONFIG.Vars.ScrW = ScrW()
    BoringFPS_CONFIG.Vars.ScrH = ScrH()
end )