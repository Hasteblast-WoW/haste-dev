if HasteDevDB == nil then
    --@class HasteDevDB
    --@param developerMode boolean
    HasteDevDB = {
        developerMode = false
    }
end

---@param enabled boolean
local function setDeveloperMode(enabled)
    assert(type(enabled) == "boolean", "setDeveloperMode was called without a boolean argument")
    if enabled then
        -- TODO: Create lua logging library
        print("[haste-dev] Enabling developer mode...")
        SetCVar("scriptErrors", 1) -- Set lua error output
        print("[haste-dev] Current build version: ", select(4, GetBuildInfo()))
        HasteDevDB.developerMode = true
        print("[haste-dev] Enabled developer mode.")
    else
        print("[haste-dev] Disabling developer mode...")
        HasteDevDB.developerMode = false
        SetCVar("scriptErrors", 0)
        print("[haste-dev] Disabled developer mode.")
    end
end

SLASH_HASTE_DEV1 = '/haste-dev';
function SlashCmdList.HASTE_DEV(msg, editBox)
    if msg == "on" or msg == "off" then
        setDeveloperMode(msg == "on")
    end
end

local f = CreateFrame("Frame", "DeveloperFrame")
function f:OnEvent(event, ...)
    assert(type(HasteDevDB.developerMode) == "boolean", "developerMode was set to a non-boolean value")
    if HasteDevDB.developerMode then
        self[event](self, event, ...)
    end
end

function f:ADDON_LOADED(event, addOnName)
	print(event, addOnName)
end

function f:PLAYER_ENTERING_WORLD(event, isLogin, isReload)
    print(event, isLogin, isReload)
end

function f:CHAT_MSG_CHANNEL(event, text, playerName, _, channelName)
	print(event, text, playerName, channelName)
end

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("CHAT_MSG_CHANNEL")
f:SetScript("OnEvent", f.OnEvent)
