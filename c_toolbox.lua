--[[
    @Author: Maciej "bover." Grzymkowski
    Zacznijmy wymagać więcej ~ Xyrusek

    Kontakt mailowo: biznes.bover@gmail.com
    Kontakt discord: bover.
]]--

cache.tools = {
    ['cursor'] = {
        name = 'Cursor',
        icon = dxCreateTexture('files/textures/cursorToolIcon.png', 'argb', true, 'clamp'),
    },

    ['rectangle'] = {
        name = 'Rectangle',
        icon = dxCreateTexture('files/textures/rectangleToolIcon.png', 'argb', true, 'clamp'),
    },
}

function createToolboxBackground()
    local totalToolboxWidth = 0
    local itemGap = cache.settings.toolboxItemGap
    local highestIcon = 0
    for toolKey, toolData in pairs(cache.tools) do
        local iconWidth, iconHeight = dxGetMaterialSize(toolData.icon)
        totalToolboxWidth = itemGap + totalToolboxWidth + iconWidth

        if (iconHeight > highestIcon) then
            highestIcon = iconHeight
        end
    end

    totalToolboxWidth = totalToolboxWidth + itemGap
    local totalToolboxHeight = highestIcon + (itemGap * 2)

    local backgroundSVG = [[
        <svg width="%f" height="%f" fill="none">
            <rect x="0.5" y="0.5" width="%f" height="%f" rx="16" fill="#282828" stroke="#505050"/>
        </svg>
    ]]

    local formattedSVG = string.format(backgroundSVG, totalToolboxWidth, totalToolboxHeight, totalToolboxWidth - 1, totalToolboxHeight - 1)

    cache.toolboxWidth = totalToolboxWidth
    cache.toolboxHeight = totalToolboxHeight

    svgCreate(totalToolboxWidth, totalToolboxHeight, formattedSVG, function(texture)
        cache.toolboxBackgroundTexture = texture
    end)
end

function renderToolbox()
    if (not cache.toolboxInitialized) then initializeToolbox(); return false end
    if (not cache.settings) then return false end
    if (not cache.toolboxBackgroundTexture) then return false end 

    local toolboxX, toolboxY, toolboxW, toolboxH = sx/2-(cache.toolboxWidth / 2), 10/zoom, cache.toolboxWidth, cache.toolboxHeight

    dxDrawImage(toolboxX, toolboxY, toolboxW, toolboxH, cache.toolboxBackgroundTexture)

    local itemGap = cache.settings.toolboxItemGap
    local currentX = toolboxX
    for toolKey, toolData in pairs(cache.tools) do
        local iconWidth, iconHeight = dxGetMaterialSize(toolData.icon)
        currentX = currentX + itemGap

        local toolBoxColor = (cache.currentTool == toolKey) and tocolor(255, 255, 255, 255) or tocolor(190, 190, 190, 255)
        dxDrawImage(currentX, toolboxY + (toolboxH / 2) - (iconHeight / 2), iconWidth, iconHeight, toolData.icon, 0, 0, 0, toolBoxColor)

        if (click(currentX, toolboxY + (toolboxH / 2) - (iconHeight / 2), iconWidth, iconHeight)) then
            if (not cache.tools[cache.currentTool]) then return false end
            if (cache.currentTool == toolKey) then return false end
            
            cache.currentTool = toolKey
            cache.dragStartPosition = nil
            cache.dragEndPosition = nil
        end

        currentX = currentX + iconWidth
    end
end

function initializeToolbox()
    if (cache.toolboxInitialized) then return false end

    createToolboxBackground()
    cache.toolboxInitialized = true 
    cache.currentTool = 'cursor'
end 