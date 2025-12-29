-- SERVICIOS
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- CONFIGURACIÓN DE COLORES RETRO
local UI_BG_COLOR = Color3.fromRGB(10, 10, 10)
local UI_ACCENT = Color3.fromRGB(0, 255, 150) 
local UI_TEXT = Color3.fromRGB(255, 255, 255)

-- CONTENEDOR PRINCIPAL
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RetroMobileMod"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- BOTÓN PARA REABRIR (Invisible/Pequeño para Celular)
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 40, 0, 40)
openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.Text = "M"
openBtn.TextColor3 = UI_ACCENT
openBtn.BackgroundColor3 = UI_BG_COLOR
openBtn.BackgroundTransparency = 0.5
openBtn.Visible = false
openBtn.Parent = screenGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 220)
mainFrame.Position = UDim2.new(0.5, -125, 0.4, -110)
mainFrame.BackgroundColor3 = UI_BG_COLOR
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = UI_ACCENT
mainFrame.Active = true
mainFrame.Draggable = true -- Útil si usas un dedo para moverlo
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = " [ RETRO MOBILE ] "
title.TextColor3 = UI_ACCENT
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.Font = Enum.Font.Code
title.Parent = mainFrame

-- BOTÓN CERRAR
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.Code
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    openBtn.Visible = false
end)

--- LÓGICA MODO DIOS ---
local godBtn = Instance.new("TextButton")
godBtn.Size = UDim2.new(0.9, 0, 0, 45)
godBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
godBtn.Text = "MODO DIOS: OFF"
godBtn.TextColor3 = UI_TEXT
godBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
godBtn.Font = Enum.Font.Code
godBtn.Parent = mainFrame

local godModeActive = false
godBtn.MouseButton1Click:Connect(function()
    godModeActive = not godModeActive
    godBtn.Text = godModeActive and "MODO DIOS: ON" or "MODO DIOS: OFF"
    godBtn.TextColor3 = godModeActive and UI_ACCENT or UI_TEXT
end)

RunService.Heartbeat:Connect(function()
    if godModeActive and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.MaxHealth = math.huge
        player.Character.Humanoid.Health = math.huge
    end
end)

--- LÓGICA SOGA TOOL (PARA TOCAR JUGADORES) ---
local toolBtn = Instance.new("TextButton")
toolBtn.Size = UDim2.new(0.9, 0, 0, 45)
toolBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
toolBtn.Text = "OBTENER SOGA"
toolBtn.TextColor3 = UI_TEXT
toolBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toolBtn.Font = Enum.Font.Code
toolBtn.Parent = mainFrame

toolBtn.MouseButton1Click:Connect(function()
    local tool = Instance.new("Tool")
    tool.Name = "Soga (Toca Jugador)"
    tool.RequiresHandle = true
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 2, 1)
    handle.BrickColor = BrickColor.new("Black")
    handle.Parent = tool
    
    tool.Activated:Connect(function()
        -- En móvil, mouse.Target detecta donde tocas
        local target = mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            local victim = target.Parent
            local vRoot = victim:FindFirstChild("HumanoidRootPart")
            local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
            
            if vRoot and myRoot then
                -- Limpiar conexiones anteriores
                for _, v in pairs(myRoot:GetChildren()) do
                    if v:IsA("RopeConstraint") or v:IsA("Attachment") then v:Destroy() end
                end
                
                local att0 = Instance.new("Attachment", myRoot)
                local att1 = Instance.new("Attachment", vRoot)
                local rope = Instance.new("RopeConstraint")
                
                rope.Attachment0 = att0
                rope.Attachment1 = att1
                rope.Visible = true
                rope.Thickness = 0.1
                rope.Color = BrickColor.new("Bright green")
                rope.Length = 6
                rope.Parent = myRoot
            end
        end
    end)
    
    tool.Parent = player.Backpack
end)

-- NOTA FINAL
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -20)
footer.Text = "Toca el jugador con la tool equipada"
footer.TextSize = 10
footer.TextColor3 = Color3.fromRGB(100, 100, 100)
footer.BackgroundTransparency = 1
footer.Parent = mainFrame
