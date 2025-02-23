require "/scripts/vec2.lua"
require "/objects/tinkersfurnace/tinkersfurnace.lua"


function init()
    
    self.canvas = widget.bindCanvas("canvas")
    local backTipBorder = {230,230,230,255}
    self.canvas:drawRect({10, 10, 10 + storage.steamdeckcount, 20}, backTipBorder)
end

function update(dt)
    self.canvas:clear()
    --self.canvas:drawRect({10, 10, 10 + number, 20}, backTipBorder)
    widget.setText("lblText2", "Steam Decks generated: " .. storage.steamdeckcount)
    --number = number + 1
    self.canvas:drawText("Steam Deck", {position={math.random(1,99), math.random(1,99)}},20,{math.random(1,255), math.random(1,255),math.random(1,255),255})
    --self.canvas:drawLine(vec2.sub(vec2.mul(line[1], tileSize), screenPos), vec2.sub(vec2.mul(line[2], tileSize), screenPos), anchorColor, 2)
end