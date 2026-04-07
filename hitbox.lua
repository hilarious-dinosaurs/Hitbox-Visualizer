local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui") -- Benutzt CoreGui, damit es wie ein Tool wirkt

-- Variablen für den Status
local _G = getgenv and getgenv() or _G -- Globaler Speicher für den Status
_G.HitboxEnabled = false

-- Funktion zum Erstellen/Entfernen der Boxen
local function refreshHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local existing = root:FindFirstChild("DevBox")
            
            if _G.HitboxEnabled then
                if not existing and player ~= Players.LocalPlayer then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "DevBox"
                    box.Size = Vector3.new(4, 5.5, 2)
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Color3 = Color3.fromRGB(0, 255, 0)
                    box.Transparency = 0.5
                    box.Adornee = root
                    box.Parent = root
                end
            else
                if existing then existing:Destroy() end
            end
        end
    end
end

-- GUI Erstellung
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DevControlGui"
-- Schutz gegen Reset:
if syn and syn.protect_gui then syn.protect_gui(screenGui) end 
screenGui.Parent = CoreGui

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 20, 0, 80) -- Position oben links
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Text = "Hitbox: OFF"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.Parent = screenGui

-- Button Logik
toggleButton.MouseButton1Click:Connect(function()
    _G.HitboxEnabled = not _G.HitboxEnabled
    
    if _G.HitboxEnabled then
        toggleButton.Text = "Hitbox: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        toggleButton.Text = "Hitbox: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
    refreshHitboxes()
end)

-- Loop, damit die Boxen auch bei neuen Spielern oder Respawn erscheinen
task.spawn(function()
    while task.wait(1) do
        refreshHitboxes()
    end
end)

print("GUI geladen. Viel Erfolg beim Debugging!")
