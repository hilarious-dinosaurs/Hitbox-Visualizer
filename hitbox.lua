local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Globaler Status
local _G = getgenv and getgenv() or _G
_G.HitboxEnabled = false

-- Funktion zum Erstellen/Entfernen der Visuellen Effekte
local function refreshVisuals()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            
            if _G.HitboxEnabled then
                -- 1. DIE BOX (Hitbox)
                if not root:FindFirstChild("DevBox") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "DevBox"
                    box.Size = Vector3.new(4, 6, 2)
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Color3 = Color3.fromRGB(0, 255, 0) -- Grün
                    box.Transparency = 0.5
                    box.Adornee = root
                    box.Parent = root
                end

                -- 2. DER NAME (BillboardGui) - JETZT GRÖSSER
                if not root:FindFirstChild("DevNameTag") then
                    local bbg = Instance.new("BillboardGui")
                    bbg.Name = "DevNameTag"
                    bbg.Size = UDim2.new(0, 300, 0, 70) -- Größeres Feld für den Text
                    bbg.StudsOffset = Vector3.new(0, 5, 0) -- Etwas höher über dem Kopf
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
                    label.TextSize = 24 -- SCHRIFTGRÖSSE ERHÖHT (vorher 14)
                    label.TextScaled = false -- Damit die Größe fest bleibt
                    label.Parent = bbg
                end
            else
                -- Alles löschen, wenn OFF
                if root:FindFirstChild("DevBox") then root.DevBox:Destroy() end
                if root:FindFirstChild("DevNameTag") then root.DevNameTag:Destroy() end
            end
        end
    end
end

-- GUI Erstellung (Button oben links)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DevControlGui"
if syn and syn.protect_gui then syn.protect_gui(screenGui) end 
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
    toggleButton.BackgroundColor3 = _G.HitboxEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    refreshVisuals()
end)

-- Loop für Updates (neue Spieler/Respawn) alle 1 Sekunde
task.spawn(function()
    while task.wait(1) do
        refreshVisuals()
    end
end)
