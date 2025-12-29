local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- INTERFAZ NEGRA RETRO
local sg = Instance.new("ScreenGui", player.PlayerGui)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 180, 0, 140)
main.Position = UDim2.new(0.5, -90, 0.3, 0)
main.BackgroundColor3 = Color3.new(0, 0, 0)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 0)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
title.Text = "FORCE ADMIN"
title.TextColor3 = Color3.new(0, 0, 0)

-- BOTÓN CERRAR
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -25, 0, 0)
close.Text = "X"
close.BackgroundColor3 = Color3.new(0.5, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.MouseButton1Click:Connect(function() sg:Destroy() end)

-- MODO DIOS (VIDA INFINITA)
local godBtn = Instance.new("TextButton", main)
godBtn.Size = UDim2.new(0.9, 0, 0, 35)
godBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
godBtn.Text = "GOD: OFF"
godBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
godBtn.TextColor3 = Color3.new(1, 1, 1)

local godActive = false
godBtn.MouseButton1Click:Connect(function()
    godActive = not godActive
    godBtn.Text = godActive and "GOD: ON" or "GOD: OFF"
    godBtn.TextColor3 = godActive and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
end)

-- Bucle de Vida (Simple y efectivo)
spawn(function()
    while true do
        if godActive then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.MaxHealth = 9e9 -- Numero gigante
                char.Humanoid.Health = 9e9
            end
        end
        wait(0.1) -- No causa lag y mantiene la vida arriba
    end
end)

-- SOGA TOOL
local sogaBtn = Instance.new("TextButton", main)
sogaBtn.Size = UDim2.new(0.9, 0, 0, 35)
sogaBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
sogaBtn.Text = "DAR SOGA"
sogaBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
sogaBtn.TextColor3 = Color3.new(1, 1, 1)

sogaBtn.MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool")
    tool.Name = "Soga"
    tool.RequiresHandle = true
    local h = Instance.new("Part", tool)
    h.Name = "Handle"
    h.Size = Vector3.new(1, 1, 1)
    
    tool.Activated:Connect(function()
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            local enemyRoot = target.Parent:FindFirstChild("HumanoidRootPart")
            local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if enemyRoot and myRoot then
                local rope = Instance.new("RopeConstraint", myRoot)
                local a0 = Instance.new("Attachment", myRoot)
                local a1 = Instance.new("Attachment", enemyRoot)
                rope.Attachment0 = a0
                rope.Attachment1 = a1
                rope.Length = 7
                rope.Visible = true
            end
        end
    end)
    tool.Parent = player.Backpack
end)
