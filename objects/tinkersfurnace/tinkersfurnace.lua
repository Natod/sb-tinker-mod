function init()
  object.setInteractive(true)
  object.setSoundEffectEnabled(false)
end

local eoiewg = false

function onInteraction(interactSource)
  --world.sendEntityMessage(interactSource.sourceId, "deployMech")
  --animator.playSound("/sfx/cinematics/ship_upgrade/captain_gripe.ogg")
  --object.smash()
  eoiewg = not eoiewg
  object.setSoundEffectEnabled(eoiewg)
end