require "/scripts/vec2.lua"
require "/objects/sbtkpartstation/sbtkpartstation.lua"


function init()
    --local steamdecks = require "/objects/tinkersfurnace/tinkersfurnace.lua".storage.steamdeckcount
    self.canvas = widget.bindCanvas("canvas")
    local backTipBorder = {230,230,230,255}
    --self.canvas:drawRect({10, 10, 10 + steamdecks, 20}, backTipBorder)
end


function update(dt)
    self.canvas:clear()
    --widget.setText("lblText2", "Steam Decks generated: " .. steamdecks)
    --self.canvas:drawText("Steam Deck", {position={math.random(1,99), math.random(1,99)}},20,{math.random(1,255), math.random(1,255),math.random(1,255),255})
    --self.canvas:drawLine(vec2.sub(vec2.mul(line[1], tileSize), screenPos), vec2.sub(vec2.mul(line[2], tileSize), screenPos), anchorColor, 2)
end