function BoringFPS.DisplayHUDPreGame()
    local timerPreGame = BoringFPS_CONFIG.Settings.TimerPreGame
    local timerStart = false
    local startTimer
    hook.Add( "HUDPaint", "HUDPaint:BoringFPS:HUDPreGame", function()
        local scrW, scrH = BoringFPS_CONFIG.Vars.ScrW, BoringFPS_CONFIG.Vars.ScrH
        BoringFPS.DrawClassSelect(scrW, scrH)
        if (GetGlobalBool("IsStartTimerPreGame")) then
            ct = CurTime()
            startTimer = timerStart and startTimer or (ct + timerPreGame)
            timerStart = true
            BoringFPS.DrawTimerLeft(scrW, scrH, math.Round(startTimer - ct))
        else
            timerStart = false --? Pas ouf mais flemme
        end
    end)
end

function BoringFPS.StopHUDPreGame()
    hook.Remove( "HUDPaint", "HUDPaint:BoringFPS:HUDPreGame" )
end

function BoringFPS.DrawClassSelect(scrW, scrH)
    surface.SetDrawColor(255, 255, 255)
    surface.DrawRect(scrW * 0.87, scrH * 0.75, scrW * 0.1, scrH * 0.2)
    surface.SetDrawColor(0, 0, 0)
    surface.DrawRect(scrW * 0.875, scrH * 0.76, scrW * 0.09, scrH * 0.15)
    BoringFPS.DrawIconHud(BoringFPS_CONFIG.Settings.IconsClass[LocalPlayer():GetNWString("ClassWeapon")], scrW * 0.896, scrH * 0.795, Color(255, 255, 255), scrW * 0.05, scrW * 0.05)
    draw.DrawText("Current Class", "NickAnton", scrW * 0.92, scrH * 0.91, Color(0, 0, 0), TEXT_ALIGN_CENTER)
end

net.Receive(BoringFPS_CONFIG.NetVar.StartClientPreGame, function()
    BoringFPS.DisplayHUDPreGame()
end)

net.Receive(BoringFPS_CONFIG.NetVar.StopClientPreGame, function()
    BoringFPS.StopHUDPreGame()
end)