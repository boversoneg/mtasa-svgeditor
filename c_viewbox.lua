--[[
    @Author: Maciej "bover." Grzymkowski
    Zacznijmy wymagać więcej ~ Xyrusek

    Kontakt mailowo: biznes.bover@gmail.com
    Kontakt discord: bover.
]]--

local logoTexture = dxCreateTexture('files/textures/logo.png', 'argb', true, 'clamp')
local urlTextWidth = dxGetTextWidth('https://github.com/boversoneg/mtasa-svgeditor | ', 1, 'default')
local draggableTools = { 
	['rectangle'] = true,
}

function renderViewbox()
    if (not cache.settings) then return false end 

    dxDrawRectangle(0, 0, sx, sy, tocolor(cache.settings.viewboxColor[1], cache.settings.viewboxColor[2], cache.settings.viewboxColor[3], 255))
    dxDrawImage(10/zoom, sy - 64/zoom - 10/zoom, 64/zoom, 64/zoom, logoTexture, 0, 0, 0, tocolor(255, 255, 255, 150))
    dxDrawText('https://github.com/boversoneg/mtasa-svgeditor | ', sx - urlTextWidth - 70/zoom, sy - 15/zoom, nil, nil, tocolor(255, 255, 255, 150), 1, 'default')
    
    renderLayers()
    renderToolbox()

    if ((getKeyState('mouse1')) and (not cache.dragStartPosition) and (not isMouseInPosition(sx/2-(cache.toolboxWidth / 2), 10/zoom, cache.toolboxWidth, cache.toolboxHeight))) then
        if (not draggableTools[cache.currentTool]) then return false end
        
        local cx, cy = getCursorPosition()
        cache.dragStartPosition = { x = cx * sx, y = cy * sy }
    elseif ((getKeyState('mouse1')) and (cache.dragStartPosition)) then
        if (not draggableTools[cache.currentTool]) then return false end
        local cx, cy = getCursorPosition()
        local x, y = cx * sx, cy * sy

        local px = math.min(cache.dragStartPosition.x, x)
        local py = math.min(cache.dragStartPosition.y, y)
        local w, h = math.abs(cache.dragStartPosition.x - x), math.abs(cache.dragStartPosition.y - y)

        renderPreviewLayer(cache.currentTool, px, py, w, h)
    elseif ((not getKeyState('mouse1')) and (cache.dragStartPosition)) then
        if (not draggableTools[cache.currentTool]) then return false end
        
        local cx, cy = getCursorPosition()
        cache.dragEndPosition = { x = cx * sx, y = cy * sy }
        
        local x = math.min(cache.dragStartPosition.x, cache.dragEndPosition.x)
        local y = math.min(cache.dragStartPosition.y, cache.dragEndPosition.y)
        local w, h = math.abs(cache.dragStartPosition.x - cache.dragEndPosition.x), math.abs(cache.dragStartPosition.y - cache.dragEndPosition.y)
        if ((w == 0) and (h == 0)) then
            w = 100
            h = 100
        end
        w = math.max(1, w)
        h = math.max(1, h)
    
        createLayer(cache.currentTool, tonumber(x), tonumber(y), tonumber(w), tonumber(h), {
            textureElement = createRoundedRectangle(tonumber(w), tonumber(h))
        })

        cache.dragStartPosition = nil
        cache.dragEndPosition = nil
    end
end

function createViewbox()
    toggleHUDComponents(false)
    applySettings()

    addEventHandler('onClientRender', root, renderViewbox)
    showCursor(true)
end 
addEventHandler('onClientResourceStart', resourceRoot, createViewbox)
