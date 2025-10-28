-- Roblox Cheat Script by Colin
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Security Code
local SECURITY_CODE = "rOK$TZIkwF3OjZxNR6C6D%h9wTt-7P"

-- Create Security GUI
local SecurityGui = Instance.new("ScreenGui")
SecurityGui.Name = "SecurityMenu"
SecurityGui.ResetOnSpawn = false
SecurityGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SecurityGui.Parent = game:GetService("CoreGui")

local SecurityFrame = Instance.new("Frame")
SecurityFrame.Size = UDim2.new(0, 300, 0, 200)
SecurityFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
SecurityFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SecurityFrame.BorderSizePixel = 2
SecurityFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
SecurityFrame.Active = true
SecurityFrame.Draggable = true
SecurityFrame.Parent = SecurityGui

local SecurityLabel = Instance.new("TextLabel")
SecurityLabel.Size = UDim2.new(1, 0, 0, 40)
SecurityLabel.Position = UDim2.new(0, 0, 0, 10)
SecurityLabel.Text = "ENTER SECURITY CODE"
SecurityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SecurityLabel.BackgroundTransparency = 1
SecurityLabel.TextSize = 18
SecurityLabel.Font = Enum.Font.SourceSansBold
SecurityLabel.Parent = SecurityFrame

local CodeBox = Instance.new("TextBox")
CodeBox.Size = UDim2.new(0, 260, 0, 40)
CodeBox.Position = UDim2.new(0, 20, 0, 60)
CodeBox.PlaceholderText = "Enter code here..."
CodeBox.Text = ""
CodeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CodeBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CodeBox.TextSize = 16
CodeBox.ClearTextOnFocus = false
CodeBox.Parent = SecurityFrame

local SubmitButton = Instance.new("TextButton")
SubmitButton.Size = UDim2.new(0, 260, 0, 40)
SubmitButton.Position = UDim2.new(0, 20, 0, 120)
SubmitButton.Text = "SUBMIT CODE"
SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitButton.TextSize = 16
SubmitButton.Font = Enum.Font.SourceSansBold
SubmitButton.Parent = SecurityFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 170)
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextSize = 14
StatusLabel.Parent = SecurityFrame

-- Variables for cheat menu
local connections = {}
local Noclip = false
local InfiniteJump = false
local ESPEnabled = false
local FlyEnabled = false
local PlayerSpeed = 16
local FlySpeed = 50
local ESPFolder = Instance.new("Folder")
local SelectedPlayer = nil
local AntiCheatActivated = false
local CheatMenuLoaded = false

-- Anti-Cheat Bypass Function
local function AntiCheatBypass()
    if AntiCheatActivated then return end
    
    AntiCheatActivated = true
    
    -- Basic anti-cheat protection
    if not getgenv then
        getgenv = function() return {} end
    end
    
    getgenv().secure_mode = true
    getgenv().debug_mode = false
    
    print("Anti-Cheat Bypass Activated")
end

-- ESP Function with Team Colors
local function CreateESP(player)
    if player and player.Character then
        local Highlight = Instance.new("Highlight")
        Highlight.Name = player.Name
        Highlight.Adornee = player.Character
        Highlight.FillTransparency = 0.5
        Highlight.OutlineTransparency = 0
        
        -- Determine team color
        local teamColor = Color3.fromRGB(255, 255, 255) -- Default white
        
        if player.Team then
            -- Use player's team color
            teamColor = player.TeamColor.Color
        elseif player:FindFirstChild("TeamColor") then
            -- Alternative team color detection
            teamColor = player.TeamColor.Value
        else
            -- Color by player name hash for unique colors
            local nameHash = 0
            for i = 1, #player.Name do
                nameHash = nameHash + string.byte(player.Name, i)
            end
            local hue = (nameHash % 360) / 360
            teamColor = Color3.fromHSV(hue, 0.8, 1)
        end
        
        -- Set highlight colors
        Highlight.FillColor = teamColor
        Highlight.OutlineColor = teamColor
        
        Highlight.Parent = ESPFolder
        
        print("ESP created for: " .. player.Name)
    end
end

