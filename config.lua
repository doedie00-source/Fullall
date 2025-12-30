-- config.lua
-- Configuration & Constants (Dark Blue Professional Theme)

local CONFIG = {
    VERSION = "7.3",
    GUI_NAME = "ModernTradeGUI",
    
    -- Window Settings
    MAIN_WINDOW_SIZE = UDim2.new(0, 750, 0, 480),
    SIDEBAR_WIDTH = 110,
    MINI_ICON_SIZE = UDim2.new(0, 50, 0, 50),
    
    -- Timing
    STATUS_RESET_DELAY = 4,
    BUTTON_CHECK_INTERVAL = 0.5,
    TRADE_RESET_THRESHOLD = 3,
    
    -- UI Spacing
    CORNER_RADIUS = 10,
    LIST_PADDING = 4,
    BUTTON_PADDING = 5,
    CARD_PADDING = 6,
    
    -- Keybind
    TOGGLE_KEY = Enum.KeyCode.T,
}

-- 🌊 Dark Blue Professional Theme (Navy + Slate)
local THEME = {
    -- Base Colors (Dark Blue-Black)
    MainBg = Color3.fromRGB(10, 15, 25),            -- Very Dark Navy
    MainTransparency = 0.05,
    PanelBg = Color3.fromRGB(15, 20, 32),           -- Dark Navy Panel
    PanelTransparency = 0.2,
    
    -- Glass Effect (Navy Blue)
    GlassBg = Color3.fromRGB(18, 25, 38),           -- Navy Glass
    GlassTransparency = 0.1,
    GlassStroke = Color3.fromRGB(35, 55, 85),       -- Blue-Grey Border
    
    -- Text (Professional)
    TextWhite = Color3.fromRGB(245, 248, 255),      -- Soft White
    TextGray = Color3.fromRGB(155, 165, 180),       -- Cool Grey
    TextDim = Color3.fromRGB(110, 120, 135),        -- Dim Grey
    
    -- Buttons (Navy Gradient)
    BtnDefault = Color3.fromRGB(25, 35, 50),        -- Dark Navy Button
    BtnHover = Color3.fromRGB(30, 45, 65),          -- Hover Navy
    BtnSelected = Color3.fromRGB(35, 75, 140),      -- Deep Blue (Selected)
    BtnMainTab = Color3.fromRGB(20, 30, 45),        -- Tab Button
    BtnMainTabSelected = Color3.fromRGB(35, 75, 140), -- Selected Tab
    BtnDupe = Color3.fromRGB(40, 85, 150),          -- Dupe Blue
    BtnDisabled = Color3.fromRGB(20, 25, 35),       -- Disabled Dark
    TextDisabled = Color3.fromRGB(75, 80, 90),      -- Disabled Text
    
    -- Status Colors (Blue Tones Only)
    Success = Color3.fromRGB(45, 100, 180),         -- Bright Blue (Success)
    Fail = Color3.fromRGB(65, 85, 120),             -- Muted Blue-Grey (Fail)
    Warning = Color3.fromRGB(85, 120, 180),         -- Light Blue (Warning)
    Info = Color3.fromRGB(55, 95, 160),             -- Info Blue
    
    -- Special (Blue Variations)
    ItemInv = Color3.fromRGB(50, 110, 190),         -- Bright Item Blue
    ItemEquip = Color3.fromRGB(60, 90, 135),        -- Equipped Blue
    PlayerBtn = Color3.fromRGB(45, 100, 180),       -- Player Blue
    DupeReady = Color3.fromRGB(55, 115, 200),       -- Ready Blue
    
    -- Cards (Dark Navy)
    CardBg = Color3.fromRGB(18, 28, 42),            -- Card Background
    CardStrokeSelected = Color3.fromRGB(45, 100, 180), -- Selected Border
    CardStrokeLocked = Color3.fromRGB(65, 85, 120),    -- Locked Border
    CrateSelected = Color3.fromRGB(50, 110, 190),      -- Selected Crate
    
    -- Accent Colors (Professional Blue Palette)
    StarColor = Color3.fromRGB(180, 200, 255),      -- Cool Star Blue
    AccentPurple = Color3.fromRGB(45, 85, 155),     -- Deep Blue (was purple)
    AccentBlue = Color3.fromRGB(50, 105, 185),      -- Bright Blue
    AccentGreen = Color3.fromRGB(55, 115, 175),     -- Blue-Teal (was green)
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
