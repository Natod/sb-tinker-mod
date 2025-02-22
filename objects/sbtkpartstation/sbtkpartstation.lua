require "/scripts/util.lua"

function init()
  object.setInteractive(true)
  storage.currentMaterial = {}

  local sbtkSourceJson = root.assetJson("/sbtk_util/sbtk_util.config")
  self.sbtkCraftingMatConfig = sbtkSourceJson["sbtkCraftingMatConfig"]
end

function update(dt)
  local matItem1 = world.containerItemAt(entity.id(), 0)
  if matItem1 and self.sbtkCraftingMatConfig[matItem1.name] then
    -- eg "ironbar" sets to sbtk "iron" material type
    storage.currentMaterial.material = self.sbtkCraftingMatConfig[matItem1.name]
    storage.currentMaterial.count = matItem1.count
  else
    storage.currentMaterial = {}
  end
  --sb.logInfo(sb.print(storage.currentMaterial))
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