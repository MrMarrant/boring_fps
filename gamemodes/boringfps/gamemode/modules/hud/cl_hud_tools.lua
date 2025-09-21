function BoringFPS.WrapText(text, font, maxWidth)
    surface.SetFont(font)
    local lines, currentLine = {}, ""
    
    for word in string.gmatch(text, "%S+") do
        local testLine = (currentLine == "") and word or (currentLine .. " " .. word)
        local w = surface.GetTextSize(testLine)
        
        if w > maxWidth then
            table.insert(lines, currentLine)
            currentLine = word
        else
            currentLine = testLine
        end
    end
    
    if currentLine ~= "" then
        table.insert(lines, currentLine)
    end

    return lines
end

function BoringFPS.DrawSquare(x, y, value, maxValue, squareW, squareH, xMargin, radius)
    radius = radius or 0
    local maxX = BoringFPS_CONFIG.Vars.ScrW
    local startY = y
    local startX = x
    local colorSquare = Color(0, 0, 0)
    xMargin = xMargin + squareW

    for i = 1, maxValue do
        colorSquare = i > value and Color(0, 0, 0) or Color(255, 255, 255)
        draw.RoundedBox(radius, startX, startY, squareW, squareH, colorSquare)
        startX = startX + xMargin
        if (startX >= maxX - squareW) then
            startX = x
            startY = startY + xMargin
        end
    end
end

function BoringFPS.DrawTriangle(x, y, value, maxValue, size, xMargin)
    local maxX = BoringFPS_CONFIG.Vars.ScrW
    local startY = y
    local startX = x
    local colorSquare = Color(0, 0, 0)
    xMargin = xMargin + size

    for i = 1, maxValue do
    local triangle = {
	{ x = startX - size, y = startY + size },
	{ x = startX, y = startY },
	{ x = startX + size, y = startY + size }
}
        colorSquare = i > value and Color(0, 0, 0) or Color(255, 255, 255)
        surface.SetDrawColor( colorSquare )
        draw.NoTexture()
        surface.DrawPoly( triangle )
        startX = startX + xMargin
        if (startX >= maxX - size) then
            startX = x
            startY = startY + xMargin
        end
    end
end

function BoringFPS.DrawIconHud(icon, x, y, col, w, h)
    w = w or 30
    h = h or 30
    col = col or Color(255, 255, 255)
    surface.SetMaterial(icon)
    surface.SetDrawColor(col:Unpack())
    surface.DrawTexturedRect(x, y - 5, w, h)
end

function BoringFPS.DrawRoundedOutlinedBox(r, x, y, w, h, bgColor, borderColor)
    draw.RoundedBox(r, x, y, w, h, bgColor)
    surface.SetDrawColor(borderColor)
    surface.DrawOutlinedRect(x, y, w, h, 2)
end

function BoringFPS.TruncatedText(text, font, maxWidth)
    surface.SetFont(font)
    local textW, _ = surface.GetTextSize(text)

    if textW > maxWidth then
        local truncated = text
        while string.len(truncated) > 0 do
            truncated = string.sub(truncated, 1, -2)
            local newW, _ = surface.GetTextSize(truncated .. "…")
            if newW <= maxWidth then
                text = truncated .. "…"
                break
            end
        end
    end
    return text
end