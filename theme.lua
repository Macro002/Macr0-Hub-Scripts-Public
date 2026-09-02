-- Macr0 Hub theme.
-- Loaded by loader.lua before the window is created, so every script in the
-- hub shares one look:
--   loadstring(game:HttpGet(".../theme.lua"))()
--
-- main.lua registers an identical theme itself, but only if this one has not
-- already been registered -- otherwise whichever ran last would silently win.

-- Named Lib rather than WindUI so this does not read as shadowing. The
-- `local x = x` idiom works (the right side resolves to the outer scope), but
-- it reads as a bug and static analysis flags it.
local Lib = _G.WindUI or WindUI
if not Lib then
    warn("[Macr0 Theme] WindUI not loaded yet")
    return false
end

-- Slightly see-through. Every panel, popup, dialog and notification reads this
-- one value, so change it here rather than in a dozen places.
local TRANSPARENCY = 0.12

Lib:AddTheme({
    Name = "Macr0",

    Primary = Color3.fromHex("#a855f7"),
    White   = Color3.new(1, 1, 1),
    Black   = Color3.new(0, 0, 0),
    Accent  = Color3.fromHex("#a855f7"),

    Background = Color3.fromHex("#15121f"),
    BackgroundTransparency = TRANSPARENCY,
    Outline     = Color3.fromHex("#2a2535"),
    Text        = Color3.fromHex("#ffffff"),
    Placeholder = Color3.fromHex("#888888"),
    Icon        = Color3.fromHex("#a855f7"),
    Button      = Color3.fromHex("#1c1828"),
    Hover       = Color3.fromHex("#c084fc"),
    Dialog      = Color3.fromHex("#18141f"),

    PanelBackground = Color3.new(1, 1, 1),
    PanelBackgroundTransparency = 0.95,

    WindowBackground = Color3.fromHex("#0e0b14"),
    WindowShadow     = Color3.fromHex("#000000"),
    WindowTopbarTitle      = Color3.fromHex("#ffffff"),
    WindowTopbarAuthor     = Color3.fromHex("#a855f7"),
    WindowTopbarIcon       = Color3.fromHex("#a855f7"),
    WindowTopbarButtonIcon = Color3.fromHex("#a855f7"),
    WindowSearchBarBackground = Color3.fromHex("#15121f"),

    TabBackground      = Color3.fromHex("#ffffff"),
    TabBackgroundHover = Color3.fromHex("#ffffff"),
    TabBackgroundHoverTransparency = 0.97,
    TabBackgroundActive = Color3.fromHex("#ffffff"),
    TabBackgroundActiveTransparency = 0.93,
    TabText  = Color3.fromHex("#ffffff"),
    TabTextTransparency = 0.3,
    TabTextTransparencyActive = 0,
    TabTitle = Color3.fromHex("#ffffff"),
    TabIcon  = Color3.fromHex("#a855f7"),
    TabIconTransparency = 0.4,
    TabIconTransparencyActive = 0.1,
    TabBorder = Color3.new(1, 1, 1),
    TabBorderTransparency = 1,
    TabBorderTransparencyActive = 0.75,

    ElementBackground = Color3.fromHex("#ffffff"),
    ElementBackgroundTransparency = 0.93,
    ElementBackgroundHover = Color3.fromHex("#ffffff"),
    ElementTitle = Color3.fromHex("#ffffff"),
    ElementDesc  = Color3.fromHex("#aaaaaa"),
    ElementIcon  = Color3.fromHex("#a855f7"),

    PopupBackground = Color3.fromHex("#18141f"),
    PopupBackgroundTransparency = "BackgroundTransparency",
    PopupTitle   = Color3.fromHex("#ffffff"),
    PopupContent = Color3.fromHex("#cccccc"),
    PopupIcon    = Color3.fromHex("#a855f7"),

    DialogBackground = Color3.fromHex("#18141f"),
    DialogBackgroundTransparency = "BackgroundTransparency",
    DialogTitle   = Color3.fromHex("#ffffff"),
    DialogContent = Color3.fromHex("#cccccc"),
    DialogIcon    = Color3.fromHex("#a855f7"),

    Toggle    = Color3.fromHex("#a855f7"),
    ToggleBar = Color3.fromHex("#ffffff"),

    Checkbox = Color3.fromHex("#2a2535"),
    CheckboxIcon = Color3.new(1, 1, 1),
    CheckboxBorder = Color3.new(1, 1, 1),
    CheckboxBorderTransparency = 0.75,

    Slider         = Color3.fromHex("#a855f7"),
    SliderThumb    = Color3.new(1, 1, 1),
    SliderIcon     = Color3.fromHex("#a855f7"),
    SliderIconFrom = Color3.fromHex("#a855f7"),
    SliderIconTo   = Color3.fromHex("#a855f7"),

    Tooltip = Color3.fromHex("#4c4c4c"),
    TooltipText = Color3.new(1, 1, 1),
    TooltipSecondary = Color3.fromHex("#a855f7"),
    TooltipSecondaryText = Color3.new(1, 1, 1),

    TabSectionIcon = Color3.fromHex("#a855f7"),
    SectionIcon    = Color3.fromHex("#a855f7"),
    SectionExpandIcon = Color3.new(1, 1, 1),
    SectionExpandIconTransparency = 0.4,
    SectionBox = Color3.new(1, 1, 1),
    SectionBoxTransparency = 0.95,
    SectionBoxBorder = Color3.new(1, 1, 1),
    SectionBoxBorderTransparency = 0.75,
    SectionBoxBackground = Color3.new(1, 1, 1),
    SectionBoxBackgroundTransparency = 0.95,

    SearchBarBorder = Color3.new(1, 1, 1),
    SearchBarBorderTransparency = 0.75,

    Notification = Color3.fromHex("#15121f"),
    NotificationTitle = Color3.fromHex("#ffffff"),
    NotificationTitleTransparency = 0,
    NotificationContent = Color3.fromHex("#ffffff"),
    NotificationContentTransparency = 0.4,
    NotificationDuration = Color3.new(1, 1, 1),
    NotificationDurationTransparency = 0.95,
    NotificationBorder = Color3.new(1, 1, 1),
    NotificationBorderTransparency = 0.75,

    DropdownTabBorder = Color3.new(1, 1, 1),
    LabelBackground = Color3.new(1, 1, 1),
    LabelBackgroundTransparency = 0.95,
})

Lib:SetTheme("Macr0")
return true
