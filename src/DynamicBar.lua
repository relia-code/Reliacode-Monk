--- 10.03.2019
--- 03.07.2020 Updated locals
--- Modified https://github.com/arieh/TellMeWhen_Script_Tools/blob/master/modules/Dynamic_Bar.lua

local _G = _G

local TMW = _G.TMW
local TMW_ST = _G.TMW_ST
if not TMW or TMW_ST then
    return
end

local DogTag = _G.LibStub("LibDogTag-3.0", true)
local L = TMW.L

--- CORE
_G.TMW_Script_Tools =
    _G.LibStub("AceAddon-3.0"):NewAddon({debug = false}, "TMW_Script_Tools", "AceEvent-3.0", "AceConsole-3.0")
_G.TMWST = _G.TMW_Script_Tools
_G.TMW_ST = _G.TMW_Script_Tools

local TMW_ST = _G.TMW_Script_Tools

TMW_ST.ScriptTexts = {}

TMW:RegisterCallback("TMW_ST_VARIABLE_MODIFIED", DogTag.FireEvent, DogTag)

function TMW_ST:SetScriptText(name, text)
    TMW_ST.ScriptTexts[name] = text
    TMW:Fire("TMW_ST_VARIABLE_MODIFIED", name)
end

if DogTag then
    DogTag:AddTag(
        "TMW",
        "ST_GetScriptText",
        {
            code = function(name)
                return TMW_ST.ScriptTexts[name] or ""
            end,
            arg = {
                "name",
                "string",
                "@req"
            },
            ret = "string",
            doc = "Return the value of a script variable",
            example = '[ST_GetScriptText("var1")] => "my var"',
            events = "TMW_ST_VARIABLE_MODIFIED",
            category = "Userland"
        }
    )
end

function TMW_ST:printDebug(text, var1, var2, var3)
    if TMW_ST.debug then
        TMW_ST:Print(text, var1 or "", var2 or "", var3 or "")
    end
end

--- Counters fragment
function TMW_ST:InitCounter(name, initialValue)
    TMW_ST:printDebug("Initializing Counter", name, initialValue)
    TMW.COUNTERS[name] = initialValue or 0
end

function TMW_ST:UpdateCounter(name, value)
    TMW_ST:printDebug("Setting Counter Value", name, value)
    TMW.COUNTERS[name] = value
    TMW:Fire("TMW_COUNTER_MODIFIED", name)
end

function TMW_ST:GetCounter(name)
    return TMW.COUNTERS[name]
end

---

local Type = TMW.Classes.IconType:New("dynamicbar")
Type.name = "Dynamic Bar"
Type.desc = "A Bar that can be controlled by LUA scripts"
Type.menuIcon = "Interface/Icons/inv_box_04"
Type.hasNoGCD = true
Type.menuSpaceBefore = true

Type:SetAllowanceForView("icon", false)

Type:UsesAttributes("value, maxValue, valueColor")
Type:UsesAttributes("state")
Type:UsesAttributes("texture")
Type:UsesAttributes("auraSourceUnit, auraSourceGUID")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("stack, stackText")

local STATE_SHOW = TMW.CONST.STATE.DEFAULT_SHOW

Type:RegisterConfigPanel_XMLTemplate(
    165,
    "TellMeWhen_IconStates",
    {
        [STATE_SHOW] = {order = 1, text = "|cFF00FF00" .. L["DEFAULT"]}
    }
)

local function Value_OnUpdate(icon)
    local script_values = icon.script_values

    if not script_values.triggerFunc(icon) then
        return
    end

    if script_values.changed then
        icon:SetInfo(
            "state; value, maxValue, valueColor; start, duration; stack, stackText",
            STATE_SHOW,
            script_values.current,
            script_values.max,
            script_values.colors,
            script_values.duration.start,
            script_values.duration.duration,
            script_values.stacks.stacks,
            script_values.stacks.text
        )

        script_values.changed = false
    end
end

function Type:Setup(icon)
    icon:SetInfo("texture", "Interface/Icons/inv_box_04")

    icon:SetUpdateMethod("auto")

    icon:SetUpdateFunction(Value_OnUpdate)

    icon.script_values = {
        max = 100,
        current = 0,
        changed = true,
        duration = {
            start = 0,
            duration = 0
        },
        stacks = {
            stacks = 0,
            text = 0
        },
        colors = {"#ffff1200", "#ffffff00", "#ff00ff00"},
        show = true,
        triggerFunc = function()
            return true
        end
    }

    local values = icon.script_values

    function icon:setMaxValue(value)
        values.max = value
        values.changed = true
    end

    function icon:setCurrentValue(value)
        values.current = value

        values.changed = true
    end

    function icon:setBarColors(startColor, midColor, lastColor)
        local start = startColor or values.colors[0]
        local mid = midColor or values.colors[1]
        local last = lastColor or values.colors[2]

        values.colors = {start, mid, last}

        values.changed = true
    end

    function icon:startDurationTracking(duration)
        values.duration.start = TMW.time
        values.duration.duration = duration
        values.changed = true
    end

    function icon:setStacks(stacks, text)
        values.stacks.stacks = stacks

        if (text ~= nil) then
            values.stacks.text = text
        else
            values.stacks.text = stacks
        end

        values.changed = true
    end

    function icon:registerTriggerFunction(fnc)
        values.triggerFunc = fnc
    end

    icon:Update()
end

TMW:RegisterCallback(
    "TMW_CONFIG_ICON_TYPE_CHANGED",
    function(event, icon, type, oldType)
        local icspv = icon:GetSettingsPerView()

        if type == Type.type and oldType == "" then
            icon:GetSettings().CustomTex = "NONE"
            local layout = TMW.TEXT:GetTextLayoutForIcon(icon)

            if layout == "bar1" or layout == "bar2" then
                icspv.Texts[1] = "[(Value / ValueMax * 100):Round:Percent]"
                icspv.Texts[2] = '[Value:Short "/" ValueMax:Short]'
            end
        end
    end
)

Type:Register(157)
