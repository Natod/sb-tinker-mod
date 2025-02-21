function build(directory, config, parameters, level, seed)

  local matType = config.sbtkData.material
  local partType = config.sbtkData.partType

  local sbtkMatTable = root.assetJson("/sbtk_util/sbtk_util.json")["sbtkToolMatConfig"][matType]
  local sbtkPartTable = root.assetJson("/sbtk_util/sbtk_util.json")["sbtkPartConfig"][partType]
  local sbtkPartInfo = sbtkMatTable.partsConfig[partType]
  --sb.logInfo(sb.print(sbtkPartInfo))
  
  local baseColors = root.assetJson("/sbtk_util/sbtk_util.json")["baseColors"]
  local matColors = sbtkMatTable.colors

  local shortdesc = sbtkMatTable.label .. " " .. sbtkPartTable.label

  local desc = string.format("Material: ^#%s;", sbtkMatTable.textColor) .. sbtkMatTable.desc .. 
    "^reset;\n" .. sbtkPartInfo.desc .. 
    "\nDamage: " .. sbtkPartInfo.damage

  local img = sbtkPartTable.image .. string.format(
    "?replace;%s=%s;%s=%s;%s=%s;%s=%s;%s=%s",
    baseColors[1], matColors[1], --darkest
    baseColors[2], matColors[2],
    baseColors[3], matColors[3],
    baseColors[4], matColors[4], --lightest
    baseColors[5], matColors[5] --glow outline
  )

  parameters.shortdescription = shortdesc
  parameters.description = desc
  config.inventoryIcon = img

  parameters.sbtkPartInfo = sbtkPartInfo

  return config, parameters
end