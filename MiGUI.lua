-- RE-CONSTRUCCIÓN TOTAL
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- UI RETRO ROBUSTA
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "FixedRetro"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 200, 0, 180)
main.Position = UDim2.new(0.5, -100, 0.2, 0)
main.BackgroundColor3 = Color3.new(0,0,0)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 0)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
title.TextColor3 = Color3.new(0,0,0)
title.Text = "FORCE ADMIN v2"
title.Font = "Code"

-- MODO DIOS MEJORADO (FUERZA BRUTA)
local godBtn = Instance.new("TextButton", main)
godBtn.Size = UDim2.new(0.8, 0, 0, 40)
godBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
godBtn.Text = "GOD: OFF"
godBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
godBtn.TextColor3 = Color3.new(1,1,1)

local godActive = false
godBtn.MouseButton1Click:Connect(function()
    godActive = not godActive
    godBtn.Text = godActive and "GOD: ON" or "GOD: OFF"
    godBtn.TextColor3 = godActive and Color3.new(0,1,0) or Color3.new(1,1,1)
end)

-- Bucle de vida (No puede morir)
RunService.RenderStepped:Connect(function()
    if godActive then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 100 -- Te mantiene vivo constantemente
            char.Humanoid.MaxHealth = 100
            -- Evita que te maten por "Void" o scripts de daño
            if char.Humanoid:GetState() == Enum.HumanoidStateType.Dead then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
end)

-- SOGA TOOL (MEJORADA)
local sogaBtn = Instance.new("TextButton", main)
sogaBtn.Size = UDim2.new(0.8, 0, 0, 40)
sogaBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
sogaBtn.Text = "DAR SOGA"
sogaBtn.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
sogaBtn.TextColor3 = Color3.new(1,1,1)

sogaBtn.MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool")
    tool.Name = "Soga Retro"
    tool.RequiresHandle = true
    
    local handle = Instance.new("Part", tool)
    handle.Name = "Handle"
    handle.Size = Vector3.new(1,1,1)
    handle.Color = Color3.new(0,1,0)
    
    tool.Activated:Connect(function()
        local mouse = player:GetMouse()
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            local enemyRoot = target.Parent:FindFirstChild("HumanoidRootPart")
            local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
            
            if enemyRoot and myRoot then
                -- Crear Soga que todos ven
                local att1 = Instance.new("Attachment", myRoot)
                local att2 = Instance.new("Attachment", enemyRoot)
                local rope = Instance.new("RopeConstraint", myRoot)
                rope.Attachment0 = att1
                rope.Attachment1 = att2
                rope.Length = 5
                rope.Visible = true
                rope.Color = BrickColor.new("Bright green")
                rope.Thickness = 0.2
            end
        end
    end)
    tool.Parent = player.Backpack
end)

-- BOTÓN CERRAR/ABRIR (Para Celular)
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -25, 0, 0)
close.Text = "X"
close.BackgroundColor3 = Color3.new(1,0,0)

local openBtn = Instance.new("TextButton", sg)
openBtn.Size = UDim2.new(0, 40, 0, 40)
openBtn.Position = UDim2.new(0, 0, 0.5, 0)
openBtn.Text = "MENU"
openBtn.Visible = false

close.MouseButton1Click:Connect(function()
    main.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    main.Visible = true
    openBtn.Visible = false
end)
