function init()
  --object.setInteractive(true)playsound
  object.setSoundEffectEnabled(false)
end

--local number = 1

local playsound = false

function onInteraction(interactSource)
  --world.sendEntityMessage(interactSource.sourceId, "deployMech")
  --animator.playSound("/sfx/cinematics/ship_upgrade/captain_gripe.ogg")
  --object.smash()
  playsound = not playsound
  object.setSoundEffectEnabled(playsound)
  --local reason = "Steam Deck not detected"
  --return { "ShowPopup", { title = "Activation Failed!", message = string.format("^red;Epic failure: %s.", reason), sound = "/sfx/cinematics/ship_upgrade/captain_gripe.ogg"} }
end