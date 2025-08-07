local selectedLanguage = GetConVar("gmod_language"):GetString() -- Switch language by setting gmod_language to another language

--[[
* Returns the element to be translated according to the server language.
* @string langName Language name (ex : en, fr)
* @table data The table contain the translations
--]]
function BoringFPS.AddLanguage(langName, data)
    if (type(langName) == "string" and type(data) == "table") then
        BoringFPS_LANG[langName] = data
    end
end

--[[
* Returns the element to be translated according to the server language.
* @string name Element to translate.
--]]
function BoringFPS.GetTranslation(name)
    local langUsed = BoringFPS_CONFIG.LangServer
    if not BoringFPS_LANG[langUsed] then
        langUsed = "en" -- Default lang is EN.
    end
    return string.format( BoringFPS_LANG[langUsed][ name ] or "Not Found" )
end