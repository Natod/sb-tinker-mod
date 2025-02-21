function build(directory, config, parameters, level, seed)

  local matType = config.sbtkData.material
  local partType = config.sbtkData.partType

  local sbtkMatTable = root.assetJson("/sbtk_util/sbtk_util.json")["sbtkToolMatConfig"][matType]
  local sbtkPartTable = root.assetJson("/sbtk_util/sbtk_util.json")["sbtkPartConfig"][partType]
  
  local baseColors = root.assetJson("/sbtk_util/sbtk_util.json")["baseColors"]
  local matColors = sbtkMatTable.colors

  parameters.shortdescription = sbtkMatTable.label .. " " .. sbtkPartTable.label
  parameters.description = sbtkMatTable.desc

  local img = sbtkPartTable.image .. string.format(
    "?replace;%s=%s;%s=%s;%s=%s;%s=%s;%s=%s",
    baseColors[1], matColors[1], --darkest
    baseColors[2], matColors[2],
    baseColors[3], matColors[3],
    baseColors[4], matColors[4], --lightest
    baseColors[5], matColors[5] --glow outline
  )
  config.inventoryIcon = img

  return config, parameters
end