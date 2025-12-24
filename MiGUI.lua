-- ===============================================
-- GUI para Noclip y Bring Player (Diciembre 2025)
-- Creado para la escuela :)
-- ===============================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RunService = game:GetService("RunService")

-- Variables de estado
local NoclipEnabled = false
local BringEnabled = false

-- Función para alternar Noclip
local function ToggleNoclip()
    NoclipEnabled = not NoclipEnabled
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsA("Accessory") then
            part.CanCollide = not NoclipEnabled
        end
    end
    print("Noclip " .. (NoclipEnabled and "Activado" or "Desactivado"))
end

-- Función para atraer jugadores (Bring Player)
local function BringPlayerToMe(targetPlayerName)
    local targetPlayer = Players:FindFirstChild(targetPlayerName)
    if targetPlayer and targetPlayer.Character then
        local targetHumanoidRootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHumanoidRootPart then
            -- Intentamos mover al jugador. Esto puede ser parcheado por el servidor.
            targetHumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame
            print("Intentando traer a: " .. targetPlayerName)
        else
            warn("No se encontró el HumanoidRootPart del jugador objetivo.")
        end
    else
        warn("No se encontró al jugador: " .. targetPlayerName)
    end
end

-- ==================
-- Diseño de la GUI
-- ==================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EscuelaHub"
ScreenGui.Parent = CoreGui -- Lo ponemos en CoreGui para que se vea bien

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75) -- Centrado
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true -- Para poder mover la ventana
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Text = "Escuela Hub (Diciembre 2025)"
Title.Parent = MainFrame

local NoclipButton = Instance.new("TextButton")
NoclipButton.Size = UDim2.new(0.8, 0, 0, 40)
NoclipButton.Position = UDim2.new(0.1, 0, 0.25, 10) -- Debajo del título
NoclipButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.Font = Enum.Font.SourceSansBold
NoclipButton.TextSize = 16
NoclipButton.Text = "Noclip (Desactivado)"
NoclipButton.Parent = MainFrame

local BringButton = Instance.new("TextButton")
BringButton.Size = UDim2.new(0.8, 0, 0, 40)
BringButton.Position = UDim2.new(0.1, 0, 0.5, 20) -- Debajo del Noclip
BringButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
BringButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BringButton.Font = Enum.Font.SourceSansBold
BringButton.TextSize = 16
BringButton.Text = "Atraer Jugador (Bring)"
BringButton.Parent = MainFrame

local PlayerNameInput = Instance.new("TextBox")
PlayerNameInput.Size = UDim2.new(0.8, 0, 0, 25)
PlayerNameInput.Position = UDim2.new(0.1, 0, 0.75, 25)
PlayerNameInput.PlaceholderText = "Nombre del jugador"
PlayerNameInput.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
PlayerNameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerNameInput.Parent = MainFrame

-- ==================
-- Conexión de eventos
-- ==================

NoclipButton.MouseButton1Click:Connect(function()
    ToggleNoclip()
    if NoclipEnabled then
        NoclipButton.Text = "Noclip (Activado)"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Verde
    else
        NoclipButton.Text = "Noclip (Desactivado)"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80) -- Gris
    end
end)

BringButton.MouseButton1Click:Connect(function()
    local targetName = PlayerNameInput.Text
    if targetName ~= "" then
        BringPlayerToMe(targetName)
    else
        warn("Ingresa el nombre de un jugador para traer.")
    end
end)

-- Mantener Noclip activo si el personaje se reinicia (Noclip pasivo)
RunService.Heartbeat:Connect(function()
    if NoclipEnabled and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true and not part:IsA("Accessory") then
                part.CanCollide = false
            end
        end
    end
end)

print("GUI de Escuela Hub cargada!")
