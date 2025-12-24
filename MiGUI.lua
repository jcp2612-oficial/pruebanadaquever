local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local NoclipEnabled = false
local Minimizado = false

-- --- FUNCIONES MEJORADAS ---

-- Noclip Avanzado (Confunde al servidor usando Stepped)
local function ToggleNoclip()
    NoclipEnabled = not NoclipEnabled
end

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Sistema de Soga (Lasso Tool)
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
                myHRP:ClearAllChildren() -- Limpia los attachments
            end
        end
    end)
end

-- --- INTERFAZ GRÁFICA ---

local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Text = "Escuela Hub v2"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Botón Minimizar
local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -30, 0, 0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
MinBtn.MouseButton1Click:Connect(function()
    Minimizado = not Minimizado
    if Minimizado then
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 30))
        for _, v in pairs(MainFrame:GetChildren()) do
            if v ~= Title and v ~= MinBtn then v.Visible = false end
        end
    else
        MainFrame:TweenSize(UDim2.new(0, 220, 0, 280))
        for _, v in pairs(MainFrame:GetChildren()) do v.Visible = true end
    end
end)

-- Botones de Funciones
local function CreateButton(text, pos, func)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(func)
end

CreateButton("Noclip Pro", 40, ToggleNoclip)
CreateButton("Obtener Soga", 85, GiveLasso)
CreateButton("Speed x2", 130, function() LocalPlayer.Character.Humanoid.WalkSpeed = 32 end)
CreateButton("Teleport Aleatorio", 175, function()
    local randomPlayer = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
    if randomPlayer.Character then
        LocalPlayer.Character:MoveTo(randomPlayer.Character.HumanoidRootPart.Position)
    end
end)
