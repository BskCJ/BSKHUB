local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "BSKHUB UNIVERSAL",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "BskHub",
   LoadingSubtitle = "by bskcj",
   ShowText = "BSKHUB", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Bloom", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "BSKHUBUNIVERSALFILE"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "🔑BskHub Key System🔑",
      Subtitle = "Key System",
      Note = "Key In Discord", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = true, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"https://pastebin.com/raw/kii8F9UV"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

-- =========================
-- Services
-- =========================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- =========================
-- Client Tab
-- =========================
local ClientTab = Window:CreateTab("Client", nil)
local MainSection = ClientTab:CreateSection("Main")

-- Infinite Jump
local jumpConn
local infiniteJumpEnabled = false
local currentJumpPower = 50
local function enableInfiniteJump()
    if jumpConn then pcall(function() jumpConn:Disconnect() end) end
    jumpConn = UserInputService.JumpRequest:Connect(function()
        local char = localPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.JumpPower = currentJumpPower
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

ClientTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(Value)
        infiniteJumpEnabled = Value
        if Value then
            pcall(enableInfiniteJump)
        elseif jumpConn then
            pcall(function() jumpConn:Disconnect() end)
            jumpConn = nil
        end
    end
})

localPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    if infiniteJumpEnabled then enableInfiniteJump() end
end)

