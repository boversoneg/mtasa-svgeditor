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
editor.gui.updateButton = guiCreateButton(0.05, 0.85, 0.425, 0.1, 'Update preview using provided arguments', true, editor.gui.window)
editor.gui.updateButton2 = guiCreateButton(0.525, 0.85, 0.425, 0.1, 'Update preview using raw data', true, editor.gui.window)
editor.gui.editWidth = guiCreateEdit(0.05, 0.1, 0.3, 0.05, 200, true, editor.gui.window)
editor.gui.editHeight = guiCreateEdit(0.05, 0.19, 0.3, 0.05, 200, true, editor.gui.window)
editor.gui.widthLabel = guiCreateLabel(0.05, 0.07, 0.3, 0.05, 'Width:', true, editor.gui.window)
editor.gui.heightLabel = guiCreateLabel(0.05, 0.161, 0.3, 0.05, 'Height:', true, editor.gui.window)
editor.gui.roundLabel = guiCreateLabel(0.05, 0.252, 0.3, 0.05, 'Round radius:', true, editor.gui.window)
editor.gui.editRound = guiCreateEdit(0.05, 0.28, 0.3, 0.05, 40, true, editor.gui.window)
editor.gui.rawDataMemo = guiCreateMemo(0.05, 0.37, 0.9, 0.45, '', true, editor.gui.window)

editor.isMouseIn = function(x, y, w, h)
    if not isCursorShowing() then return false end

    local cx, cy = getCursorPosition()
    cx, cy = cx * sx, cy * sy

    return ((cx >= x and cx <= x + w) and (cy >= y and cy <= y + h))
end

editor.createRawDataUsingArguments = function(w, h, round, type)
    local data = editor.generator.tags
    if type == 'square' then 
        local openTag = string.sub(data, 0, -8)
        openTag = openTag ..' '..editor.generator.svgArgs..'>'

        local closeTag = string.sub(data, -6)
        
        data = openTag..'\n'..editor.generator.roundedSquare..'\n'..closeTag
        data = string.format(data, w, h, w, h, w, h, round)
        return data
    end 
end 

editor.updateSVG = function()
    local width = tonumber(guiGetText(editor.gui.editWidth))
    local height = tonumber(guiGetText(editor.gui.editHeight))
    local round = tonumber(guiGetText(editor.gui.editRound))
    local rawData = editor.createRawDataUsingArguments(width, height, round, 'square')

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
    dxDrawText('Preview', sx * 0.64, sy * 0.1, sx * 0.65, sy * 0.1, tocolor(255, 255, 255), 5, 'default-bold')
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