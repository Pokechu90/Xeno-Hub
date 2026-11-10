-- =============================================================================
-- XENOHUB ULTIMATE EDITION V5 (KEYLESS - BETA UPDATE)
-- Target Game: Attack on Titan Revolution (AOT:R)
-- Production Ready Code Base - Structured for GitHub Hosting
-- =============================================================================

if getgenv().XenoHub_Loaded then
    print("[XenoHub]: Framework is already active in this server context.")
    return
else
    getgenv().XenoHub_Loaded = true
end

-- [ SERVICE MAP DATA ]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local FolderName = "XenoHub_Configs"
local DefaultConfigName = "DefaultProfile.json"

-- [ ENHANCED MANAGEMENT GLOBALS ]
getgenv().XenoHub_Config = {
    WebhookURL = "",
    AutoLoad = true,
    
    -- UI Options (Custom Orion Customizations)
    ActiveTheme = "Black & Yellow", -- Black & Yellow, Total Dark, Lumina Bright, Cyber Glow
    UITransparency = 0,
    
    -- Combat Vectors
    AutoFarmTitans = false,
    ManualFarmMode = false,
    FarmMethod = "Behind Nape",
    TweenSpeed = 65,
    
    -- Hitbox & Multipliers
    NapeExtender = false,
    NapeSize = 15,
    BladeMultiHit = 8,
    SpearMultiHit = 6,
    BossBurst = false,
    BossBurstHits = 10,
    AutoEscapeGrab = false,
    
    -- Lobby & Mission Deployment Suite
    AutoLaunchMission = false,
    SelectedMap = "Shigu Shina",     
    SelectedDifficulty = "Normal",   
    Mod_Fatigue = false,
    Mod_Injuries = false,
    Mod_Evolution = false,
    
    -- Raid Arrays
    AutoRaidMode = false,
    SelectedRaid = "Attack",
    
    -- Waves Tab & Gear Progression
    AutoWavesMode = false,
    TitansPerSwing = 5,
    AutoUpgradeStats = false,
    AutoSkillTree = false,
    AutoPrestige = false,
    AutoUpgradeGear = false,       
    
    -- Beta Automation Systems
    AdaptiveBuilds = false,
    TargetRoutine = "Offense Overload", -- Offense Overload, Balanced Raid, Wave Tank
    
    -- Chest Modules
    AutoOpenPremiumChest = false,
    AutoOpenFreeChest = false,
    AutoRefillResources = true,
    UseThunderSpears = false,
    AutoClaimAchievements = false,
    
    -- ESP Settings
    PlayerESP = false,
    TitanESP = false,
    NapeESP = false
}

-- =============================================================================
-- THEME DESIGN ENGINE (ORION INTERFACE CODES OVERRIDE)
-- =============================================================================
local ThemeProfiles = {
    ["Black & Yellow"] = {
        MainColor = Color3.fromRGB(15, 15, 15),
        AccentColor = Color3.fromRGB(255, 215, 0),
        BackgroundColor = Color3.fromRGB(10, 10, 10),
        TextColor = Color3.fromRGB(255, 255, 255)
    },
    ["Total Dark"] = {
        MainColor = Color3.fromRGB(5, 5, 5),
        AccentColor = Color3.fromRGB(45, 45, 45),
        BackgroundColor = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(200, 200, 200)
    },
    ["Lumina Bright"] = {
        MainColor = Color3.fromRGB(245, 245, 250),
        AccentColor = Color3.fromRGB(0, 120, 255),
        BackgroundColor = Color3.fromRGB(255, 255, 255),
        TextColor = Color3.fromRGB(20, 20, 20)
    },
    ["Cyber Glow"] = {
        MainColor = Color3.fromRGB(10, 15, 25),
        AccentColor = Color3.fromRGB(0, 255, 200),
        BackgroundColor = Color3.fromRGB(5, 8, 15),
        TextColor = Color3.fromRGB(240, 255, 255)
    }
}

local function UpdateUIAppearance()
    local theme = ThemeProfiles[getgenv().XenoHub_Config.ActiveTheme]
    local container = CoreGui:FindFirstChild("Orion")
    if container and theme then
        for _, obj in ipairs(container:GetDescendants()) do
            pcall(function()
                if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                    obj.BackgroundTransparency = getgenv().XenoHub_Config.UITransparency
                end
                if obj.Name == "Main" or obj.Name == "Background" then
                    obj.BackgroundColor3 = theme.BackgroundColor
                elseif obj.Name == "TopBar" or obj.Name == "CustomBar" then
                    obj.BackgroundColor3 = theme.MainColor
                elseif obj.Name == "Stroke" or obj:IsA("UIStroke") then
                    obj.Color = theme.AccentColor
                elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    if obj.TextColor3 ~= theme.AccentColor then
                        obj.TextColor3 = theme.TextColor
                    end
                end
            end)
        end
    end
end

