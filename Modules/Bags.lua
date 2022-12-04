local LDB = LibStub("LibDataBroker-1.1")

local dataObj = LDB:NewDataObject("BU:Bags", {
    type = "data source",
    icon = 133633,
    text = "0/0",
    OnTooltipShow = function() end,
    OnClick = function(...)
        ToggleAllBags()
    end,
})

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("BAG_UPDATE_DELAYED")
f:SetScript("OnEvent", function()
    local freeSlots, allSlots = 0, 0
    for i = 0, 5 do
        freeSlots = freeSlots + #C_Container.GetContainerFreeSlots(i)
        allSlots = allSlots + C_Container.GetContainerNumSlots(i)
    end
    dataObj.text = freeSlots.."/"..allSlots
end)