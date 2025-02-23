require "/scripts/util.lua"

function init()
  object.setInteractive(true)
  
  -- item container interface shenanigans must be done server-side
  -- pass in count 1 in the consumption itemdescriptor
  message.setHandler("sbtkToolStationCraft", function(messageName, isLocalEntity, toConsumeTable, output)
    for k,v in pairs(toConsumeTable) do 
      --world.containerConsumeAt(entity.id(), 0, 1)
      world.containerConsume(entity.id(), v)
    end
    world.containerPutItemsAt(entity.id(), output, 1)
  end)
end

function update(dt)
end

function onInteraction(interactSource)
  return {
    "ShowPopup", 
    {
      title = "Activation Failed!", 
      message = string.format("^red;Epic failure: %s.", "a"), 
      sound = "/sfx/cinematics/ship_upgrade/captain_gripe.ogg"
    } 
  }
end