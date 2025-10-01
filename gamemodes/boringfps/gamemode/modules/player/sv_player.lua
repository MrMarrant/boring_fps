local PLAYER = FindMetaTable("Player")

local TypePlay = {
    ["play"] = function (ply) ply:Play() end,
    ["wait"] = function (ply) ply:Wait() end,
    ["free"] = function (ply) ply:Free() end
}

function PLAYER:UpdateStepLeft(step)
    self:SetNWInt("StepLeft", step)
    hook.Call("OnNewDataPlayer", nil, self, "movement_done")
    if (step <= 0) then
        self:SetWalkSpeed( 1 )
        self:SetRunSpeed( 1 )
        self:SetJumpPower( 0 )
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
-- TODO : empecher le jump boost
function PLAYER:Wait()
    net.Start(BoringFPS_CONFIG.NetVar.StopClientTurn)
    net.Send(self)
    local WeaponGame = self:GetNWEntity("WeaponGame")
    self:SetWalkSpeed( 1 )
    self:SetRunSpeed( 1 )
    self:SetJumpPower( 0 )
    self:SetAction(0)
    self:SetNWInt("StepLeft", 0)
    self:SetNWInt("Dash", WeaponGame.MaxDash)
    self:ChatPrint("Vous êtes en attente.")
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
    self:SetAction(WeaponGame.Action)
    self:SetNWInt("Dash", -1)
    net.Start(BoringFPS_CONFIG.NetVar.StartClientPlay)
    net.Send(self)
end

function PLAYER:Free()
    self:SetWalkSpeed( 150 )
    self:SetRunSpeed( 200 )
    self:SetJumpPower( 200 )
end

function PLAYER:SaveDataStats()
    local data = self.BFPS_DataStats
    if (not istable(data)) then return end
    local id = self:SteamID64()
    local table = BoringFPS_CONFIG.SQL.TableClassStat
    print("Saving stats for player: " .. self:Nick())
    for class, stats in pairs(data) do
        local query = [[
            UPDATE ]] .. table .. [[ SET
                death = ]] .. tonumber(stats["death"]) .. [[,
                kill = ]] .. tonumber(stats["kill"]) .. [[,
                damage = ]] .. tonumber(stats["damage"]) .. [[,
                count_select = ]] .. tonumber(stats["count_select"]) .. [[,
                win = ]] .. tonumber(stats["win"]) .. [[
            WHERE steamID = ']] .. id .. [[' AND class_type = ']] .. class .. [[';
        ]]
        local result = BoringFPS.CreateQuery(query)

        if result == false then
            print("[BORINGFPS] Error during set data stats for class '" .. class .. "'")
        end
    end
end

function PLAYER:SaveDataPlayer()
    local data = self.BFPS_DataPlayer
    if (not istable(data)) then return end
    print("Saving data for player: " .. self:Nick())
    local query = [[
        UPDATE ]] .. BoringFPS_CONFIG.SQL.TablePlayer .. [[ SET
            level = ]] .. tonumber(data["level"]) .. [[,
            exp = ]] .. tonumber(data["exp"]) .. [[,
            death = ]] .. tonumber(data["death"]) .. [[,
            kill = ]] .. tonumber(data["kill"]) .. [[,
            damage = ]] .. tonumber(data["damage"]) .. [[,
            movement_done = ]] .. tonumber(data["movement_done"]) .. [[,
            action_done = ]] .. tonumber(data["action_done"]) .. [[,
            dash_done = ]] .. tonumber(data["dash_done"]) .. [[,
            turn_done = ]] .. tonumber(data["turn_done"]) .. [[,
            win = ]] .. tonumber(data["win"]) .. [[
        WHERE id = ']] .. self:SteamID64() .. [[';
    ]]
    local result = BoringFPS.CreateQuery(query)
    return nil
end

function PLAYER:SetDataStats(class, name, value)
    if (not istable(self.BFPS_DataStats)) then return end
    if (self.BFPS_DataStats[class] == nil or self.BFPS_DataStats[class][name] == nil) then
        return
    else
        self.BFPS_DataStats[class][name] = (self.BFPS_DataStats[class][name] or 0) + value
    end
end

