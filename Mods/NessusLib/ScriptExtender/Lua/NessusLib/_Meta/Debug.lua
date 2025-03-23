---@class Debug: MetaClass
---@field Prefix string
---@field Machine "S"|"C"
---@field Beautify boolean
---@field StringifyInternalTypes boolean
---@field IterateUserdata boolean
---@field AvoidRecursion boolean
---@field LimitArrayElements integer
---@field LimitDepth integer
---@field FontColor vec3
---@field BackgroundColor vec3
---@field ApplyColor boolean
---@field MaxDepth integer
---@field RunningHue integer
Debug = _Class:Create("Debug", nil, {
    Prefix = "NessusLib",
    Machine = Ext.IsServer() and "S" or "C",
    Beautify = true,
    StringifyInternalTypes = true,
    IterateUserdata = true,
    AvoidRecursion = true,
    LimitArrayElements = 3,
    LimitDepth = 1,
    FontColor = {192, 192, 192},
    BackgroundColor = {12, 12, 12},
    ApplyColor = false,
    MaxDepth = 64,
    RunningHue = 0,
})

---@param h integer hue
---@param s integer saturation
---@param v integer value
---@return integer r red
---@return integer g green
---@return integer b blue
local function HSVToRGB(h, s, v)
    local c = v * s
    local hp = h / 60
    local x = c * (1 - math.abs(hp % 2 - 1))
    local r, g, b = 0, 0, 0

    if     hp >= 0 and hp <= 1 then r, g, b = c, x, 0
    elseif hp >= 1 and hp <= 2 then r, g, b = x, c, 0
    elseif hp >= 2 and hp <= 3 then r, g, b = 0, c, x
    elseif hp >= 3 and hp <= 4 then r, g, b = 0, x, c
    elseif hp >= 4 and hp <= 5 then r, g, b = x, 0, c
    elseif hp >= 5 and hp <= 6 then r, g, b = c, 0, x
    end

    local m = v - c
    return math.floor((r + m) * 255), math.floor((g + m) * 255), math.floor((b + m) * 255)
end

---@param r integer 0-255
---@param g integer 0-255
---@param b integer 0-255
function Debug:SetFontColor(r, g, b)
    self.FontColor = {r or 0, g or 0, b or 0}
    --self:Print("Changed Font Color to %s %s %s", r, g, b)
end

---@param r integer 0-255
---@param g integer 0-255
---@param b integer 0-255
function Debug:SetBackgroundColor(r, g, b)
    self.BackgroundColor = {r or 0, g or 0, b or 0}
    --self:Print("Changed Background Color to %s %s %s", r, g, b)
end

---@param text string
---@param fontColor? vec3 Override the current font color
---@param backgroundColor? vec3 Override the current background color
---@return string
function Debug:Colorize(text, fontColor, backgroundColor)
    local fontR, fontG, fontB = table.unpack(fontColor or self.FontColor)
    local bgR, bgG, bgG = table.unpack(backgroundColor or self.BackgroundColor)
    return string.format("\x1b[38;2;%s;%s;%s;48;2;%s;%s;%sm%s", fontR, fontG, fontB, bgR, bgG, bgG, text)
end

function Debug:ToggleApplyColor()
    self.ApplyColor = not self.ApplyColor
    self:Print("Applying Color: %s", self.ApplyColor)
end

---@vararg any
function Debug:Print(...)
    local s = string.format("[%s] %s: ", self.Machine, self.Prefix)
    if self.ApplyColor then
        s = self:Colorize(s)
    end

    local f
    if #{...} <= 1 then
        f = tostring(...)
    else
        f = string.format(...)
    end

    Ext.Utils.Print(s..f)
end

function Debug:PrintWarning(...)
    local s = string.format("[%s] %s[%s]: ", self.Machine, self.Prefix, "WARN")
    if self.ApplyColor then
        s = self:Colorize(s)
    end

    local f
    if #{...} <= 1 then
        f = tostring(...)
    else
        f = string.format(...)
    end

    Ext.Utils.PrintWarning(s..f)
end

