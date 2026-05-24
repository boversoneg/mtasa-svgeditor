-- @ Author: kotev_exe | 487874362477772809
-- @ Description: This source code is open source.
-- @ Zacznijmy wymagać więcej ~ Xyrusek

-- @Stroke: Stroke type has to be done. (inner, out)
function createRoundedRectangle(w, h, radius, color, strokeData)
    assert(type(w) == 'number', "Bad argument @ 'createRoundedRectangle' [expected number at argument 1, got "..type(w).."]")
    assert(type(h) == 'number', "Bad argument @ 'createRoundedRectangle' [expected number at argument 2, got "..type(h).."]")

    if (radius == nil) then
        radius = 0
    end
    assert(type(radius) == 'number', "Bad argument @ 'createRoundedRectangle' [expected number at argument 3, got "..type(radius).."]")

    if (not strokeData) then
        strokeData = {
            width = 0,
            color = '#000000',
        }
    end
    assert(type(strokeData) == 'table', "Bad argument @ 'createRoundedRectangle' [expected table at argument 5, got "..type(strokeData).."]")

    if (not color) then
        color = '#FFFFFF'
    end
    assert(type(color) == 'string', "Bad argument @ 'createRoundedRectangle' [expected string at argument 4, got "..type(color).."]")

    local strokeWidth = math.max(0, strokeData.width)
    local hasStroke = strokeWidth > 0
    local x = strokeWidth * 0.5
    local y = strokeWidth * 0.5
    local rectW = math.max(0, w - strokeWidth)
    local rectH = math.max(0, h - strokeWidth)
    local strokeAttr = ''

    if hasStroke then
        strokeAttr = string.format(' stroke="%s" stroke-width="%f"', strokeData.color, strokeWidth)
    end

    local rawCode = [[
        <svg width="%f" height="%f" fill="none">
            <rect x="%f" y="%f" width="%f" height="%f" rx="%f" fill="%s"%s/>
        </svg>
    ]]

    local formattedCode = string.format(rawCode, w, h, x, y, rectW, rectH, radius, color, strokeAttr)
    local svg = svgCreate(w, h, formattedCode)

    return svg
end