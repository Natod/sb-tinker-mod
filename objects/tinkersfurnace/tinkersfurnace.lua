require "/scripts/util.lua"

function init()
  --object.setInteractive(true)playsound
  storage.playsound = storage.playsound or false
  storage.steamdeckcount = storage.steamdeckcount or 0
  object.setSoundEffectEnabled(storage.playsound)
end

-- storage.playsound = false

function update(dt)
  storage.steamdeckcount = storage.steamdeckcount + 1 
end

function onInteraction(interactSource)
  --world.sendEntityMessage(interactSource.sourceId, "deployMech")
  --animator.playSound("/sfx/cinematics/ship_upgrade/captain_gripe.ogg")
  --object.smash()
  storage.playsound = not storage.playsound
  object.setSoundEffectEnabled(storage.playsound)
  --local reason = "Steam Deck not detected"
  --return { "ShowPopup", { title = "Activation Failed!", message = string.format("^red;Epic failure: %s.", reason), sound = "/sfx/cinematics/ship_upgrade/captain_gripe.ogg"} }
  return { "ShowPopup", { title = "Activation Failed!", message = string.format("^red;Epic failure: %s.", "aaaa: " .. tostring(storage.playsound)), sound = "/sfx/cinematics/ship_upgrade/captain_gripe.ogg"} }
end