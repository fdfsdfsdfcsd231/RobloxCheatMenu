-- Roblox Cheat Script by Colin
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CheatMenu"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 570)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.BackgroundTransparency = 0.3
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 20, 0, 20)
ToggleButton.Position = UDim2.new(1, -20, 0, 0)
ToggleButton.Text = "X"
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Parent = MainFrame

-- Panel Dragging
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Variables
local connections = {}
local Noclip = false
local InfiniteJump = false
local ESPEnabled = false
local FlyEnabled = false
local PlayerSpeed = 16
local ESPFolder = Instance.new("Folder", ScreenGui)
ESPFolder.Name = "ESP"
local SelectedPlayer = nil

-- Noclip
local NoclipButton = Instance.new("TextButton")
NoclipButton.Size = UDim2.new(0, 120, 0, 30)
NoclipButton.Position = UDim2.new(0, 10, 0, 40)
NoclipButton.Text = "Noclip: OFF"
NoclipButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.Parent = MainFrame

NoclipButton.MouseButton1Click:Connect(function()
    Noclip = not Noclip
    if Noclip then
        NoclipButton.Text = "Noclip: ON"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        connections.noclip = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        NoclipButton.Text = "Noclip: OFF"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        if connections.noclip then
            connections.noclip:Disconnect()
        end
    end
end)

-- Infinite Jump
local InfiniteJumpButton = Instance.new("TextButton")
InfiniteJumpButton.Size = UDim2.new(0, 120, 0, 30)
InfiniteJumpButton.Position = UDim2.new(0, 10, 0, 80)
InfiniteJumpButton.Text = "Inf Jump: OFF"
InfiniteJumpButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
InfiniteJumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InfiniteJumpButton.Parent = MainFrame

InfiniteJumpButton.MouseButton1Click:Connect(function()
    InfiniteJump = not InfiniteJump
    if InfiniteJump then
        InfiniteJumpButton.Text = "Inf Jump: ON"
        InfiniteJumpButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        connections.infJump = UserInputService.JumpRequest:Connect(function()
            if InfiniteJump and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState("Jumping")
                end
            end
        end)
    else
        InfiniteJumpButton.Text = "Inf Jump: OFF"
        InfiniteJumpButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        if connections.infJump then
            connections.infJump:Disconnect()
        end
    end
end)

-- ESP
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0, 120, 0, 30)
ESPButton.Position = UDim2.new(0, 10, 0, 120)
ESPButton.Text = "ESP: OFF"
ESPButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.Parent = MainFrame

local function CreateESP(player)
    if player.Character then
        local Highlight = Instance.new("Highlight")
        Highlight.Name = player.Name
        Highlight.Adornee = player.Character
        Highlight.FillColor = Color3.fromRGB(255, 255, 255)
        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        Highlight.FillTransparency = 0.5
        Highlight.Parent = ESPFolder
    end
end

ESPButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        ESPButton.Text = "ESP: ON"
        ESPButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                CreateESP(player)
            end
        end
        connections.espAdded = Players.PlayerAdded:Connect(function(player)
            CreateESP(player)
        end)
    else
        ESPButton.Text = "ESP: OFF"
        ESPButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        for _, item in pairs(ESPFolder:GetChildren()) do
            item:Destroy()
        end
        if connections.espAdded then
            connections.espAdded:Disconnect()
        end
    end
end)

-- Speed
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 120, 0, 20)
SpeedLabel.Position = UDim2.new(0, 10, 0, 160)
SpeedLabel.Text = "Player Speed:"
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Parent = MainFrame

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(0, 60, 0, 20)
SpeedBox.Position = UDim2.new(0, 140, 0, 160)
SpeedBox.Text = tostring(PlayerSpeed)
SpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedBox.Parent = MainFrame

SpeedBox.FocusLost:Connect(function()
    local newSpeed = tonumber(SpeedBox.Text)
    if newSpeed then
        PlayerSpeed = newSpeed
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = PlayerSpeed
        end
    end
end)

-- Delete Tool
local DeleteToolButton = Instance.new("TextButton")
DeleteToolButton.Size = UDim2.new(0, 120, 0, 30)
DeleteToolButton.Position = UDim2.new(0, 10, 0, 200)
DeleteToolButton.Text = "Get Delete Tool"
DeleteToolButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
DeleteToolButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteToolButton.Parent = MainFrame

DeleteToolButton.MouseButton1Click:Connect(function()
    local Tool = Instance.new("Tool")
    Tool.Name = "DeleteTool"
    Tool.RequiresHandle = false
    Tool.CanBeDropped = false
    Tool.Parent = LocalPlayer.Backpack

    Tool.Activated:Connect(function()
        local target = Mouse.Target
        if target then
            target:Destroy()
        end
    end)
end)

-- Fly
local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0, 120, 0, 30)
FlyButton.Position = UDim2.new(0, 10, 0, 240)
FlyButton.Text = "Fly: OFF"
FlyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Parent = MainFrame

