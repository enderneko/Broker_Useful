local LDB = LibStub("LibDataBroker-1.1")

local DATE_FORMAT = "%m/%d %a %H:%M:%S"

local dataObj = LDB:NewDataObject("BU:DateAndTime", {
    type = "data source",
    text = date(DATE_FORMAT),
    OnTooltipShow = function() end,
    OnClick = function(self, button)
        if button == "LeftButton" then
            ToggleTimeManager()
        elseif button == "RightButton" then
            ToggleCalendar()
        end
    end,
})

C_Timer.NewTicker(1, function()
    dataObj.text = date(DATE_FORMAT)
end)