-- config.lua
-- Configuration & Constants (Professional Dark Blue Theme)

local CONFIG = {
    VERSION = "7.2 (Professional)",
    GUI_NAME = "ModernTradeGUI",
    
    -- Window Settings
    MAIN_WINDOW_SIZE = UDim2.new(0, 750, 0, 480),
    SIDEBAR_WIDTH = 100,
    MINI_ICON_SIZE = UDim2.new(0, 50, 0, 50),
    
    -- Timing
    STATUS_RESET_DELAY = 4,
    BUTTON_CHECK_INTERVAL = 0.5,
    TRADE_RESET_THRESHOLD = 3,
    
    -- UI Spacing
    CORNER_RADIUS = 8,
    LIST_PADDING = 4,
    BUTTON_PADDING = 4,
    CARD_PADDING = 6,
    
    -- Keybind
    TOGGLE_KEY = Enum.KeyCode.T,
}

-- 🎨 Professional Dark Blue Theme
local THEME = {
    -- Base Colors (Dark Blue Palette)
    MainBg = Color3.fromRGB(10, 25, 41),           -- Very dark blue
    MainTransparency = 0.05,
    PanelBg = Color3.fromRGB(15, 30, 48),          -- Dark blue
    PanelTransparency = 0.2,
    
    -- Glass Effect
    GlassBg = Color3.fromRGB(19, 47, 76),          -- Medium dark blue
    GlassTransparency = 0.15,
    GlassStroke = Color3.fromRGB(66, 165, 245),    -- Light blue stroke
    
    -- Text (White and Light Blue only)
    TextWhite = Color3.fromRGB(255, 255, 255),
    TextGray = Color3.fromRGB(189, 224, 254),      -- Light blue tint
    TextDim = Color3.fromRGB(144, 202, 249),       -- Soft blue
    
    -- Buttons (Unified Blue Palette)
    BtnDefault = Color3.fromRGB(21, 51, 82),       -- Dark blue
    BtnHover = Color3.fromRGB(25, 60, 95),
    BtnSelected = Color3.fromRGB(33, 150, 243),    -- Bright blue
    BtnMainTab = Color3.fromRGB(19, 47, 76),
    BtnMainTabSelected = Color3.fromRGB(33, 150, 243),
    BtnDupe = Color3.fromRGB(25, 118, 210),        -- Medium blue
    BtnDisabled = Color3.fromRGB(30, 40, 50),
    TextDisabled = Color3.fromRGB(100, 120, 140),
    
    -- Status Colors (Blue variations only)
    Success = Color3.fromRGB(66, 165, 245),        -- Light blue (instead of green)
    Fail = Color3.fromRGB(144, 202, 249),          -- Lighter blue (instead of red)
    Warning = Color3.fromRGB(100, 181, 246),       -- Sky blue (instead of yellow)
    Info = Color3.fromRGB(33, 150, 243),           -- Standard blue
    
    -- Special (All Blue Tones)
    ItemInv = Color3.fromRGB(66, 165, 245),
    ItemEquip = Color3.fromRGB(144, 202, 249),
    PlayerBtn = Color3.fromRGB(66, 165, 245),
    DupeReady = Color3.fromRGB(100, 181, 246),
    
    -- Cards
    CardBg = Color3.fromRGB(21, 51, 82),
    CardStrokeSelected = Color3.fromRGB(66, 165, 245),
    CardStrokeLocked = Color3.fromRGB(144, 202, 249),
    CrateSelected = Color3.fromRGB(66, 165, 245),
    
    -- Accent (Blue Palette)
    StarColor = Color3.fromRGB(255, 255, 255),     -- White stars
    AccentPurple = Color3.fromRGB(66, 165, 245),   -- Change to blue
    AccentBlue = Color3.fromRGB(33, 150, 243),
    AccentGreen = Color3.fromRGB(100, 181, 246),   -- Change to light blue
}

local DUPE_RECIPES = {
    Items = {
        -- [SCROLLS]
        {Name = "Dark Scroll", Tier = 5, RequiredTiers = {3, 4, 6}, Service = "Scrolls", Image = "83561916475671"},
        
        -- [TICKETS]
        {Name = "Void Ticket", Tier = 3, RequiredTiers = {4, 5, 6}, Service = "Tickets", Image = "85868652778541"},
        {Name = "Summer Ticket", Tier = 4, RequiredTiers = {3, 5, 6}, Service = "Tickets", Image = "104675798190180"},
        {Name = "Eternal Ticket", Tier = 5, RequiredTiers = {3, 4, 6}, Service = "Tickets", Image = "130196431947308"},
        {Name = "Arcade Ticket", Tier = 6, RequiredTiers = {3, 4, 5}, Service = "Tickets", Image = "104884644514614"},
        
        -- [POTIONS]
        {Name = "White Strawberry", Tier = 1, RequiredTiers = {2}, Service = "Strawberry", Image = "79066822879876"},
        {Name = "Mega Luck Potion", Tier = 3, RequiredTiers = {1, 2}, Service = "Luck Potion", Image = "131175270021637"},
        {Name = "Mega Wins Potion", Tier = 3, RequiredTiers = {1, 2}, Service = "Wins Potion", Image = "77652691143188"},
        {Name = "Mega Exp Potion", Tier = 3, RequiredTiers = {1, 2}, Service = "Exp Potion", Image = "72861583354784"},
    },
    Crates = {},
    Pets = {}
}

local HIDDEN_LISTS = {
    Accessories = {"Ghost", "Pumpkin Head", "Tri Tooth", "Tri Foot", "Tri Eyes", "Tri Ton"},
    Pets = {"I.N.D.E.X", "Spooksy", "Spooplet", "Lordfang", "Batkin", "Flame", "Mega Flame", "Turbo Flame", "Ultra Flame", "I2Pet", "Present", "Polar Bear"},
    Crates = { "Spooky Crate", "i2Perfect Crate" }
}

return {
    CONFIG = CONFIG,
    THEME = THEME,
    DUPE_RECIPES = DUPE_RECIPES,
    HIDDEN_LISTS = HIDDEN_LISTS
}
