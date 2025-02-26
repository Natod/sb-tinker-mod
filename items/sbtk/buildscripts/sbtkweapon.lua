require "/scripts/util.lua"
require "/scripts/vec2.lua"
require "/scripts/versioningutils.lua"
require "/scripts/staticrandom.lua"
require "/items/buildscripts/abilities.lua"

function build(directory, config, parameters, level, seed)

  local sbtkSourceJson = root.assetJson("/sbtk_util/sbtk_util.config")
  local sbtkToolMatConfig = sbtkSourceJson.sbtkToolMatConfig
  local sbtkToolType = parameters.sbtkToolType or config.sbtkToolType
  local sbtkToolPartConfig = sbtkSourceJson.sbtkToolPartConfig[sbtkToolType]
  local sbtkConfig = parameters.sbtkConfig or config.sbtkConfig

  local configParameter = function(keyName, defaultValue)
    if parameters[keyName] ~= nil then
      return parameters[keyName]
    elseif config[keyName] ~= nil then
      return config[keyName]
    else
      return defaultValue
    end
  end

  --[[
  local sbtkToolParam = function(key, default)
    if parameters[key] ~= nil then
      return parameters[key]
    else
      return default
    end
  end
  --]]
  
  -- overwrite the config with whatever was in the config for that part

  local dmgMult = 1
  local dmgFlat = 0
  for k,v in pairs(sbtkToolPartConfig.parts) do 
    local _pType = v[1]
    local _pName = _pType .. "." .. v[2]
    local _pMat = v[3]
    local _pMatTable = sbtkToolMatConfig[sbtkConfig.partMaterials[_pName]]

    local _pdmgMult = _pMatTable.partsConfig[_pType]["dmgMult"]
    if _pdmgMult then
      dmgMult = dmgMult * _pdmgMult
    end

    local _pdmgFlat = _pMatTable.partsConfig[_pType]["dmgFlat"]
    if _pdmgFlat then
      dmgFlat = dmgFlat + _pdmgFlat
    end
    parameters.description = dmgMult .. dmgFlat
  end


  --[[
  for k,v in pairs(sbtkToolPartConfig) do 
    config[k] = v
    parameters[k] = v
  end
  ]]

  if level then
    parameters.level = level
  end
  
  setupAbility(config, parameters, "primary")
  setupAbility(config, parameters, "alt")

  -- elemental type and config (for alt ability)
  local elementalType = configParameter("elementalType", "physical")
  replacePatternInData(config, nil, "<elementalType>", elementalType)
  if config.altAbility and config.altAbility.elementalConfig then
    util.mergeTable(config.altAbility, config.altAbility.elementalConfig[elementalType])
  end

  -- calculate damage level multiplier
  config.damageLevelMultiplier = root.evalFunction("weaponDamageLevelMultiplier", configParameter("level", 1))

  -- palette swaps
  config.paletteSwaps = ""
  if config.palette then
    local palette = root.assetJson(util.absolutePath(directory, config.palette))
    local selectedSwaps = palette.swaps[configParameter("colorIndex", 1)]
    for k, v in pairs(selectedSwaps) do
      config.paletteSwaps = string.format("%s?replace=%s=%s", config.paletteSwaps, k, v)
    end
  end
  if type(config.inventoryIcon) == "string" then
    config.inventoryIcon = config.inventoryIcon .. config.paletteSwaps
  else
    for i, drawable in ipairs(config.inventoryIcon) do
      if drawable.image then drawable.image = drawable.image .. config.paletteSwaps end
    end
  end

  -- gun offsets
  if config.baseOffset then
    construct(config, "animationCustom", "animatedParts", "parts", "middle", "properties")
    config.animationCustom.animatedParts.parts.middle.properties.offset = config.baseOffset
    if config.muzzleOffset then
      config.muzzleOffset = vec2.add(config.muzzleOffset, config.baseOffset)
    end
  end

  -- populate tooltip fields
  if config.tooltipKind ~= "base" then
    config.tooltipFields = {}
    config.tooltipFields.levelLabel = util.round(configParameter("level", 1), 1)
    config.tooltipFields.dpsLabel = util.round((config.primaryAbility.baseDps or 0) * config.damageLevelMultiplier, 1)
    config.tooltipFields.speedLabel = util.round(1 / (config.primaryAbility.fireTime or 1.0), 1)
    config.tooltipFields.damagePerShotLabel = util.round((config.primaryAbility.baseDps or 0) * (config.primaryAbility.fireTime or 1.0) * config.damageLevelMultiplier, 1)
    config.tooltipFields.energyPerShotLabel = util.round((config.primaryAbility.energyUsage or 0) * (config.primaryAbility.fireTime or 1.0), 1)
    if elementalType ~= "physical" then
      config.tooltipFields.damageKindImage = "/interface/elements/"..elementalType..".png"
    end
    if config.primaryAbility then
      config.tooltipFields.primaryAbilityTitleLabel = "Primary:"
      config.tooltipFields.primaryAbilityLabel = config.primaryAbility.name or "unknown"
    end
    if config.altAbility then
      config.tooltipFields.altAbilityTitleLabel = "Special:"
      config.tooltipFields.altAbilityLabel = config.altAbility.name or "unknown"
    end
  end

  -- set price
  -- TODO: should this be handled elsewhere?
  config.price = (config.price or 0) * root.evalFunction("itemLevelPriceMultiplier", configParameter("level", 1))



  return config, parameters
end