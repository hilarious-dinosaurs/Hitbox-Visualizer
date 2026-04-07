local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Globaler Status (getgenv für bessere Executor-Kompatibilität)
if not getgenv then getgenv = function() return _G end end
getgenv().HitboxEnabled = false

-- Konfiguration
local Config = {
    HitboxColor = Color3.fromRGB(255, 0, 0), -- Rot (wie auf deinem Bild)
    HitboxTransparency = 0.65,             -- Hohe Transparenz (0.0=solid, 1.0=unsichtbar)
    NameTagTransparency = 0.0,             -- Name nicht transparent
    CheckInterval = 0.1                    -- Wie oft (in Sek.) nach neuen/respawnten Spielern gesucht wird (sehr schnell)
}

-- Funktion zum Erstellen/Entfernen der Visuellen Effekte
local function refreshVisuals()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local character = player.Character
            
            -- Suche ein gültiges Teil, um das NameTag anzuheften (HumanoidRootPart oder Head)
            local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")

            if _G.HitboxEnabled and root then
                -- 1. DIE HITBOX (Highlight) - FÜR GENAUES OVERLAY
                if not character:FindFirstChild("DevHighlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "DevHighlight"
                    hl.Adornee = character
                    hl.FillColor = Config.HitboxColor
                    hl.FillTransparency = Config.HitboxTransparency -- Transparente Füllung
                    hl.OutlineColor = Color3.fromRGB(0, 0, 0) -- Schwarze Umrandung
                    hl.OutlineTransparency = 0.9              -- Fast unsichtbare Umrandung
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Durch Wände sehen
                    hl.Parent = character
                end

                -- 2. DER NAME (BillboardGui) - BLEIBT GRÖSSER
                if not root:FindFirstChild("DevNameTag") then
                    local bbg = Instance.new("BillboardGui")
                    bbg.Name = "DevNameTag"
                    bbg.Size = UDim2.new(0, 300, 0, 70)
                    bbg.StudsOffset = Vector3.new(0, 5, 0) -- Etwas höher
                    bbg.AlwaysOnTop = true
                    bbg.Adornee = root
                    bbg.Parent = root

                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = player.Name
                    label.TextColor3 = Color3.new(1, 1, 1) -- Weiß
                    label.TextStrokeTransparency = 0 -- Schwarze Umrandung
                    label.TextStrokeColor3 = Color3.new(0, 0, 0)
                    label.Font = Enum.Font.SourceSansBold
                    label.TextSize = 24
                    label.TextScaled = false
                    label.Parent = bbg
                end
            else
                -- Alles löschen, wenn OFF oder kein gültiger Charakter
                if character:FindFirstChild("DevHighlight") then character.DevHighlight:Destroy() end
                if root and root:FindFirstChild("DevNameTag") then root.DevNameTag:Destroy() end
            end
        end
    end
end

-- GUI Erstellung (Button oben links, bleibt gleich)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DevControlGui"
-- Schutz vor Erkennung (für manche Executoren)
pcall(function() if syn and syn.protect_gui then syn.protect_gui(screenGui) end end)
screenGui.Parent = CoreGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0, 80)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Text = "Hitbox: OFF"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18
toggleButton.Parent = screenGui

-- Button Logik
toggleButton.MouseButton1Click:Connect(function()
    _G.HitboxEnabled = not _G.HitboxEnabled
    toggleButton.Text = _G.HitboxEnabled and "Hitbox: ON" or "Hitbox: OFF"
    toggleButton.BackgroundColor3 = _G.HitboxEnabled and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(40, 40, 40)
    
    -- Sofortiges Update beim Klicken
    refreshVisuals()
end)

-- Loop für Updates (neue Spieler/Respawn) - Sehr schnell (0.1 Sek)
task.spawn(function()
    while task.wait(Config.CheckInterval) do
        refreshVisuals()
    end
end)
