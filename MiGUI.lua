-- SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- CREACIÓN DE INTERFAZ (UI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ServidorModGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true -- Para que puedas moverlo
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "SERVER MODS"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Parent = frame

-- BOTÓN MODO DIOS (Server-Side Logic)
local godBtn = Instance.new("TextButton")
godBtn.Size = UDim2.new(0.9, 0, 0, 40)
godBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
godBtn.Text = "Modo Dios: OFF"
godBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
godBtn.Parent = frame

-- BOTÓN SOGA (Server-Side Logic)
local ropeBtn = Instance.new("TextButton")
ropeBtn.Size = UDim2.new(0.9, 0, 0, 40)
ropeBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
ropeBtn.Text = "Soga Sincronizada"
ropeBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
ropeBtn.Parent = frame

--- LOGICA DE MODO DIOS ---
local godModeActive = false
godBtn.MouseButton1Click:Connect(function()
    godModeActive = not godModeActive
    if godModeActive then
        godBtn.Text = "Modo Dios: ON"
        godBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        -- El truco del servidor: Cambiamos el estado localmente pero lo forzamos
        player.Character.Humanoid.MaxHealth = math.huge
        player.Character.Humanoid.Health = math.huge
    else
        godBtn.Text = "Modo Dios: OFF"
        godBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        player.Character.Humanoid.MaxHealth = 100
        player.Character.Humanoid.Health = 100
    end
end)

-- Mantener vida infinita si el servidor intenta bajarla
RunService.Stepped:Connect(function()
    if godModeActive and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Health = math.huge
    end
end)

--- LOGICA DE LA SOGA (SYNC) ---
-- Para que otros vean la soga, aprovechamos que tú eres el "dueño" de tus accesorios o partes
ropeBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- Creamos la soga
        local rope = Instance.new("RopeConstraint")
        local att0 = Instance.new("Attachment", char.HumanoidRootPart)
        
        -- Buscamos a donde apuntar
        local target = mouse.Target
        if target then
            local att1 = Instance.new("Attachment", target)
            rope.Attachment0 = att0
            rope.Attachment1 = att1
            rope.Length = (char.HumanoidRootPart.Position - mouse.Hit.p).Magnitude
            rope.Visible = true
            rope.Parent = char.HumanoidRootPart
            
            -- Esto hace que se vea para otros si el juego permite replicación física
            print("Soga creada en el servidor físico")
        end
    end
end)
