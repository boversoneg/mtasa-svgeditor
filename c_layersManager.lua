-- @ Author: kotev_exe | 487874362477772809
-- @ Description: This source code is open source.
-- @ Zacznijmy wymagać więcej ~ Xyrusek

cache.layers = {}

function createLayer(layerType, x, y, w, h, data)
    assert(type(layerType) == 'string', "Bad argument @ 'createLayer' [expected string at argument 1, got "..type(layerType).."]")
    assert(type(x) == 'number', "Bad argument @ 'createLayer' [expected number at argument 2, got "..type(x).."]")
    assert(type(y) == 'number', "Bad argument @ 'createLayer' [expected number at argument 3, got "..type(y).."]")
    assert(type(w) == 'number', "Bad argument @ 'createLayer' [expected number at argument 4, got "..type(w).."]")
    assert(type(h) == 'number', "Bad argument @ 'createLayer' [expected number at argument 5, got "..type(h).."]")

    if (not data) then data = {} end
    assert(type(data) == 'table', "Bad argument @ 'createLayer' [expected table at argument 6, got "..type(data).."]")

    local id = findFreeLayerId()
    cache.layers[id] = {type = layerType, x = x, y = y, w = w, h = h, data = data}
    
    return id
end

function renderLayers()
    for index, LayerData in pairs(cache.layers) do
        if ((LayerData.data) and (LayerData.data['textureElement']) and (isElement(LayerData.data['textureElement']))) then
            dxDrawImage(LayerData.x, LayerData.y, LayerData.w, LayerData.h, LayerData.data['textureElement'])
        end
    end
end

function renderPreviewLayer(type, x, y, w, h)
    if type == 'rectangle' then
        dxDrawRectangle(x, y, w, h, tocolor(255, 255, 255, 255))
    end
end

function findFreeLayerId()
    local idTable = {}
    for id, _ in pairs(cache.layers) do 
    	table.insert(idTable, tonumber(id))
    end 
    
    table.sort(idTable)
    local freeId = 1
    
    for _, v in ipairs(idTable) do 
    	if (v == freeId) then 
    		freeId = freeId + 1
    	end 
    	
    	if (v > freeId) then 
    		return freeId 
    	end 
    end 

    return freeId
end

function destroyLayer(id)
    if (not cache.layers[id]) then return false end

    for _, layerData in pairs(cache.layers[id].data or {}) do
        if (isElement(layerData)) then
            destroyElement(layerData)
        end
    end

    cache.layers[id] = nil
    return true
end