function PLAYER:SetDataPlayer(name, value)
    if (not istable(self.BFPS_DataPlayer)) then return end
    if (self.BFPS_DataPlayer[name] == nil) then
        ErrorNoHaltWithStack("Invalid name for SetDataPlayer: " .. tostring(name) .. "\n")
        return
    else
        self.BFPS_DataPlayer[name] = value
    end
end

function PLAYER:GetDataPlayer()
    if (self:IsBot()) then return end
    print("Getting data for player: " .. self:Nick())
    local query = [[
        SELECT * FROM ]] .. BoringFPS_CONFIG.SQL.TablePlayer .. [[ WHERE id = ']] .. self:SteamID64() .. [[';
    ]]
    local result = BoringFPS.CreateQuery(query)

    if result == false then
        print("[BORINGFPS] Error during get data player")
    elseif istable(result) then
        self.BFPS_DataPlayer = result[1]
    else
        if self:CreateDataPlayer() then self:GetDataPlayer() end
    end
end

function PLAYER:GetDataStats()
    if (self:IsBot()) then return end
    print("Getting data for stats: " .. self:Nick())
    local query = [[
        SELECT * FROM ]] .. BoringFPS_CONFIG.SQL.TableClassStat .. [[ WHERE steamID = ']] .. self:SteamID64() .. [[';
    ]]
    local result = BoringFPS.CreateQuery(query)

    if result == false then
        print("[BORINGFPS] Error during get data stats")
    elseif istable(result) then
        local data = {}
        for _, row in ipairs(result) do
            data[row.class_type] = row
        end
        self.BFPS_DataStats = data
    else
        if (self:CreateDataStats()) then self:GetDataStats() end
    end
end

function PLAYER:CreateDataStats()
    local sucess = true
    for key, class in ipairs(BoringFPS_CONFIG.Settings.ListClass) do
        local query = [[
        INSERT INTO ]].. BoringFPS_CONFIG.SQL.TableClassStat .. [[ (
            steamID, class_type, death, kill, damage, count_select, win
        ) VALUES ( ']].. self:SteamID64() ..[[', ']].. class ..[[', 0, 0, 0, 0, 0 );
        ]]
        local result = BoringFPS.CreateQuery(query)
        if result == false then
            print("[BORINGFPS] Error during create data class '" .. class .. "' stats")
            sucess = false
        end
    end
    return sucess
end

function PLAYER:CreateDataPlayer()
    local query = [[
        INSERT INTO ]].. BoringFPS_CONFIG.SQL.TablePlayer .. [[ (
            id, level, exp, death, kill, damage, movement_done, action_done, dash_done, turn_done, win
        ) VALUES ( ']].. self:SteamID64() ..[[', 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 );
    ]]
    local result = BoringFPS.CreateQuery(query)
    if result == false then
        print("[BORINGFPS] Error during create data player")
        return false
    else
        print("[BORINGFPS] Data player created for " .. self:Nick())
        return true
    end
end

function PLAYER:AddExperience(amountExp)
    if (istable(self.BFPS_DataPlayer)) then
        local currentExp = self.BFPS_DataPlayer["exp"] or 0
        local currentLevel = self.BFPS_DataPlayer["level"] or 1
        local newExp = currentExp + amountExp
        local nextLevel = currentLevel + 1
        local expToNextLevel = (differenceExp / 2) * currentLevel * (nextLevel)

        self:SetDataPlayer("exp", newExp)
        self:ChatPrint("You have gained " .. amountExp .. " experience points.")
        if (newExp >= expToNextLevel) then
            self:SetDataPlayer("level", nextLevel)
            self:ChatPrint("Congratulations! You have leveled up to level " .. nextLevel .. "!")
        end
    end
end

-- ============================
-- HOOKS
-- ============================

hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn:BoringFPS:SetupData", function(ply)
    ply:SetNWInt("NumberTurn", -1)
    ply:SetNWInt("StepLeft", 0)
    ply:SetAction(0)
    ply:SetNWInt("Dash", 0)
    ply:SetNWString("ClassWeapon", "pistol")
    BoringFPS.DisplayHUDPreGame(ply)
end)

-- When a player login, strip all weapons
gameevent.Listen( "player_activate" )
hook.Add("player_activate", "player_activate.BoringFPS:OnActivate", function( data )
    local ply = Player(data.userid)
    ply:SetState("free")
    ply:GetDataPlayer()
    ply:GetDataStats()
end)

