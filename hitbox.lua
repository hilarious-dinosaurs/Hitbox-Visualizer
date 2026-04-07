local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Globaler Status
if not getgenv then getgenv = function() return _G end end
getgenv().HitboxEnabled = false

-- Funktion zum Erstellen/Entfernen der Visuellen Effekte
local function refreshVisuals()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            
            if _G.HitboxEnabled and root then
                -- 1. DIE GRÜNE BOX (Hitbox)
                if not root:FindFirstChild("DevBox") then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Name = "DevBox"
                    box.Size = Vector3.new(4, 6, 2) -- Standard Hitbox Größe
                    box.AlwaysOnTop = true
                    box.ZIndex = 10
                    box.Color3 = Color3.fromRGB(0, 255, 0) -- Klassisches Grün
                    box.Transparency = 0.5
                    box.Adornee = root
                    box.Parent = root
                end

                -- 2. DER GROSSE NAME
                if not root:FindFirstChild("DevNameTag") then
                    local bbg = Instance.new("BillboardGui")
                    bbg.Name = "DevNameTag"
                    bbg.Size = UDim2.new(0, 300, 0, 70)
                    bbg.StudsOffset = Vector3.new(0, 5, 0)
                    bbg.AlwaysOnTop = true
                    bbg.Adornee = root
                    bbg.Parent = root

                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = player.Name
                    label.TextColor3 = Color3.new(1, 1, 1)
                    label.TextStrokeTransparency = 0
                    label.Font = Enum.Font.SourceSansBold
                    label.TextSize = 24 -- Schön groß, wie gewünscht
                    label.Parent = bbg
                end
            else
                -- Alles löschen, wenn OFF
                if root and root:FindFirstChild("DevBox") then root.DevBox:Destroy() end
                if root and root:FindFirstChild("DevNameTag") then root.DevNameTag:Destroy() end
            end
        end
    end
end

-- GUI Erstellung (Button)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DevControlGui"
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
    toggleButton.BackgroundColor3 = _G.HitboxEnabled and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    refreshVisuals()
end)

-- Loop für Updates
task.spawn(function()
    while task.wait(0.5) do
        refreshVisuals()
    end
end)
