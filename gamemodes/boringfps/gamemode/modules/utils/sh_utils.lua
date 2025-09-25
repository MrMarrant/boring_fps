function BoringFPS.GetLowestKey(tbl)
    local lowest = nil
    for k, _ in pairs(tbl) do
        if type(k) == "number" then
            if lowest == nil or k < lowest then
                lowest = k
            end
        end
    end
    return lowest
end

function BoringFPS.TableShrink(tbl, quantity, fromBegin)
    fromBegin = fromBegin or false
    for var = 1, quantity do
        if (fromBegin) then
            table.remove(tbl, 1)
        else
            table.remove(tbl)
        end
    end

    return tbl
end

function table.ShuffleSequential(t)
    local len = #t
    for i = len, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

function BoringFPS.FetchData(link, callback)
    http.Fetch(link,
        function(body, len, headers, code)
            if callback then
                callback(true, body, code, headers)
            end
        end,
        function(error)
            if callback then
                print(error)
                callback(false, error)
            end
        end
    )
end

function BoringFPS.Oscillate(duration, minVal, maxVal)
    local progress = (CurTime() % duration) / duration
    local sinVal = math.sin(progress * math.pi * 2) * 0.5 + 0.5
    
    return Lerp(sinVal, minVal, maxVal)
end

local LoadedSounds
if CLIENT then
	LoadedSounds = {} -- this table caches existing CSoundPatches
end

function BoringFPS.ReadSound( FileName, ent, volume, filterTable, fadeInDuration )
	local sound
	local filter
	if SERVER then
        filter = RecipientFilter()
        if (filterTable and not table.IsEmpty(filterTable)) then
            filter:AddPlayers(filterTable)
        else
            filter:AddAllPlayers()
        end
	end
	if SERVER or !LoadedSounds[FileName] then
		-- The sound is always re-created serverside because of the RecipientFilter.
		sound = CreateSound( ent, FileName, filter ) -- create the new sound, parented to the worldspawn (which always exists)
		if sound then
			sound:SetSoundLevel( volume )
			if CLIENT then
				LoadedSounds[FileName] = { sound, filter } -- cache the CSoundPatch
			end
		end
	else
		sound = LoadedSounds[FileName][1]
		filter = LoadedSounds[FileName][2]
	end
	if sound then
		if CLIENT then
			sound:Stop() -- it won't play again otherwise
		end
		sound:Play()
	end
    if (fadeInDuration) then
        sound:ChangeVolume(0, 0)
        sound:ChangeVolume(1, fadeInDuration)
    end
	return sound -- useful if you want to stop the sound yourself
end