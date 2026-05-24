--[[
    @Author: Maciej "bover." Grzymkowski
    Zacznijmy wymagać więcej ~ Xyrusek

    Kontakt mailowo: biznes.bover@gmail.com
    Kontakt discord: bover.
]]--

sx, sy = guiGetScreenSize()
zoom = 1920/sx
zoom = math.min(zoom, 1.3)

cache = {}

function toggleHUDComponents(state)
    setPlayerHudComponentVisible('all', state)
    showChat(state)
end 

function isMouseInPosition(x, y, w, h)
    if (not isCursorShowing()) then return false end

    local cx, cy = getCursorPosition()
    local cx, cy = cx * sx, cy * sy

    return (cx >= x) and (cx <= x + w) and (cy >= y) and (cy <= y + h)
end 

function click(x, y, w, h, button)
    if not x then return false end
    if type(x) ~= "number" then return false end

    if not y then return false end
    if type(y) ~= "number" then return false end

    if not w then return false end
    if type(w) ~= "number" then return false end

    if not h then return false end
    if type(h) ~= "number" then return false end

    local button = (button or "mouse1")

    if not clickblock then clickblock = {} end
    if clickblock[button] then
        if not getKeyState(button) then clickblock[button] = false end

        return false
    end

    if not getKeyState(button) then return false end
    if not isMouseInPosition(x, y, w, h) then return false end

    clickblock[button] = true

    return true
end