-- WalkSpeed
ClientTab:CreateSlider({
    Name = "🏃WalkSpeed🏃",
    Range = {0,500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "Slider1",
    Callback = function(Value)
        pcall(function()
            local char = localPlayer.Character
            if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = Value end
        end)
    end
})

-- JumpPower
ClientTab:CreateSlider({
    Name = "🚀JumpPower🚀",
    Range = {1,500},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "Slider2",
    Callback = function(Value)
        currentJumpPower = Value
        pcall(function()
            local char = localPlayer.Character
            if char and char:FindFirstChild("Humanoid") then char.Humanoid.JumpPower = Value end
        end)
    end
})

-- Fullbright
local fullbrightEnabled = false
local savedLighting = {}
local function applyFullbright()
    local l = Lighting
    savedLighting = {
        Ambient = l.Ambient, Brightness = l.Brightness, ClockTime = l.ClockTime,
        ColorShift_Bottom = l.ColorShift_Bottom, ColorShift_Top = l.ColorShift_Top,
        FogStart = l.FogStart, FogEnd = l.FogEnd, GlobalShadows = l.GlobalShadows,
        OutdoorAmbient = l.OutdoorAmbient
    }
    l.Ambient = Color3.fromRGB(255,255,255)
    l.Brightness = 2
    l.ClockTime = 14
    l.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    l.ColorShift_Top = Color3.fromRGB(0,0,0)
    l.FogStart = 0
    l.FogEnd = 100000
    l.GlobalShadows = false
    l.OutdoorAmbient = Color3.fromRGB(255,255,255)
end
local function restoreLighting()
    local l = Lighting
    if next(savedLighting) == nil then return end
    l.Ambient = savedLighting.Ambient
    l.Brightness = savedLighting.Brightness
    l.ClockTime = savedLighting.ClockTime
    l.ColorShift_Bottom = savedLighting.ColorShift_Bottom
    l.ColorShift_Top = savedLighting.ColorShift_Top
    l.FogStart = savedLighting.FogStart
    l.FogEnd = savedLighting.FogEnd
    l.GlobalShadows = savedLighting.GlobalShadows
    l.OutdoorAmbient = savedLighting.OutdoorAmbient
    savedLighting = {}
end

ClientTab:CreateToggle({
    Name = "🔦Fullbright🔦",
    CurrentValue = false,
    Flag = "FullbrightToggle",
    Callback = function(Value)
        fullbrightEnabled = Value
        if Value then applyFullbright() else restoreLighting() end
    end
})

-- No-clip
local noclipEnabled = false
RunService.Stepped:Connect(function()
    if noclipEnabled and localPlayer.Character then
        for _, part in pairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
ClientTab:CreateToggle({
    Name = "No-Clip",
    CurrentValue = false,
    Flag = "NoClipToggle",
    Callback = function(Value)
        noclipEnabled = Value
    end
})

-- =========================
-- Aimbot Tab
-- =========================
local AimbotTab = Window:CreateTab("Aimbot", nil)
local Section = AimbotTab:CreateSection("Aimbot")

local aimbotLoaded = false
local Aimbot

AimbotTab:CreateToggle({
    Name = "Universal Aimbot",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        if Value then
            if not aimbotLoaded then
                local ok,result = pcall(function()
                    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua"))()
                end)
                if ok and result then
                    Aimbot = result
                    if type(Aimbot.Load)=="function" then Aimbot.Load() end
                    aimbotLoaded = true
                else warn("Aimbot failed to load:",result) end
            else
                if Aimbot.Settings then Aimbot.Settings.Enabled = true end
            end
        else
            if Aimbot and Aimbot.Settings then Aimbot.Settings.Enabled = false end
        end
    end
})

-- Ensure Aimbot OFF at start
if Aimbot and Aimbot.Settings then
    Aimbot.Settings.Enabled = false
end

-- =========================
-- Misc Tab
-- =========================
local MiscTab = Window:CreateTab("Misc", nil)
local MiscSection = MiscTab:CreateSection("Misc Features")

-- Click Teleport
local clickTpEnabled = false
MiscTab:CreateToggle({
    Name = "Click Teleport",
    CurrentValue = false,
    Flag = "ClickTpToggle",
    Callback = function(Value)
        clickTpEnabled = Value
    end
})
UserInputService.InputBegan:Connect(function(input)
    if clickTpEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mouse = localPlayer:GetMouse()
        if mouse.Target and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
        end
    end
end)

-- Infinite Yield Button
MiscTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

-- =========================
-- ESP Tab
-- =========================
local ESPTab = Window:CreateTab("ESP", nil)
local ESPSection = ESPTab:CreateSection("ESP Menu")

local espEnabled = false
local espObjects = {}
local function applyESP(character)
    if character and character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = Color3.fromRGB(255,255,255)

        local billboard = Instance.new("BillboardGui")
        billboard.Parent = character
        billboard.Adornee = character:FindFirstChild("Head")
        billboard.Size = UDim2.new(0,200,0,50)
        billboard.StudsOffset = Vector3.new(0,2,0)
        billboard.AlwaysOnTop = true

        local textLabel = Instance.new("TextLabel")
        textLabel.Parent = billboard
        textLabel.Size = UDim2.new(1,0,1,0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255,255,255)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 16
        textLabel.TextStrokeTransparency = 0.5
        textLabel.Text = "Loading..."

        espObjects[character] = {highlight, billboard, textLabel}
    end
end

local function updateESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local char = plr.Character
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChild("Humanoid")
            local espData = espObjects[char]

            if rootPart and humanoid and espData then
                local distance = (rootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
                local teamName = plr.Team and plr.Team.Name or "No Team"
                local health = math.floor(humanoid.Health)
                local maxHealth = math.floor(humanoid.MaxHealth)
                espData[3].Text = string.format("%s | %.1fm | %d/%d HP | %s", teamName, distance, health, maxHealth, plr.Name)
            end
        end
    end
end

local function refreshESP()
    for _, data in pairs(espObjects) do
        for _, obj in pairs(data) do obj:Destroy() end
    end
    espObjects = {}

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= localPlayer and plr.Character then applyESP(plr.Character) end
    end
end

ESPTab:CreateToggle({
    Name = "ESP Enabled",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        espEnabled = Value
        if Value then
            refreshESP()
            RunService.RenderStepped:Connect(function()
                if espEnabled then updateESP() end
            end)
        else
            for _, data in pairs(espObjects) do
                for _, obj in pairs(data) do obj:Destroy() end
            end
            espObjects = {}
        end
    end
})

-- =========================
-- Game Scripts Tab
-- =========================
local GameScriptsTab = Window:CreateTab("GameScripts", nil)
local Section = GameScriptsTab:CreateSection("KEYLESS/WORKING")

GameScriptsTab:CreateButton({
   Name = "⚔️BladeBall⚔️",
   Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Akash1al/Blade-Ball-Updated-Script/refs/heads/main/Blade-Ball-Script"))()
   end,
})

GameScriptsTab:CreateButton({
   Name = "🔫MM2🔪",
   Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/OnyxHub-New/OnyxHub/refs/heads/main/mm2'))()
   end,
})

GameScriptsTab:CreateButton({
   Name = "👮JailBreak AutoFarm👮",
   Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BlitzIsKing/UniversalFarm/main/Loader/Regular"))()
   end,
})

local Button = GameScriptsTab:CreateButton({
   Name = "💰Notoriety💰",
   Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/Loader.lua"))()
   end,
})

Rayfield:Notify({
   Title = "Script Executed",
   Content = "BskHub Univeral",
   Duration = 5,
   Image = 1419482330208141434,
})

local Button = GameScriptsTab:CreateButton({
   Name = "🪖WarTycoon🪖",
   Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/WarTycoon.lua"))()
   end,
})
