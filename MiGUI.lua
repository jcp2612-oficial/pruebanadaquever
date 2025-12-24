-- ESCUELA HUB V3 - DICIEMBRE 2025
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variables
local NoclipEnabled = false
local InvisibleEnabled = false

-- --- FUNCIONES CORE ---

-- Noclip Pro (Forzado por Frame)
RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Invisibilidad (Local)
local function ToggleInvis()
    InvisibleEnabled = not InvisibleEnabled
    local char = LocalPlayer.Character
    if char then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = InvisibleEnabled and 1 or 0
            end
        end
        if char:FindFirstChild("Head") and char.Head:FindFirstChild("NameTag") then
             char.Head.NameTag.Enabled = not InvisibleEnabled
        end
    end
end

-- Modo Hormiga (Requiere que el juego use R15 para ser efectivo)
local function BeAnt()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        local hs = hum:FindFirstChild("HeadScale")
        local bds = hum:FindFirstChild("BodyDepthScale")
        local bws = hum:FindFirstChild("BodyWidthScale")
        local bhs = hum:FindFirstChild("BodyHeightScale")

        if hs and bds and bws and bhs then
            hs.Value = 0.3
            bds.Value = 0.3
            bws.Value = 0.3
            bhs.Value = 0.3
        else
            char:ScaleTo(0.3) -- Método alternativo para juegos nuevos
        end
    end
end

-- --- INTERFAZ ---
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 250, 0, 380)
Main.Position = UDim2.new(0.5, -125, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -30, 0, 35)
Title.Text = "ESCUELA HUB V3"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

-- Botón Minimizar
local Min = Instance.new("TextButton", Main)
Min.Size = UDim2.new(0, 30, 0, 35)
Min.Position = UDim2.new(1, -30, 0, 0)
Min.Text = "-"
Min.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Min.MouseButton1Click:Connect(function()
    Main.Visible = false
    -- Creamos un botón pequeño para volver a abrir
    local Open = Instance.new("TextButton", ScreenGui)
    Open.Size = UDim2.new(0, 50, 0, 20)
    Open.Position = UDim2.new(0, 0, 0, 0)
    Open.Text = "ABRIR"
    Open.MouseButton1Click:Connect(function()
        Main.Visible = true
        Open:Destroy()
    end)
end)

local function CreateBtn(text, y, func)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(func)
    return b
end

-- Controles de Velocidad
local SpeedInput = Instance.new("TextBox", Main)
SpeedInput.Size = UDim2.new(0.4, 0, 0, 35)
SpeedInput.Position = UDim2.new(0.05, 0, 0, 45)
SpeedInput.PlaceholderText = "Vel (ej: 50)"
SpeedInput.Text = ""
SpeedInput.BackgroundColor3 = Color3.fromRGB(40,40,40)
SpeedInput.TextColor3 = Color3.new(1,1,1)

CreateBtn("Set Speed", 45, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = tonumber(SpeedInput.Text) or 16
    end
end).Position = UDim2.new(0.5, 0, 0, 45) SpeedInput.NextSelectionDown = nil -- Ajuste posición

-- Resto de botones
CreateBtn("Noclip Pro (ON/OFF)", 90, function() NoclipEnabled = not NoclipEnabled end)
CreateBtn("Invisibilidad", 135, ToggleInvis)
CreateBtn("Modo Hormiga", 180, BeAnt)
CreateBtn("Obtener Soga", 225, function()
    -- Aquí va la función de la soga que ya tenías
    loadstring(game:HttpGet("https://raw.githubusercontent.com/jcp2612-oficial/pruebanadaquever/refs/heads/main/MiGUI.lua"))() -- Recarga para asegurar herramienta
end)
CreateBtn("Teleport Random", 270, function()
    local p = Players:GetPlayers()
    local target = p[math.random(1, #p)]
    if target.Character then LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position) end
end)
