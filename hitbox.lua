local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

if not getgenv then getgenv = function() return _G end end
getgenv().HitboxEnabled = false

local function refreshVisuals()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")

            if _G.HitboxEnabled and root then
                -- TRICK FÜR UNSICHTBARE: Wir erstellen eine Box, falls der Spieler unsichtbar ist
                if not root:FindFirstChild("VisiblePart") then
                    local p = Instance.new("BoxHandleAdornment")
                    p.Name = "VisiblePart"
                    p.Size = Vector3.new(4, 6, 2) -- Größe eines normalen Charakters
                    p.AlwaysOnTop = true
                    p.ZIndex = 5
                    p.Adornee = root
                    p.Color3 = Color3.fromRGB(255, 0, 0)
                    p.Transparency = 0.5 -- Hier stellen wir die Transparenz ein!
                    p.Parent = root
                end

                -- NAME TAG (Bleibt gleich)
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
                    label.TextSize = 24
                    label.Parent = bbg
                end
            else
                -- Löschen beim Ausschalten
                if root and root:FindFirstChild("VisiblePart") then root.VisiblePart:Destroy() end
                if root and root:FindFirstChild("DevNameTag") then root.DevNameTag:Destroy() end
            end
        end
    end
end

-- GUI (Button)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DevControlGui"
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

toggleButton.MouseButton1Click:Connect(function()
    _G.HitboxEnabled = not _G.HitboxEnabled
    toggleButton.Text = _G.HitboxEnabled and "Hitbox: ON" or "Hitbox: OFF"
    toggleButton.BackgroundColor3 = _G.HitboxEnabled and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(40, 40, 40)
    refreshVisuals()
end)

task.spawn(function()
    while task.wait(0.5) do
        refreshVisuals()
    end
end)