hook.Add("PlayerSetModel", "BoringFPS:PlayerSetModel:SetModelSpawn", function( ply )
    ply:SetModel(table.Random(BoringFPS_CONFIG.Models.Characters))
    return true
end)

hook.Add("PlayerLoadout", "BoringFPS:PlayerLoadout:PlayerSetWeapon", function( ply )
    return true
end)

hook.Add("PlayerDisconnected", "PlayerDisconnected:BoringFPS:OnDisconnect", function(ply)
    ply:SaveDataPlayer()
    ply:SaveDataStats()
end)

hook.Add( "ShutDown", "BoringFPS:ShutDown:ServerShuttingDown", function()
    for key, ply in ipairs(player.GetAll()) do
        ply:SaveDataPlayer()
        ply:SaveDataStats()
    end
end)

-- ============================
-- Hooks for stats
-- ============================
hook.Add("PlayerDeath", "PlayerDeath:BoringFPS:Stats", function(ply, inflictor, attacker)
    if (GetGlobalBool("GameInProgress") and BoringFPS_CONFIG.Vars.PlayersInGame[ply:GetNWInt("NumberTurn")]) then
        if (istable(ply.BFPS_DataStats)) then
            local class = ply:GetNWString("ClassWeapon", "pistol")
            ply:SetDataPlayer("death", (ply.BFPS_DataPlayer["death"] or 0) + 1)
            ply:SetDataStats(class, "death", 1)
        end
        if (istable(attacker.BFPS_DataStats) and BoringFPS_CONFIG.Vars.PlayersInGame[attacker:GetNWInt("NumberTurn")]) then
            local class = attacker:GetNWString("ClassWeapon", "pistol")
            attacker:SetDataPlayer("kill", (attacker.BFPS_DataPlayer["kill"] or 0) + 1)
            attacker:SetDataStats(class, "kill", 1)
            attacker:AddExperience(BoringFPS_CONFIG.Settings.ExperienceGainByKill)
        end
    end
end)

hook.Add("EntityTakeDamage", "EntityTakeDamage:BoringFPS:Stats", function(target, dmginfo)
    local attacker = dmginfo:GetAttacker()
    if (istable(attacker.BFPS_DataStats) and GetGlobalBool("GameInProgress")) then
        if (attacker:IsPlayer() and attacker != target and BoringFPS_CONFIG.Vars.PlayersInGame[attacker:GetNWInt("NumberTurn")]) then
            local damage = math.Round(dmginfo:GetDamage())
            local class = attacker:GetNWString("ClassWeapon", "pistol")
            attacker:SetDataPlayer("damage", (attacker.BFPS_DataPlayer["damage"] or 0) + damage)
            attacker:SetDataStats(class, "damage", damage)
        end
    end
end)

hook.Add("OnNewDataPlayer", "OnNewDataPlayer:BoringFPS:Stats", function(ply, dataName)
    if (istable(ply.BFPS_DataStats) and GetGlobalBool("GameInProgress") and BoringFPS_CONFIG.Vars.PlayersInGame[ply:GetNWInt("NumberTurn")]) then
        local class = ply:GetNWString("ClassWeapon", "pistol")
        ply:SetDataPlayer(dataName, (ply.BFPS_DataPlayer[dataName] or 0) + 1)
        ply:SetDataStats(class, dataName, 1)
    end
end)

-- ============================
-- Concommands
-- ============================

concommand.Add("changeclass", function(ply, cmd, args, argStr)
    local weapon = BoringFPS_CONFIG.Settings.ClassWeapon[args[1]]
    if (weapon) then
        ply:SetNWString("ClassWeapon", args[1])
        ply:ChatPrint("Vous avez changé votre classe d'arme en : " .. args[1])
    else
        ply:ChatPrint("Classe d'arme invalide.")
    end
end)

concommand.Add("ff", function(ply, cmd, args, argStr)
    if (GetGlobalBool("GameInProgress") and table.HasValue(BoringFPS_CONFIG.Vars.PlayersAlive, ply)) then
        BoringFPS.InsertLogs(ply:GetName() .. " has forfeited.")
        ply:Kill()
    else
        ply:ChatPrint("Les conditions ne sont pas remplies ...")
    end
end)