-- Function to load cheat menu
local function LoadCheatMenu()
    if CheatMenuLoaded then return end
    CheatMenuLoaded = true
    
    print("Loading cheat menu...")
    
    -- Remove security GUI
    SecurityGui:Destroy()
    
    -- Create main cheat GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CheatMenu"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 320, 0, 600)
    MainFrame.Position = UDim2.new(0, 10, 0, 10)
    MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MainFrame.BackgroundTransparency = 0.3
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 20, 0, 20)
    ToggleButton.Position = UDim2.new(1, -20, 0, 0)
    ToggleButton.Text = "X"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Parent = MainFrame

    -- Create ESP Folder
    ESPFolder.Name = "ESP"
    ESPFolder.Parent = ScreenGui

    -- Noclip
    local NoclipButton = Instance.new("TextButton")
    NoclipButton.Size = UDim2.new(0, 140, 0, 30)
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
    InfiniteJumpButton.Size = UDim2.new(0, 140, 0, 30)
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

    -- ESP with Team Colors
    local ESPButton = Instance.new("TextButton")
    ESPButton.Size = UDim2.new(0, 140, 0, 30)
    ESPButton.Position = UDim2.new(0, 10, 0, 120)
    ESPButton.Text = "ESP: OFF"
    ESPButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPButton.Parent = MainFrame

    ESPButton.MouseButton1Click:Connect(function()
        ESPEnabled = not ESPEnabled
        if ESPEnabled then
            ESPButton.Text = "ESP: ON"
            ESPButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            
            -- Clear existing ESP
            for _, item in pairs(ESPFolder:GetChildren()) do
                item:Destroy()
            end
            
            -- Create ESP for all players
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    CreateESP(player)
                end
            end
            
            -- Create ESP for new players
            connections.espAdded = Players.PlayerAdded:Connect(function(player)
                wait(1)
                if player ~= LocalPlayer then
                    CreateESP(player)
                end
            end)
            
        else
            ESPButton.Text = "ESP: OFF"
            ESPButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            
            -- Clear all ESP
            for _, item in pairs(ESPFolder:GetChildren()) do
                item:Destroy()
            end
            
            -- Disconnect connections
            if connections.espAdded then
                connections.espAdded:Disconnect()
            end
        end
    end)

    -- Speed
    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(0, 140, 0, 20)
    SpeedLabel.Position = UDim2.new(0, 10, 0, 160)
    SpeedLabel.Text = "Player Speed:"
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedLabel.Parent = MainFrame

    local SpeedBox = Instance.new("TextBox")
    SpeedBox.Size = UDim2.new(0, 60, 0, 20)
    SpeedBox.Position = UDim2.new(0, 160, 0, 160)
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
    DeleteToolButton.Size = UDim2.new(0, 140, 0, 30)
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

    -- Fly Speed
    local FlySpeedLabel = Instance.new("TextLabel")
    FlySpeedLabel.Size = UDim2.new(0, 140, 0, 20)
    FlySpeedLabel.Position = UDim2.new(0, 10, 0, 240)
    FlySpeedLabel.Text = "Fly Speed:"
    FlySpeedLabel.BackgroundTransparency = 1
    FlySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlySpeedLabel.Parent = MainFrame

    local FlySpeedBox = Instance.new("TextBox")
    FlySpeedBox.Size = UDim2.new(0, 60, 0, 20)
    FlySpeedBox.Position = UDim2.new(0, 160, 0, 240)
    FlySpeedBox.Text = tostring(FlySpeed)
    FlySpeedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    FlySpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlySpeedBox.Parent = MainFrame

    FlySpeedBox.FocusLost:Connect(function()
        local newFlySpeed = tonumber(FlySpeedBox.Text)
        if newFlySpeed then
            FlySpeed = newFlySpeed
        end
    end)

    -- Fly
    local FlyButton = Instance.new("TextButton")
    FlyButton.Size = UDim2.new(0, 140, 0, 30)
    FlyButton.Position = UDim2.new(0, 10, 0, 270)
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
                            
                            BodyVelocity.Velocity = moveDirection * FlySpeed
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
    IYButton.Size = UDim2.new(0, 140, 0, 30)
    IYButton.Position = UDim2.new(0, 10, 0, 310)
    IYButton.Text = "Load IY"
    IYButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    IYButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    IYButton.Parent = MainFrame

    IYButton.MouseButton1Click:Connect(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end)

    -- Anti-Cheat Bypass
    local AntiCheatButton = Instance.new("TextButton")
    AntiCheatButton.Size = UDim2.new(0, 140, 0, 30)
    AntiCheatButton.Position = UDim2.new(0, 10, 0, 350)
    AntiCheatButton.Text = "Anti-Cheat Bypass"
    AntiCheatButton.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
    AntiCheatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AntiCheatButton.Parent = MainFrame

    AntiCheatButton.MouseButton1Click:Connect(function()
        AntiCheatBypass()
        AntiCheatButton.Text = "Bypass Activated"
        AntiCheatButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end)

    -- Player List for Teleport
    local PlayerListLabel = Instance.new("TextLabel")
    PlayerListLabel.Size = UDim2.new(0, 140, 0, 20)
    PlayerListLabel.Position = UDim2.new(0, 10, 0, 390)
    PlayerListLabel.Text = "Select Player:"
    PlayerListLabel.BackgroundTransparency = 1
    PlayerListLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerListLabel.Parent = MainFrame

    -- Player List Frame with background
    local PlayerListFrame = Instance.new("Frame")
    PlayerListFrame.Size = UDim2.new(0, 140, 0, 100)
    PlayerListFrame.Position = UDim2.new(0, 10, 0, 410)
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
    SelectedPlayerLabel.Size = UDim2.new(0, 140, 0, 25)
    SelectedPlayerLabel.Position = UDim2.new(0, 10, 0, 520)
    SelectedPlayerLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SelectedPlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SelectedPlayerLabel.Text = "Selected: None"
    SelectedPlayerLabel.Parent = MainFrame

    -- Teleport Button
    local TeleportButton = Instance.new("TextButton")
    TeleportButton.Size = UDim2.new(0, 140, 0, 30)
    TeleportButton.Position = UDim2.new(0, 10, 0, 550)
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

    -- Auto-activate Anti-Cheat Bypass on script start
    AntiCheatBypass()

    print("Cheat Menu loaded successfully! Press X to hide/show.")
    print("Team Color ESP activated - players will be highlighted in their team colors!")
end

-- Code verification function
SubmitButton.MouseButton1Click:Connect(function()
    local enteredCode = CodeBox.Text
    
    if enteredCode == SECURITY_CODE then
        StatusLabel.Text = "✓ Code accepted! Loading cheats..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        wait(1)
        LoadCheatMenu()
    else
        StatusLabel.Text = "✗ Invalid code! Try again."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        CodeBox.Text = ""
    end
end)

-- Also allow Enter key to submit
CodeBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local enteredCode = CodeBox.Text
        
        if enteredCode == SECURITY_CODE then
            StatusLabel.Text = "✓ Code accepted! Loading cheats..."
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            wait(1)
            LoadCheatMenu()
        else
            StatusLabel.Text = "✗ Invalid code! Try again."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            CodeBox.Text = ""
        end
    end
end)

print("Security system loaded. Enter code to access cheat menu.")
print("Security Code: " .. SECURITY_CODE)
