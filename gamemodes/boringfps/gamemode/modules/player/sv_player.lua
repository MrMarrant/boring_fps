local PLAYER = FindMetaTable("Player")

local TypePlay = {
    ["play"] = function (ply) ply:Play() end,
    ["wait"] = function (ply) ply:Wait() end,
    ["free"] = function (ply) ply:Free() end
}

function PLAYER:UpdateStepLeft(step)
    self:SetNWInt("StepLeft", step)
    if (step <= 0) then
        self:SetWalkSpeed( 1 )
        self:SetRunSpeed( 1 )
        self:SetJumpPower( 0 )
        hook.Remove("PlayerFootstep", "PlayerFootstep:CountStep:Player-" .. self:EntIndex())
        self:ChatPrint("Vous avez utilisez tout vos déplacements.")
    end
end

function PLAYER:SetState(typeState)
    if (not TypePlay[typeState]) then
        ErrorNoHaltWithStack("Invalid type for SetState: " .. tostring(typeState) .. "\n")
        return
    end
    self:SetNWString("State", typeState)
    TypePlay[typeState](self)
end

--! Le joueur peut : tourner la caméra / dash
function PLAYER:Wait()
    local WeaponGame = self:GetNWEntity("WeaponGame")
    self:SetWalkSpeed( 1 )
    self:SetRunSpeed( 1 )
    self:SetJumpPower( 0 )
    self:SetNWInt("Action", 0)
    self:SetNWInt("StepLeft", 0)
    self:SetNWInt("Dash", WeaponGame.MaxDash)
    self:ChatPrint("Vous êtes en attente.")
    net.Start(BoringFPS_CONFIG.NetVar.StartClientWait)
    net.Send(self)
    hook.Remove("PlayerFootstep", "PlayerFootstep:CountStep:Player-" .. self:EntIndex())
end

function PLAYER:Play()
    net.Start(BoringFPS_CONFIG.NetVar.StopClientTurn)
    net.Send(self)
    local WeaponGame = self:GetNWEntity("WeaponGame")

    self:SetWalkSpeed( WeaponGame.WalkSpeed )
    self:SetRunSpeed( WeaponGame.RunSpeed )
    self:SetJumpPower( 200 )
    self:ChatPrint("Vous êtes en train de jouer.")

    self:SetNWInt("StepLeft", WeaponGame.MaxStep)
    self:SetNWInt("Action", WeaponGame.Action)
    self:SetNWInt("Dash", -1)
    net.Start(BoringFPS_CONFIG.NetVar.StartClientPlay)
    net.Send(self)
    hook.Add( "PlayerFootstep", "PlayerFootstep:CountStep:Player-" .. self:EntIndex(), function( ply )
        if (ply == self) then ply:UpdateStepLeft(ply:GetNWInt("StepLeft") - 1) end
        return false
    end )
end

function PLAYER:Free()
    self:SetWalkSpeed( 150 )
    self:SetRunSpeed( 200 )
    self:SetJumpPower( 200 )
    hook.Remove("PlayerFootstep", "PlayerFootstep:CountStep:Player-" .. self:EntIndex())
end

hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn:BoringFPS:SetupData", function(ply)
    ply:SetNWInt("NumberTurn", -1)
    ply:SetNWInt("StepLeft", -1)
    ply:SetNWInt("Action", -1)
    ply:SetNWInt("Dash", -1)
    ply:SetState("free")
    ply:SetNWString("ClassWeapon", "pistol")
    ply:SetModel(table.Random(BoringFPS_CONFIG.Models.Characters))
end)

concommand.Add("changeclass", function(ply, cmd, args, argStr)
    local weapon = BoringFPS_CONFIG.Settings.ClassWeapon[args[1]]
    if (weapon) then
        ply:SetNWString("ClassWeapon", args[1])
        ply:ChatPrint("Vous avez changé votre classe d'arme en : " .. args[1])
    else
        ply:ChatPrint("Classe d'arme invalide.")
    end
end)