local LDB = LibStub("LibDataBroker-1.1")

local dataObj = LDB:NewDataObject("BU:Location", {
    type = "data source",
    text = "",
    OnTooltipShow = function() end,
})

local function UpdateZoneText()
    local zoneType = GetZonePVPInfo()
    local zoneLabel = ""
    local zoneColor = "|cffffffff"

    if zoneType == "combat" or zoneType == "arena" or zoneType == "hostile" then
		zoneColor = "|cffff0000"
        zoneLabel = HOSTILE
	elseif zoneType == "contested" or zoneType == nil then
		zoneColor = "|cffffcc00"
        zoneLabel = "争夺中的领土"
	elseif zoneType == "friendly" then
        zoneColor = "|cff80ff80"
		zoneLabel = FRIENDLY
	elseif zoneType == "sanctuary" then
		zoneColor = "|cff69ccf0"
        zoneLabel = "安全区域"
	end

    local subZone = GetSubZoneText() or ""
	local zone = GetRealZoneText() or ""

    -- if subZone ~= "" then
    --     dataObj.text = string.format(zoneColor.."%s: %s (%s)", zone, subZone, zoneLabel)
    -- else
    --     dataObj.text = string.format(zoneColor.."%s (%s)", zone, zoneLabel)
    -- end
    
    if subZone ~= "" then
        dataObj.text = string.format(zoneColor.."%s: %s", zone, subZone)
    else
        dataObj.text = zoneColor..zone
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("ZONE_CHANGED")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:SetScript("OnEvent", function()
    UpdateZoneText()
end)