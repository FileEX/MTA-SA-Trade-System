function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
        return true
    else
        return false
    end
end

function findPlayerById(id) -- FileEX
    local p;

    for k,v in pairs(Element.getAllByType('player')) do
        if v:getData('id') == id then
            p = v;
            break;
        end
    end
    return p;
end