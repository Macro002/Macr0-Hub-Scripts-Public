-- Macr0 Hub theme -- the single source of truth for how every script looks.
--
--   loadstring(game:HttpGet(".../theme.lua"))()
--
-- Both loader.lua and freedraw.lua load this, so a colour change here reaches
-- everything without re-releasing any script. freedraw.lua carries an embedded
-- copy of these exact values, used only if this file cannot be fetched.
--
-- Named Lib rather than WindUI so it does not read as shadowing. The
-- `local x = x` idiom works (the right side resolves to the outer scope), but
-- it looks like a bug and static analysis flags it.
local Lib = _G.WindUI or WindUI
if not Lib then
    warn("[Macr0 Theme] WindUI not loaded yet")
    return false
end

-- ---------------------------------------------------------------------------
-- The three knobs worth touching.
--
-- TRANSPARENCY drives the window, popup, dialog and notification backgrounds
-- from one value, so the whole hub stays consistently see-through. Everything
-- else here is layered on top of it: panels, elements and tab strips use
-- WHITE at high transparency rather than their own greys, which is why the
-- surfaces read as glass rather than as flat boxes.
-- ---------------------------------------------------------------------------
local TRANSPARENCY = 0.12
local ACCENT       = Color3.fromHex("#a855f7")   -- sliders, checkboxes, tooltips
local MUTED        = Color3.fromHex("#c084fc")   -- icons
local BASE         = Color3.fromHex("#15121f")   -- window / popup / dialog fill

local WHITE = Color3.new(1, 1, 1)
local TEXT  = Color3.fromHex("#FFFFFF")

-- This file can run once from loader.lua and again from a game script. WindUI
-- rejects duplicate names; replace only our entry so the newest public theme
-- and its helpers always finish loading.
if Lib.Themes then Lib.Themes.Macr0 = nil end

Lib:AddTheme({
    Name = "Macr0",

    Primary = MUTED,
    White   = WHITE,
    Black   = Color3.new(0, 0, 0),
    Accent  = ACCENT,

    Background = BASE,
    BackgroundTransparency = TRANSPARENCY,
    Dialog  = Color3.fromHex("#18141f"),
    Hover   = TEXT,
    Outline = Color3.fromHex("#2a2535"),
    Text    = TEXT,
    Placeholder = Color3.fromHex("#888888"),
    Icon    = MUTED,
    Button  = Color3.fromHex("#1c1828"),

    -- White at 0.95 rather than a grey fill: it picks up whatever is behind
    -- the window instead of flattening it.
    PanelBackground = WHITE,
    PanelBackgroundTransparency = 0.95,

    WindowBackground = Color3.fromHex("#0e0b14"),
    WindowShadow     = Color3.new(0, 0, 0),
    WindowTopbarTitle      = TEXT,
    WindowTopbarAuthor     = TEXT,
    WindowTopbarIcon       = MUTED,
    WindowTopbarButtonIcon = MUTED,
    WindowSearchBarBackground = BASE,

    TabBackground      = TEXT,
    TabBackgroundHover = TEXT,
    TabBackgroundHoverTransparency = 0.97,
    TabBackgroundActive = TEXT,
    TabBackgroundActiveTransparency = 0.93,
    TabText  = TEXT,
    TabTextTransparency = 0.3,
    TabTextTransparencyActive = 0,
    TabTitle = TEXT,
    TabIcon  = MUTED,
    TabIconTransparency = 0.4,
    TabIconTransparencyActive = 0.1,
    TabBorder = WHITE,
    TabBorderTransparency = 1,
    TabBorderTransparencyActive = 0.75,

    ElementBackground = TEXT,
    ElementBackgroundTransparency = 0.93,
    ElementBackgroundHover = TEXT,
    ElementTitle = TEXT,
    ElementDesc  = TEXT,
    ElementIcon  = MUTED,

    PopupBackground = BASE,
    PopupBackgroundTransparency = "BackgroundTransparency",
    PopupTitle   = TEXT,
    PopupContent = TEXT,
    PopupIcon    = MUTED,

    DialogBackground = BASE,
    DialogBackgroundTransparency = "BackgroundTransparency",
    DialogTitle   = TEXT,
    DialogContent = TEXT,
    DialogIcon    = MUTED,

    Toggle    = Color3.fromHex("#4b3b5c"),
    ToggleBar = WHITE,

    Checkbox = ACCENT,
    CheckboxIcon = WHITE,
    CheckboxBorder = WHITE,
    CheckboxBorderTransparency = 0.75,

    Slider         = ACCENT,
    SliderThumb    = WHITE,
    SliderIcon     = MUTED,
    SliderIconFrom = MUTED,
    SliderIconTo   = MUTED,

    Tooltip = Color3.fromHex("#352b42"),
    TooltipText = WHITE,
    TooltipSecondary = ACCENT,
    TooltipSecondaryText = WHITE,

    TabSectionIcon = MUTED,
    SectionIcon    = MUTED,
    SectionExpandIcon = WHITE,
    SectionExpandIconTransparency = 0.4,
    SectionBox = WHITE,
    SectionBoxTransparency = 0.95,
    SectionBoxBorder = WHITE,
    SectionBoxBorderTransparency = 0.75,
    SectionBoxBackground = WHITE,
    SectionBoxBackgroundTransparency = 0.95,

    SearchBarBorder = WHITE,
    SearchBarBorderTransparency = 0.75,

    Notification = BASE,
    NotificationTitle = TEXT,
    NotificationTitleTransparency = 0,
    NotificationContent = TEXT,
    NotificationContentTransparency = 0.4,
    NotificationDuration = WHITE,
    NotificationDurationTransparency = 0.95,
    NotificationBorder = WHITE,
    NotificationBorderTransparency = 0.75,

    DropdownTabBorder = WHITE,
    LabelBackground = WHITE,
    LabelBackgroundTransparency = 0.95,
})