function Debug:PrintDebug(...)
    local s = string.format("[%s] %s[%s]:[%s] ", self.Machine, self.Prefix, "DEBUG", Ext.Utils.MonotonicTime())
    if self.ApplyColor then
        s = self:Colorize(s)
    end

    local f
    if #{...} <= 1 then
        f = tostring(...)
    else
        f = string.format(...)
    end

    Ext.Utils.Print(s..f)
end

---@param info any
---@param useOptions? boolean
---@param includeTime? boolean
function Debug:Dump(info, useOptions, includeTime)
    local s = string.format("[%s] %s[%s]: ", self.Machine, self.Prefix, "DUMP")
    if self.ApplyColor then
        s = self:Colorize(s)
    end

    if includeTime == true then
        s = string.format("%s[%s]", s, Ext.Utils.MonotonicTime())
    end

    s = s.." "

    local infoString
    if useOptions == true then
        infoString = Ext.Json.Stringify(info, {
            Beautify = self.Beautify,
            StringifyInternalTypes = self.StringifyInternalTypes,
            IterateUserdata = self.IterateUserdata,
            AvoidRecursion = self.AvoidRecursion,
            LimitArrayElements = self.LimitArrayElements,
            LimitDepth = self.LimitDepth,
            MaxDepth = self.MaxDepth,
        })
    else
        infoString = Ext.DumpExport(info)
    end
    Ext.Utils.Print(s, infoString)
end

---@param array FlashArray
---@param arrayName? string
function Debug:DumpArray(array, arrayName)
    local name = arrayName or "array"
    for i = 1, #array do
        self:Print("%s[%s]: %s", name, i, array[i])
    end
end

function Debug:RunningRainbowPrint(data, depth, includeTime)
    local pre = string.format("[%s] %s[%s]: ", self.Machine, self.Prefix, "PrintR")
    if includeTime == true then
        pre = string.format("%s[%s]", pre, Ext.Utils.MonotonicTime())
    end
    pre = pre.." "
    local infoString,full
    if type(data) == "table" or type(data) == "userdata" then
        -- treat as table and dump

        -- let norb do heavy lifting for initial longstring
        infoString = Ext.Json.Stringify(data, {
            Beautify = self.Beautify,
            StringifyInternalTypes = self.StringifyInternalTypes,
            IterateUserdata = self.IterateUserdata,
            AvoidRecursion = self.AvoidRecursion,
            LimitArrayElements = 3,
            LimitDepth = depth or 1,
            MaxDepth = self.MaxDepth,
        })
        -- shenanigans parsing that string back into a table (:oof: for hyuge strings)
        local result = {}
        for line in infoString:gmatch("([^\n]+)\n?") do
            -- select() to hopefully cut down on some overhead for convenientcount :gladge:
            local indentCount = select(2, string.gsub(line,"\t","\t"))

            local hue = (indentCount*36) % 360 -- rotations based on indent
            local r,g,b = HSVToRGB(hue, .65, 1)
            table.insert(result, self:Colorize(line, {r, g, b})) -- colorize each line
        end
        infoString = table.concat(result, "\n")
        result = nil
        full = pre..infoString
    else
        -- treat as string and print
        infoString = tostring(data)
        -- iterate running color and set
        local r,g,b = HSVToRGB(self.RunningHue,.65,1)
        self.RunningHue = (self.RunningHue + 36) % 360
        full = self:Colorize(pre..infoString, {r,g,b})
    end

    Ext.Utils.Print(full)
end

-- Create a new Debug object with your mods Name when using this Lib
-- Debug = Debug:New{Prefix = MODNAME, ApplyColor = true}

-- Short hand functions
function __P(...) Debug:SetFontColor(58, 183, 255) Debug:Print(...) end
function __Debug(...) Debug:SetFontColor(216, 106, 189) Debug:PrintDebug(...) end
function __Warn(...) Debug:SetFontColor(221, 116, 18) Debug:PrintWarning(...) end
function __D(...) Debug:SetFontColor(37, 161, 85) Debug:Dump(...) end
function __DS(...) Debug:SetFontColor(241, 177, 225) Debug:Dump(..., true) end
function __DA(...) Debug:DumpArray(...) end
-- function __RP(...) Debug:RunningRainbowPrint(..., 12, false) end
-- function __RPS(...) Debug:RunningRainbowPrint(..., 1, false) end