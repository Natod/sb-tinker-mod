function init()
    
end

local number = 0

function update(dt)
    widget.setText("lblText2", "Steam Decks generated: " .. number)
    number = number + 1
    --self.canvas:drawLine(vec2.sub(vec2.mul(line[1], tileSize), screenPos), vec2.sub(vec2.mul(line[2], tileSize), screenPos), anchorColor, 2)
end