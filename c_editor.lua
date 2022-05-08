--[[
    @Author: Maciej "bover." Grzymkowski
    Zacznijmy wymagać więcej ~ Xyrusek
    
    Kontakt mailowo: biznes.bover@gmail.com
    Kontakt discord: bover.#1765
]]--

local sx, sy = guiGetScreenSize()
local zoom = 1 

if sx < 1920 then 
    zoom = math.min(2, 1920/sx)
end

editor = {}
editor.svg = nil
editor.previewPos = {sx/2+100/zoom, sy/2+100/zoom, 200, 200}

editor.gui = {}
editor.gui.window = guiCreateWindow(0.1, 0.2, 0.3, 0.6, 'SVG Editor', true)
guiWindowSetMovable(editor.gui.window, false)
guiWindowSetSizable(editor.gui.window, false)
editor.gui.updateButton = guiCreateButton(0.05, 0.85, 0.425, 0.1, 'Aktualizuj używając\nwprowadzonych wartości', true, editor.gui.window)
editor.gui.updateButton2 = guiCreateButton(0.525, 0.85, 0.425, 0.1, 'Aktualizuj używając\nraw daty', true, editor.gui.window)
editor.gui.editWidth = guiCreateEdit(0.05, 0.1, 0.3, 0.05, 200, true, editor.gui.window)
editor.gui.editHeight = guiCreateEdit(0.05, 0.19, 0.3, 0.05, 200, true, editor.gui.window)
editor.gui.widthLabel = guiCreateLabel(0.05, 0.07, 0.3, 0.05, 'Szerokość:', true, editor.gui.window)
editor.gui.heightLabel = guiCreateLabel(0.05, 0.161, 0.3, 0.05, 'Wysokość:', true, editor.gui.window)
editor.gui.editRound = guiCreateEdit(0.05, 0.27, 0.3, 0.05, 40, true, editor.gui.window)
editor.gui.rawDataMemo = guiCreateMemo(0.05, 0.37, 0.9, 0.45, '', true, editor.gui.window)

editor.isMouseIn = function(x, y, w, h)
    if not isCursorShowing() then return false end

    local cx, cy = getCursorPosition()
    cx, cy = cx * sx, cy * sy

    return ((cx >= x and cx <= x + w) and (cy >= y and cy <= y + h))
end

editor.updateSVG = function()
    local width = tonumber(guiGetText(editor.gui.editWidth))
    local height = tonumber(guiGetText(editor.gui.editHeight))
    local round = tonumber(guiGetText(editor.gui.editRound))
    local onePercentRound = 0.447692
    local rawData = [[
        <svg width="%s" height="%s" viewBox="0 0 %s %s" xmlns="http://www.w3.org/2000/svg">
        <path d="M0 %sC0 %s %s 0 %s 0H%sC%s 0 %s %s %s %sV%sC%s %s %s %s %s %sH%sC%s %s 0 %s 0 %sV%sZ" fill="#C4C4C4"/>
        </svg>
    ]]

    rawData = string.format(rawData, width, height, width, height, round, onePercentRound * round, onePercentRound * round, round, width - round, width - (onePercentRound * round), width, onePercentRound * round, width, round, height - (onePercentRound * round), width, height - (onePercentRound * round), width - (onePercentRound * round), height, width - (onePercentRound * round), height, round, onePercentRound * round, height, height - (onePercentRound * round), height - round, round)

    guiSetText(editor.gui.rawDataMemo, rawData)

    editor.previewPos[3] = width
    editor.previewPos[4] = height
    editor.svg = svgCreate(width, height, rawData)
end 

editor.updateWithRawData = function()
    local width = tonumber(guiGetText(editor.gui.editWidth))
    local height = tonumber(guiGetText(editor.gui.editHeight))
    local rawData = guiGetText(editor.gui.rawDataMemo)

    if rawData == '' then return end
    
    editor.previewPos[3] = width
    editor.previewPos[4] = height
    editor.svg = svgCreate(width, height, rawData)
end 

editor.renderPreview = function()
    dxDrawText('Podgląd', sx * 0.64, sy * 0.1, sx * 0.65, sy * 0.1, tocolor(255, 255, 255), 5, 'default-bold')
    dxDrawImage(editor.previewPos[1], editor.previewPos[2], editor.previewPos[3], editor.previewPos[4], editor.svg)

    if editor.isMouseIn(editor.previewPos[1], editor.previewPos[2], editor.previewPos[3], editor.previewPos[4]) and getKeyState('mouse1') then 
        local cx, cy = getCursorPosition()
        cx, cy = cx * sx, cy * sy

        editor.previewPos[1] = cx - (editor.previewPos[3] / 2)
        editor.previewPos[2] = cy - (editor.previewPos[4] / 2)
    end 
end 
addEventHandler('onClientRender', root, editor.renderPreview)

editor.resourceStart = function()
    editor.updateSVG()
    setPlayerHudComponentVisible('all', false)
    showCursor(true)
    showChat(false)
end 
addEventHandler('onClientResourceStart', resourceRoot, editor.resourceStart)

editor.guiClick = function(btn)
    if btn == 'left' then
        if source == editor.gui.updateButton then
            editor.updateSVG()
        elseif source == editor.gui.updateButton2 then
            editor.updateWithRawData()
        end
    end
end 
addEventHandler('onClientGUIClick', root, editor.guiClick)