function isMouseInPosition(x, y, w, h)
    if not isCursorShowing() then return false end

    local cx, cy = getCursorPosition()
    cx, cy = cx * sx, cy * sy

    return ((cx >= x and cx <= x + w) and (cy >= y and cy <= y + h))
end
