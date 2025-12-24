-- ESCUELA HUB V3.5 (Híbrido Optimizado)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local NoclipEnabled = false
local InvisibleEnabled = false

-- --- FUNCIONES ANTIGUAS (Lo que sí funcionaba) ---

-- Soga original
local function GiveLasso()
    local Tool = Instance.new("Tool")
    Tool.Name = "Soga de Escuela"
    Tool.RequiresHandle = false
    Tool.Parent = LocalPlayer.Backpack
    local Rope = nil
    local Attaching = false

    Tool.Activated:Connect(function()
        local target = Mouse.Target
        if target and target.Parent:FindFirstChild("Humanoid") then
            local targetChar = target.Parent
            local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
            local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP and myHRP and not Attaching then
                Attaching = true
                Rope = Instance.new("RopeConstraint")
                local a0 = Instance.new("Attachment", myHRP)
                local a1 = Instance.new("Attachment", targetHRP)
                Rope.Attachment0 = a0
                Rope.Attachment1 = a1
                Rope.Length = 5
                Rope.Visible = true
                Rope.Parent = myHRP
            elseif Attaching then
                Attaching = false
                if Rope then Rope:Destroy() end
                myHRP:ClearAllChildren()
            end
        end
    end)
end

-- --- FUNCIONES NUEVAS MEJORADAS ---

-- Invisibilidad Global (Trick)
local function GlobalInvis()
    InvisibleEnabled = not InvisibleEnabled
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("LowerTorso") then
        local root = char.LowerTorso:FindFirstChild("Root")
        if root then
            -- Esto mueve tu personaje visualmente abajo del mapa para los demás, 
            -- pero tú te sigues viendo y moviendo normal.
            root.C0 = InvisibleEnabled and CFrame.new(0, -50, 0) or CFrame.new(0, 0, 0)
        end
    end
end

-- Modo Hormiga (Mejorado para detectar R15 y R6)
local function BeAnt()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        -- Intentamos escalar todas las propiedades de tamaño
        local vars = {"HeadScale", "BodyDepthScale", "BodyWidthScale", "BodyHeightScale"}
        for _, v in pairs(vars) do
            local stat = hum:FindFirstChild(v)
            if stat then
                stat.Value = 0.2
            end
        end
        -- Si el juego no usa escalas, forzamos el tamaño del Character
        char:ScaleTo(0.2)
    end
end

-- Noclip Pro (Reparado)
RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- --- INTERFAZ (Diseño V1 con extras) ---
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 350)
Main.Position = UDim2.new(0.5, -110, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Escuela Hub v3.5"
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.TextColor3 = Color3.new(1,1,1)

-- Input de Velocidad
local SpeedInput = Instance.new("TextBox", Main)
SpeedInput.Size = UDim2.new(0.9, 0, 0, 30)
SpeedInput.Position = UDim2.new(0.05, 0, 0, 40)
SpeedInput.PlaceholderText = "Cantidad de Velocidad..."
SpeedInput.Text = ""
SpeedInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedInput.TextColor3 = Color3.new(1,1,1)

local function CreateBtn(text, y, func)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(func)
end

CreateBtn("Aplicar Velocidad", 75, function()
    LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(SpeedInput.Text) or 16
end)

CreateBtn("Noclip (ON/OFF)", 115, function() NoclipEnabled = not NoclipEnabled end)
CreateBtn("Obtener Soga (V1)", 155, GiveLasso)
CreateBtn("Invisibilidad Global", 195, GlobalInvis)
CreateBtn("Modo Hormiga (0.2)", 235, BeAnt)
CreateBtn("Teleport Random", 275, function()
    local p = Players:GetPlayers()
    local t = p[math.random(1, #p)]
    if t.Character then LocalPlayer.Character:MoveTo(t.Character.HumanoidRootPart.Position) end
end)