-- =============================================================================
-- TELEMETRY SYSTEM (DISCORD WEBHOOKS)
-- =============================================================================
local function SendXenoWebhook(title, description, color)
    if not getgenv().XenoHub_Config.WebhookURL or getgenv().XenoHub_Config.WebhookURL == "" then return end

    local embed = {
        ["title"] = "🛸 XenoHub Notification - " .. (title or "System Log"),
        ["description"] = description or "No data content verified.",
        ["color"] = color or 65280,
        ["footer"] = { ["text"] = "XenoHub V5 Core Engine | " .. os.date("%X") }
    }

    local payload = HttpService:JSONEncode({
        ["username"] = "XenoHub Drone Logs",
        ["embeds"] = { embed }
    })

    task.spawn(function()
        local req = syn and syn.request or request or http_request
        if req then
            req({Url = getgenv().XenoHub_Config.WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = payload})
        end
    end)
end

-- =============================================================================
-- CONFIGURATION FILES ARCHITECT (SLICE HUB MANAGER STYLE)
-- =============================================================================
if not isfolder(FolderName) then makefolder(FolderName) end

local function ApplyConfigData(loadedData)
    if type(loadedData) ~= "table" then return end
    for k, v in pairs(loadedData) do
        getgenv().XenoHub_Config[k] = v
    end
    UpdateUIAppearance()
end

local function SaveConfig(fileName)
    if not fileName or fileName == "" then return end
    if not string.match(fileName, "%.json$") then fileName = fileName .. ".json" end
    
    local success, encoded = pcall(function() return HttpService:JSONEncode(getgenv().XenoHub_Config) end)
    if success then
        writefile(FolderName .. "/" .. fileName, encoded)
        SendXenoWebhook("Profile Saved", "Saved runtime options parameters to custom file: **" .. fileName .. "**", 65280)
    end
end

local function LoadConfig(fileName)
    if not string.match(fileName, "%.json$") then fileName = fileName .. ".json" end
    local path = FolderName .. "/" .. fileName
    if not isfile(path) then return false end
    
    local success, content = pcall(function() return readfile(path) end)
    if success then
        local decodeSuccess, decodedData = pcall(function() return HttpService:JSONDecode(content) end)
        if decodeSuccess then
            ApplyConfigData(decodedData)
            SendXenoWebhook("Profile Loaded", "Active configurations modified to: **" .. fileName .. "**", 255)
            return true
        end
    end
    return false
end

if getgenv().XenoHub_Config.AutoLoad and isfile(FolderName .. "/" .. DefaultConfigName) then
    LoadConfig(DefaultConfigName)
else
    SaveConfig(DefaultConfigName)
end

-- =============================================================================
-- ORION USER INTERFACE INITIALIZATION (SLICK REORGANIZATION)
-- =============================================================================
local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()

local Window = OrionLib:MakeWindow({
    Name = "🛸 XenoHub Ultimate V5 | Attack on Titan: Revolution", 
    HidePremium = true, 
    SaveConfig = false, 
    IntroText = "XenoHub Loading Telemetry...",
    IntroIcon = "rbxassetid://4483362458"
})

-- [TAB 1: SYSTEM CONTROLS & LOGISTICS]
local SystemTab = Window:MakeTab({ Name = "⚙️ System & Profiles", Icon = "rbxassetid://4483362458", Premium = false })

SystemTab:AddDropdown({
    Name = "UI Theme Mode Selection",
    Default = getgenv().XenoHub_Config.ActiveTheme,
    Options = {"Black & Yellow", "Total Dark", "Lumina Bright", "Cyber Glow"},
    Callback = function(Value) 
        getgenv().XenoHub_Config.ActiveTheme = Value 
        UpdateUIAppearance()
    end
})

SystemTab:AddSlider({
    Name = "Interface Frame Transparency",
    Min = 0, Max = 9, Default = math.floor(getgenv().XenoHub_Config.UITransparency * 10), Increment = 1, ValueName = "Level",
    Callback = function(Value) 
        getgenv().XenoHub_Config.UITransparency = Value / 10
        UpdateUIAppearance()
    end
})

SystemTab:AddInput({
    Name = "Discord Webhook Target URL",
    Default = getgenv().XenoHub_Config.WebhookURL,
    PlaceholderText = "Paste Discord App Hook URL here...",
    Callback = function(Text)
        getgenv().XenoHub_Config.WebhookURL = Text
        SendXenoWebhook("Link Validated", "Telemetry pipeline attached to server framework setup successfully.", 3447003)
    end
})

local CustomConfigName = "MyCustomProfile"
SystemTab:AddInput({
    Name = "Active Configuration Profile Name",
    Default = "MyCustomProfile",
    PlaceholderText = "Type filename database key...",
    Callback = function(Text) CustomConfigName = Text end
})

SystemTab:AddButton({ Name = "Save Current Options Template", Callback = function() SaveConfig(CustomConfigName) OrionLib:MakeNotification({Name = "Success", Content = "Saved profile properties.", Time = 3}) end })
