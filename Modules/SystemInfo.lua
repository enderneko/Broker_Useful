local LDB = LibStub("LibDataBroker-1.1")

local dataObj = LDB:NewDataObject("BU:SystemInfo", {
    type = "data source",
    text = "W:27ms H:27ms 60fps",
    OnTooltipShow = function() end,
})

local netStat = ""
local fps = ""
local memory = ""

-- netStat
local function Color(n)
    if n < 40 then
        return "|cff69ccf0"..n.."|r"
    elseif n < 120 then
        return "|cff00ff00"..n.."|r"
    elseif n < 250 then
        return "|cffffcc00"..n.."|r"
    elseif n < 400 then
        return "|cffff8000"..n.."|r"
    elseif n < 1200 then
        return "|cffff0000"..n.."|r"
    else
        return "|cffff00ff"..n.."|r"
    end
end

local function UpdateNetStat()
    local home, world = select(3, GetNetStats())
    netStat = "|cffffffffW:|r"..Color(world).."ms |cffffffffH:|r"..Color(home).."ms"
    dataObj.text = netStat.." "..fps.." "..memory
end
C_Timer.NewTicker(10, UpdateNetStat)

-- fps
local function UpdateFPS()
    fps = ceil(GetFramerate())

    if fps < 18 then
        fps = "|cffff0000"..fps.."|rfps"
    elseif fps < 24 then
        fps = "|cffff8000"..fps.."|rfps"
    elseif fps < 30 then
        fps = "|cffffcc00"..fps.."|rfps"
    elseif fps < 100 then
        fps = "|cff00ff00"..fps.."|rfps"
    elseif fps < 160 then
        fps = "|cff69ccf0"..fps.."|rfps"
    elseif fps < 200 then
        fps = "|cfff060f0"..fps.."|rfps"
    else
        fps = "|cffff00ff"..fps.."|rfps"
    end

    dataObj.text = netStat.." "..fps.." "..memory
end
C_Timer.NewTicker(2, UpdateFPS)

-- memory
local function FormatMemory(n)
    local units, i = {"kb", "mb", "gb"}, 1
    n = max(n,0)
    while n > 1000 do
        n = n / 1024
        i = i + 1
    end
    return tonumber(("%0."..(i == 1 and 0 or 1).."f"):format(n)), units[i]
end

local memoryUpdater = CreateFrame("Frame")
memoryUpdater:Hide()

local lastUpdate, elapsedTime = 0, 0
local addonIndex, addonNum = 1, 0
local total, unit = 0

memoryUpdater:SetScript("OnUpdate", function(self, elapsed)
    if addonIndex > addonNum then
        memoryUpdater:Hide()

        total, unit = FormatMemory(total)
        memory = "|cffffffff"..total.."|r"..unit
        dataObj.text = netStat.." "..fps.." "..memory

        return
    end

    elapsedTime = elapsedTime + elapsed
    if elapsedTime > 0.02 then
        elapsedTime = 0
    
        total = total + GetAddOnMemoryUsage(addonIndex)
        -- print(addonIndex, total)
        addonIndex = addonIndex + 1
    end
end)

local function UpdateMemory()
    if GetTime() - lastUpdate < 59 then return end
    lastUpdate = GetTime()
    addonIndex = 1
    memoryUpdater:Show()
end
hooksecurefunc("UpdateAddOnMemoryUsage", UpdateMemory)
C_Timer.NewTicker(60, function()
    if InCombatLockdown() or IsFalling() then return end
    UpdateAddOnMemoryUsage()
end)

-- update now
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
    UpdateNetStat()
    UpdateFPS()
    addonNum = GetNumAddOns()
    UpdateAddOnMemoryUsage()
end)