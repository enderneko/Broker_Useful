local LDB = LibStub("LibDataBroker-1.1")

local dataObj = LDB:NewDataObject("BU:Durability", {
    type = "data source",
    text = "",
    OnTooltipShow = function() end,
})

local slots = {1, 3, 5, 6, 7, 8, 9, 10, 16, 17}

local function GetThresholdColor(percent)
    if percent < 0 then
        return 1, 0, 0
    elseif percent <= 0.5 then
        return 1, percent * 2, 0
    elseif percent >= 1 then
        return 0, 1, 0
    else
        return 2 - percent * 2, 1, 0
    end
end

local function UpdateDurability()
    local avg = 0
    local lowest = 100

    for _, slot in pairs(slots) do
        local v1, v2 = GetInventoryItemDurability(slot)
        v1, v2 = tonumber(v1), tonumber(v2)

        local percent
        if v1 and v2 then
            percent = v1 / v2
        else
            percent = 1
        end

        if percent < lowest then
            lowest = percent
        end
        
        avg = avg + percent
    end

    avg = avg / #slots

    local avg = CreateColor(GetThresholdColor(avg)):WrapTextInColorCode(ceil(avg * 100)).."%"
    local lowest = CreateColor(GetThresholdColor(lowest)):WrapTextInColorCode(ceil(lowest * 100)).."%"

    dataObj.text = avg.." "..lowest
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
f:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
f:SetScript("OnEvent", function()
    UpdateDurability()
end)