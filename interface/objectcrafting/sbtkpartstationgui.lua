require "/scripts/vec2.lua"
require "/scripts/util.lua"
require "/scripts/interp.lua"


function init()
    --local steamdecks = require "/objects/tinkersfurnace/tinkersfurnace.lua".storage.steamdeckcount
    self.defaultText2 = config.getParameter("gui").lblText2.value
    self.defaultText3 = config.getParameter("gui").lblText3.value
    self.materialData = {}
    self.reqMatCount = nil
    self.canCraft = false

    local sbtkSourceJson = root.assetJson("/sbtk_util/sbtk_util.config")
    self.sbtkToolMatConfig = sbtkSourceJson["sbtkToolMatConfig"]
    self.sbtkPartConfig = sbtkSourceJson["sbtkPartConfig"]
    self.sbtkCraftingMatConfig = sbtkSourceJson["sbtkCraftingMatConfig"]
    --self.canvas = widget.bindCanvas("canvas")
    self.selectedPartTable = nil
    self.selectedPartID = nil
    local backTipBorder = {230,230,230,255}
    --self.canvas:drawRect({10, 10, 10 + steamdecks, 20}, backTipBorder)
    --ButtonGroupWidget

    
    self.itemList = "itemScrollArea.itemList"
    --self.classes = config.getParameter("classes")
    
    self.partTypeList = {}
    widget.setButtonEnabled("btnConfirm", false)
    
    --self.sbtkPartConfig = {}
    self.selectedItem = nil
    populateItemList(true)
end


function update(dt)
    --self.canvas:clear()

    self.mat = world.containerItemAt(pane.containerEntityId(), 0)
    if self.mat and self.sbtkCraftingMatConfig[self.mat.name] then
        -- eg "ironbar" sets to sbtk "iron" material type
        self.materialData.material = self.sbtkCraftingMatConfig[self.mat.name]
        self.materialData.count = self.mat.count
        if self.reqMatCount then
            self.canCraft = self.materialData.count >= self.reqMatCount
        else
            self.canCraft = false
        end
    else
        self.materialData = {}
        self.canCraft = false
    end

    if self.materialData.material and self.materialData.count then
        widget.setText(
            "lblText2", 
            self.sbtkToolMatConfig[self.materialData.material]["label"]
        )
        widget.setText(
            "lblText3", 
            ((self.canCraft or self.selectedItem == nil) and "" or "^red;") ..
            self.materialData.count .. "^reset;" ..
            (self.reqMatCount ~= nil and ("/" .. self.reqMatCount) or "") 
        )
    else
        widget.setText("lblText2", self.defaultText2)
        widget.setText("lblText3", self.defaultText3)
    end
    --self.canvas:drawText("Steam Deck", {position={math.random(1,99), math.random(1,99)}},20,{math.random(1,255), math.random(1,255),math.random(1,255),255})
    --self.canvas:drawLine(vec2.sub(vec2.mul(line[1], tileSize), screenPos), vec2.sub(vec2.mul(line[2], tileSize), screenPos), anchorColor, 2)
    
    if self.selectedPartTable and self.selectedPartID then
        local previewMaterial = self.materialData.material or "preview"
        local instOutputItem = root.createItem({       
            name = "sbtkpart",
            parameters = {
                sbtkData = {
                    material = previewMaterial,
                    partType = self.selectedPartID
                }
            }
        })
        widget.setItemSlotItem("outputPreview", instOutputItem)
    else
        widget.setItemSlotItem("outputPreview", nil)
    end

    
    if self.selectedPartTable and self.selectedPartID and 
    self.materialData.material and self.canCraft 
    and world.containerItemAt(pane.containerEntityId(), 1) == nil then
        widget.setButtonEnabled("btnConfirm", true)
    else
        widget.setButtonEnabled("btnConfirm", false)
    end
end


function populateItemList(forceRepop)
    --sb.logInfo("---------------ran populateItemList")
  
    --local upgradeableWeaponItems = player.itemsWithTag("weapon")
    --[[
    local classList = {
      {name="Driller", class="driller"}
    }
    --]]
    for k,v in pairs(self.sbtkPartConfig) do 
        local instItem = root.createItem({       
            name = "sbtkpart",
            parameters = {
                sbtkData = {
                    material = "preview",
                    partType = k
                },
                rarity = "Common"
            }
        })
        --sb.logInfo(sb.print(instItem))
        self.partTypeList[k] = instItem
    end
  
    --if forceRepop then
    --self.sbtkPartConfig
    widget.clearListItems(self.itemList)
    widget.setButtonEnabled("btnConfirm", false)

    local showEmptyLabel = true

    for key, value in pairs(self.sbtkPartConfig) do
        showEmptyLabel = false

        local listItem = string.format("%s.%s", self.itemList, widget.addListItem(self.itemList))

        widget.setText(string.format("%s.itemName", listItem), value.label)
        widget.setItemSlotItem(string.format("%s.itemIcon", listItem), self.partTypeList[key])

        widget.setData(listItem,
            {
            index = key,
            value = value["class"]
            })

        widget.setVisible(string.format("%s.unavailableoverlay", listItem), false)
        --end

        self.selectedItem = nil
        showItem(nil)

        widget.setVisible("emptyLabel", showEmptyLabel)
    end
  end
  
  function showItem(item, text)
    local enableButton = false
    if item then
      --widget.setText("partTypeDisplay", string.format("%s", text))
    end
    widget.setButtonEnabled("btnConfirm", true)
  end
  
  function itemSelected()
    local listItem = widget.getListSelected(self.itemList)
    self.selectedItem = listItem
  
    if listItem then
      local itemData = widget.getData(string.format("%s.%s", self.itemList, listItem))
      local shownItem = self.sbtkPartConfig[itemData.index]
      --sb.logInfo(sb.print(itemData))
      self.selectedPartID = itemData.index
      self.selectedPartTable = self.sbtkPartConfig[itemData.index]
      showItem(shownItem, self.selectedPartTable["label"])
      self.reqMatCount = self.selectedPartTable["matCost"]
      
    end
  end
  
  function confirm()

    --[[
    local itemToConsume = root.createItem({       
        name = self.mat.name,
        parameters = self.mat.parameters,
        count = self.reqMatCount
    })
    ]]
    --sb.logInfo(sb.print(world.containerConsume(pane.containerEntityId(), itemToConsume)))

    --consumes properly but returns nil. sb thinks it isn't a container because
    -- item container interface shenanigans must be done server-side
    --world.containerConsume(pane.containerEntityId(), itemToConsume)

    --this is just easier than using world.containerConsume
    --because containerConsumeAt only considers the first slot


    --world.containerConsumeAt(pane.containerEntityId(), 0, self.reqMatCount)

    local outputItem = root.createItem({       
        name = "sbtkpart",
        parameters = {
            sbtkData = {
                material = self.materialData.material,
                partType = self.selectedPartID
            }
        },
        count = 1
    })

    world.sendEntityMessage(pane.containerEntityId(), "sbtkPartStationCraft", self.reqMatCount, outputItem)
    --sb.logInfo(sb.print(outputItem))
    --world.containerPutItemsAt(pane.containerEntityId(), outputItem, 1)

  end
  