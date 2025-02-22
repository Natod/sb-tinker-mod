function build(directory, config, parameters, level, seed)

  local sbtkSourceJson = "/sbtk_util/sbtk_util.config"
  local matType = parameters.sbtkData.material
  local partType = parameters.sbtkData.partType

  local sbtkMatTable = root.assetJson(sbtkSourceJson)["sbtkToolMatConfig"][matType]
  local sbtkPartTable = root.assetJson(sbtkSourceJson)["sbtkPartConfig"][partType]
  local sbtkPartInfo = sbtkMatTable.partsConfig[partType] or root.assetJson(sbtkSourceJson)["partsConfigDefault"][partType]
  --sb.logInfo(sb.print(sbtkPartInfo))
  
  local baseColors = root.assetJson(sbtkSourceJson)["baseColors"]
  local matColors = sbtkMatTable.colors

  local shortdesc = sbtkMatTable.label .. " " .. sbtkPartTable.label

  local desc = string.format("Material: ^#%s;", sbtkMatTable.textColor) .. sbtkMatTable.desc .. 
    ((partType == "toolcore") and ("\nTier " .. sbtkMatTable.tier) or "") ..
    "^reset;\n" .. sbtkPartInfo.desc .. 
    ((sbtkPartInfo.damage ~= nil) and ("\nDamage: " .. sbtkPartInfo.damage) or "")

  local img = sbtkPartTable.inventoryIcon .. string.format(
    "?replace;%s=%s;%s=%s;%s=%s;%s=%s;%s=%s;%s=%s",
    baseColors[1], matColors[1], --darkest
    baseColors[2], matColors[2], 
    baseColors[3], matColors[3],
    baseColors[4], matColors[4],
    baseColors[5], matColors[5], --lightest
    baseColors[6], matColors[6] --glow outline
  )

  parameters.shortdescription = shortdesc
  parameters.description = desc
  config.inventoryIcon = img

  parameters.sbtkTier = sbtkMatTable.tier
  parameters.sbtkPartInfo = sbtkPartInfo

  return config, parameters
end