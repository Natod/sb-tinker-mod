require "/scripts/util.lua"

function init()
  object.setInteractive(true)
  --storage.materialData = {}

  --local sbtkSourceJson = root.assetJson("/sbtk_util/sbtk_util.config")
  --self.sbtkCraftingMatConfig = sbtkSourceJson["sbtkCraftingMatConfig"]

  -- item container interface shenanigans must be done server-side
  message.setHandler("sbtkPartStationCraft", function(messageName, isLocalEntity, count, item)
    world.containerConsumeAt(entity.id(), 0, count)
    world.containerPutItemsAt(entity.id(), item, 1)
  end)
end

function update(dt)
  --local mat = world.containerItemAt(entity.id(), 0)
  --sb.logInfo(sb.print(mat))
  --[[
  
  if mat and self.sbtkCraftingMatConfig[mat.name] then
    -- eg "ironbar" sets to sbtk "iron" material type
    storage.materialData.material = self.sbtkCraftingMatConfig[mat.name]
    storage.materialData.count = mat.count
  else
    storage.materialData = {}
  end
  ]]
  --sb.logInfo(sb.print(storage.materialData))
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