FlyButton.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    if FlyEnabled then
        FlyButton.Text = "Fly: ON"
        FlyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        local character = LocalPlayer.Character
        if character then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local BodyVelocity = Instance.new("BodyVelocity")
                local BodyGyro = Instance.new("BodyGyro")
                
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                BodyVelocity.Parent = humanoidRootPart
                
                BodyGyro.D = 50
                BodyGyro.P = 1000
                BodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
                BodyGyro.CFrame = humanoidRootPart.CFrame
                BodyGyro.Parent = humanoidRootPart
                
                connections.fly = RunService.Heartbeat:Connect(function()
                    if character and humanoidRootPart then
                        local camera = workspace.CurrentCamera
                        local moveDirection = Vector3.new(0, 0, 0)
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            moveDirection = moveDirection + camera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            moveDirection = moveDirection - camera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            moveDirection = moveDirection - camera.CFrame.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            moveDirection = moveDirection + camera.CFrame.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            moveDirection = moveDirection + Vector3.new(0, 1, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            moveDirection = moveDirection - Vector3.new(0, 1, 0)
                        end
                        
                        BodyVelocity.Velocity = moveDirection * 50
                        BodyGyro.CFrame = camera.CFrame
                    end
                end)
                
                connections.flyBodyVelocity = BodyVelocity
                connections.flyBodyGyro = BodyGyro
            end
        end
    else
        FlyButton.Text = "Fly: OFF"
        FlyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        if connections.fly then
            connections.fly:Disconnect()
        end
        if connections.flyBodyVelocity then
            connections.flyBodyVelocity:Destroy()
        end
        if connections.flyBodyGyro then
            connections.flyBodyGyro:Destroy()
        end
    end
end)

-- Infinite Yield
local IYButton = Instance.new("TextButton")
IYButton.Size = UDim2.new(0, 120, 0, 30)
IYButton.Position = UDim2.new(0, 10, 0, 280)
IYButton.Text = "Load IY"
IYButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
IYButton.TextColor3 = Color3.fromRGB(255, 255, 255)
IYButton.Parent = MainFrame

IYButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

-- Player List for Teleport
local PlayerListLabel = Instance.new("TextLabel")
PlayerListLabel.Size = UDim2.new(0, 120, 0, 20)
PlayerListLabel.Position = UDim2.new(0, 10, 0, 320)
PlayerListLabel.Text = "Select Player:"
PlayerListLabel.BackgroundTransparency = 1
PlayerListLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerListLabel.Parent = MainFrame

-- Player List Frame with background
local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Size = UDim2.new(0, 120, 0, 150)
PlayerListFrame.Position = UDim2.new(0, 10, 0, 340)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerListFrame.BorderSizePixel = 0
PlayerListFrame.Parent = MainFrame

local PlayerListScrolling = Instance.new("ScrollingFrame")
PlayerListScrolling.Size = UDim2.new(1, -10, 1, -10)
PlayerListScrolling.Position = UDim2.new(0, 5, 0, 5)
PlayerListScrolling.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerListScrolling.BorderSizePixel = 0
PlayerListScrolling.ScrollBarThickness = 4
PlayerListScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerListScrolling.Parent = PlayerListFrame

-- Selected Player Display
local SelectedPlayerLabel = Instance.new("TextLabel")
SelectedPlayerLabel.Size = UDim2.new(0, 120, 0, 25)
SelectedPlayerLabel.Position = UDim2.new(0, 10, 0, 500)
SelectedPlayerLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SelectedPlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectedPlayerLabel.Text = "Selected: None"
SelectedPlayerLabel.Parent = MainFrame

-- Teleport Button
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0, 120, 0, 30)
TeleportButton.Position = UDim2.new(0, 10, 0, 530)
TeleportButton.Text = "TELEPORT"
TeleportButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.Parent = MainFrame

-- Function to update player list
local function UpdatePlayerList()
    for _, child in pairs(PlayerListScrolling:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local yPos = 5
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local playerButton = Instance.new("TextButton")
            playerButton.Size = UDim2.new(1, -10, 0, 20)
            playerButton.Position = UDim2.new(0, 5, 0, yPos)
            playerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            playerButton.BorderSizePixel = 0
            playerButton.Text = player.Name
            playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerButton.TextSize = 10
            playerButton.Parent = PlayerListScrolling
            
            playerButton.MouseButton1Click:Connect(function()
                SelectedPlayer = player
                SelectedPlayerLabel.Text = "Selected: " .. player.Name
            end)
            
            yPos = yPos + 25
        end
    end
end

-- Teleport function
TeleportButton.MouseButton1Click:Connect(function()
    if SelectedPlayer then
        local targetChar = SelectedPlayer.Character
        local localChar = LocalPlayer.Character
        if targetChar and localChar then
            local humanoidRootPart = localChar:FindFirstChild("HumanoidRootPart")
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and targetRoot then
                humanoidRootPart.CFrame = targetRoot.CFrame
            end
        end
    end
end)

-- Initial player list update
UpdatePlayerList()

-- Update player list when players join/leave
Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)

-- Toggle Menu
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

ScreenGui.Parent = game:GetService("CoreGui")
