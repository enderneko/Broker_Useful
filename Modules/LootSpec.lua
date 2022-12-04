local LDB = LibStub("LibDataBroker-1.1")
local LibQTip = LibStub("LibQTip-1.0")

local dataObj = LDB:NewDataObject("BU:LootSpec", {
    type = "data source",
    icon = "Interface\\Icons\\INV_Misc_QuestionMark",
    text = "LootSpec",
    label = "拾取",
})
local tooltip

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
f:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    if tooltip then
        tooltip:Hide()
    end

    local lootSpecID = GetLootSpecialization()

    local name, icon, _
    if lootSpecID == 0 then
        _, name, _, icon = GetSpecializationInfo(GetSpecialization())
    else
        _, name, _, icon = GetSpecializationInfoForSpecID(lootSpecID)
    end

    if not name then
        name = "None"
    end

    if not icon then
        icon = "Interface\\Icons\\INV_Misc_QuestionMark"
    end

    if lootSpecID == 0 then
        name = name .. "*"
    end

    dataObj.text = name
    dataObj.icon = icon
end)



local function AddLine(id, icon, name, active)
    local line = tooltip:AddLine()
    local radio = "|T:0|t"

    if active then
        radio = "|TInterface\\Buttons\\UI-RadioButton:8:8:0:0:64:16:19:28:3:12|t"
    end

    tooltip:SetCell(line, 1, radio)
    tooltip:SetCell(line, 2, "|T" .. icon .. ":14|t")
    tooltip:SetCell(line, 3, name)
    tooltip:SetLineScript(line, "OnMouseUp", function()
        SetLootSpecialization(id)
        LibQTip:Release(tooltip)
    end)
end

function dataObj:OnEnter()
    GameTooltip:Hide()
end

function dataObj:OnClick()
    tooltip = LibQTip:Acquire("BULootSpecTooltip", 3, "CENTER", "LEFT", "LEFT")
    tooltip:Clear()

    local lootSpecID = GetLootSpecialization()
    local specIndex = GetSpecialization()
    local name, icon = "None", "Interface\\Icons\\INV_Misc_QuestionMark"
    local specID

    if specIndex then
        specID, name, _, icon = GetSpecializationInfo(specIndex)
    end

    AddLine(0, icon, format(LOOT_SPECIALIZATION_DEFAULT, name), lootSpecID == 0)

    for i = 1, GetNumSpecializations() do
        specID, name, _, icon = GetSpecializationInfo(i)
        AddLine(specID, icon, name, lootSpecID == specID)
    end


    tooltip:SetAutoHideDelay(0.1, self)
    tooltip:SmartAnchorTo(self)
    tooltip:Show()
end