Lib:SetTheme("Macr0")

-- Scripts read this so their own window transparency matches the theme's --
-- WindUI blends the window background image separately, and the two disagreeing
-- is what makes one panel look washed out next to another.
_G.MACR0_THEME_TRANSPARENCY = TRANSPARENCY

-- ===========================================================================
-- SHARED UI BEHAVIOUR
--
-- Lives here rather than in each script for two reasons: one implementation to
-- get right instead of two that drift, and this file ships PLAIN, so these can
-- be fixed without re-obfuscating and re-releasing anything.
-- ===========================================================================
local UI = {}

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

-- Keep the hub above the game's own UI.
-- Setting DisplayOrder once is not enough: WindUI touches it while the window
-- animates open, and the game can raise its own UI later. Re-assert on change.
function UI.pinOnTop(W)
    local orders = { ScreenGui = 999000, DropdownGui = 999100,
                     TooltipGui = 999200, NotificationGui = 999300 }
    local conns = {}
    for name, order in pairs(orders) do
        pcall(function()
            local gui = W[name]
            if not gui then return end
            gui.DisplayOrder = order
            if not gui:GetAttribute("Macr0Pinned") then
                gui:SetAttribute("Macr0Pinned", true)
                conns[#conns + 1] = gui:GetPropertyChangedSignal("DisplayOrder")
                    :Connect(function()
                        if gui.DisplayOrder ~= order then gui.DisplayOrder = order end
                    end)
            end
        end)
    end
    return conns
end

-- Show the normal arrow while the mouse is over the hub.
--
-- Drawing games swap in their own cursor and re-assert it every frame, so this
-- binds at RenderPriority.Last to get the final word.
--
-- Hover is a RECT TEST, deliberately not PlayerGui:GetGuiObjectsAtPosition --
-- that only finds guis parented to that PlayerGui, so if the guis are still
-- sitting in gethui()'s container (which happens whenever the reparent step
-- fails) it never matches and the cursor silently never changes. Comparing
-- rectangles does not care where the gui lives.
--
-- Two Y values are tested because GetMouseLocation excludes the topbar inset
-- while AbsolutePosition includes it for IgnoreGuiInset ScreenGuis, and which
-- one applies varies. Frames covering most of the viewport are skipped: those
-- are invisible containers, and matching them would make the cursor "normal"
-- everywhere.
function UI.cursorGuard(W, name)
    name = name or "Macr0Cursor"
    local hovering, savedIcon, savedEnabled, savedMouseIcon = false, nil, nil, nil
    local mouse = Players.LocalPlayer:GetMouse()

    -- --------------------------------------------------------------------
    -- The game's own cursor.
    --
    -- Free Draw sets MouseIconEnabled = false and draws its own cursor in
    -- PlayerGui.CursorGUI: an ImageLabel arrow plus a small "DrawCursor"
    -- frame, swapped depending on whether the pointer is over its UI. So
    -- setting UserInputService.MouseIcon does nothing at all here.
    --
    -- Two consequences, both of which had to be fixed:
    --   * CursorGUI sits at DisplayOrder 1000 and the hub at 999000, so the
    --     cursor was rendering BEHIND our panels -- invisible, not wrong.
    --   * The game picks arrow-vs-dot by hit-testing its own GUI, and the hub
    --     is not part of it, so it always believed the pointer was on canvas.
    --
    -- Games that use MouseIcon instead are handled by the fallback below.
    -- --------------------------------------------------------------------
    local cursorGui, cursorEnabled
    local function findCursorGui()
        if cursorGui and cursorGui.Parent then return cursorGui end
        local pg = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not pg then return nil end
        for _, g in ipairs(pg:GetChildren()) do
            if g:IsA("ScreenGui") and g.Name:lower():find("cursor") then
                cursorGui = g
                return g
            end
        end
        return nil
    end

    -- Free Draw's cursor hierarchy and image names have changed before. Trying
    -- to guess which child is its arrow can leave both children hidden. Hide
    -- the whole custom cursor GUI over Macr0 and explicitly enable Roblox's
    -- stock arrow; restore the game GUI and prior mouse settings on exit.
    local DEFAULT_CURSOR = "rbxasset://textures/Cursors/KeyboardMouse/ArrowFarCursor.png"
    local function hideGameCursor(hidden)
        local g = findCursorGui()
        if not g then return false end
        if hidden then
            if cursorEnabled == nil then cursorEnabled = g.Enabled end
            if g.Enabled then g.Enabled = false end
        elseif cursorEnabled ~= nil then
            g.Enabled = cursorEnabled
            cursorEnabled = nil
        end
        return true
    end

    local function inside(obj, x, y)
        local ok, p, s = pcall(function() return obj.AbsolutePosition, obj.AbsoluteSize end)
        if not ok or not p or not s or s.X < 1 or s.Y < 1 then return false end
        local cam = workspace.CurrentCamera
        if cam then
            local v = cam.ViewportSize
            if s.X > v.X * 0.95 and s.Y > v.Y * 0.95 then return false end
        end
        return x >= p.X and x <= p.X + s.X and y >= p.Y and y <= p.Y + s.Y
    end

    -- Only depth 1 and 2. WindUI's ScreenGui holds folders (Window, Popups,
    -- ToolTips) whose children are the actual panels, so two levels reaches
    -- every panel while walking about ten objects. GetDescendants() here would
    -- be 260+ objects EVERY FRAME on a RenderStep, which is not acceptable for
    -- a cosmetic feature.
    local function candidates(sg)
        local list = {}
        for _, a in ipairs(sg:GetChildren()) do
            if a:IsA("GuiObject") then
                list[#list + 1] = a
            else
                for _, b in ipairs(a:GetChildren()) do
                    if b:IsA("GuiObject") then list[#list + 1] = b end
                end
            end
        end
        return list
    end

    local function over()
        local okm, m = pcall(function() return UIS:GetMouseLocation() end)
        if not okm or not m then return false end
        local inset = 0
        pcall(function() inset = GuiService:GetGuiInset().Y end)

        for _, key in ipairs({ "ScreenGui", "DropdownGui", "TooltipGui" }) do
            local sg = W[key]
            if sg and sg.Enabled ~= false then
                local ok, kids = pcall(candidates, sg)
                if ok and kids then
                    for _, o in ipairs(kids) do
                        if o.Visible and (inside(o, m.X, m.Y)
                                          or inside(o, m.X, m.Y + inset)) then
                            return true
                        end
                    end
                end
            end
        end
        return false
    end

    -- Locate it now so its original Enabled state can be captured on hover.
    pcall(findCursorGui)

    pcall(function()
        RunService:BindToRenderStep(name, Enum.RenderPriority.Last.Value + 1000, function()
            if over() then
                if not hovering then
                    hovering = true
                    savedIcon = UIS.MouseIcon
                    savedEnabled = UIS.MouseIconEnabled
                    savedMouseIcon = mouse.Icon
                end
                hideGameCursor(true)
                if UIS.MouseIcon ~= DEFAULT_CURSOR then UIS.MouseIcon = DEFAULT_CURSOR end
                if not UIS.MouseIconEnabled then UIS.MouseIconEnabled = true end
                if mouse.Icon ~= DEFAULT_CURSOR then mouse.Icon = DEFAULT_CURSOR end
            elseif hovering then
                hovering = false
                hideGameCursor(false)
                pcall(function()
                    UIS.MouseIcon = savedIcon or ""
                    UIS.MouseIconEnabled = savedEnabled ~= false
                    mouse.Icon = savedMouseIcon or ""
                end)
            end
        end)
    end)

    return function()
        pcall(function() RunService:UnbindFromRenderStep(name) end)
        if hovering then
            hovering = false
            pcall(function() hideGameCursor(false) end)
            pcall(function()
                UIS.MouseIcon = savedIcon or ""
                UIS.MouseIconEnabled = savedEnabled ~= false
                mouse.Icon = savedMouseIcon or ""
            end)
        end
    end
end

_G.MACR0_UI = UI
return true
