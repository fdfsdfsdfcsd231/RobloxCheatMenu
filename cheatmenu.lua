-- Ynv Universal Panel
local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YnvPanel"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 550)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Minimize/Maximize System
local Minimized = false
local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.Size = UDim2.new(0, 150, 0, 40)
MinimizedFrame.Position = UDim2.new(0.5, -75, 0, 10)
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MinimizedFrame.Active = true
MinimizedFrame.Draggable = true
MinimizedFrame.Visible = false
MinimizedFrame.Parent = ScreenGui

local MinimizedUICorner = Instance.new("UICorner")
MinimizedUICorner.CornerRadius = UDim.new(0, 8)
MinimizedUICorner.Parent = MinimizedFrame

local ExpandButton = Instance.new("TextButton")
ExpandButton.Name = "ExpandButton"
ExpandButton.Size = UDim2.new(1, -10, 1, -10)
ExpandButton.Position = UDim2.new(0, 5, 0, 5)
ExpandButton.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
ExpandButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExpandButton.Text = "Развернуть"
ExpandButton.Parent = MinimizedFrame

ExpandButton.MouseButton1Click:Connect(function()
    Minimized = false
    MainFrame.Visible = true
    MinimizedFrame.Visible = false
end)

-- Tabs
local Tabs = {"Movement", "Flight", "Visuals", "Teleport", "Follow", "Troll", "Tools"}
local CurrentTab = "Movement"

local LeftPanel = Instance.new("Frame")
LeftPanel.Name = "LeftPanel"
LeftPanel.Size = UDim2.new(0, 120, 1, -50)
LeftPanel.Position = UDim2.new(0, 5, 0, 5)
LeftPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LeftPanel.Parent = MainFrame

local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0, 6)
UICorner2.Parent = LeftPanel

-- Tab Buttons
for i, tabName in pairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName
    TabButton.Size = UDim2.new(1, -10, 0, 40)
    TabButton.Position = UDim2.new(0, 5, 0, 5 + (i-1)*45)
    TabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Text = tabName
    TabButton.Parent = LeftPanel
    
    TabButton.MouseButton1Click:Connect(function()
        CurrentTab = tabName
        UpdateContent()
    end)
end

-- Bottom Control Buttons
local BottomPanel = Instance.new("Frame")
BottomPanel.Name = "BottomPanel"
BottomPanel.Size = UDim2.new(0, 120, 0, 30)
BottomPanel.Position = UDim2.new(0, 5, 1, -35)
BottomPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
BottomPanel.Parent = MainFrame

local UICorner3 = Instance.new("UICorner")
UICorner3.CornerRadius = UDim.new(0, 6)
UICorner3.Parent = BottomPanel

-- Minimize Button (+)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 50, 0, 25)
MinimizeButton.Position = UDim2.new(0, 5, 0, 2)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Text = "+"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 16
MinimizeButton.Parent = BottomPanel

MinimizeButton.MouseButton1Click:Connect(function()
    Minimized = true
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
end)

-- Close Button (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 50, 0, 25)
CloseButton.Position = UDim2.new(1, -55, 0, 2)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 16
CloseButton.Parent = BottomPanel

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -130, 1, -50)
ContentFrame.Position = UDim2.new(0, 125, 0, 5)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Functions
local Noclip = false
local InfiniteJump = false
local Flying = false
local ESP = false
local XRay = false
local GodMode = false
local Freeze = false
local FlySpeed = 50

-- Improved Fly Variables
local BODYVELOCITY
local FLYING = false
local FlyConnection

-- Freeze Variables
local OriginalWalkSpeed = 16
local OriginalJumpPower = 50

-- Teleport Variables
local SelectedPlayer = ""
local PlayerDropdown
local PlayersScrollFrame

-- ESP Variables
local ESPEnabled = false
local ESPConnections = {}

-- Follow Variables
local Following = false
local FollowTarget = nil
local FollowConnection = nil

-- Troll Variables
local PushPlayers = false
local SpinPlayers = false
local FloatPlayers = false
local PushConnection = nil
local SpinConnection = nil
local FloatConnection = nil

function UpdateContent()
    ContentFrame:ClearAllChildren()
    
    if CurrentTab == "Movement" then
        -- Noclip Toggle
        CreateToggle("Noclip", UDim2.new(0, 0, 0, 0), function(state)
            Noclip = state
            coroutine.wrap(function()
                while Noclip do
                    if Player.Character then
                        for _, part in pairs(Player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    wait(0.1)
                end
            end)()
        end)
        
        -- Infinite Jump Toggle
        CreateToggle("Infinite Jump", UDim2.new(0, 0, 0, 40), function(state)
            InfiniteJump = state
        end)
        
        -- God Mode Toggle
        CreateToggle("God Mode", UDim2.new(0, 0, 0, 80), function(state)
            GodMode = state
            if GodMode and Player.Character then
                local humanoid = Player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Name = "GodHumanoid"
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                end
            end
        end)
        
        -- Freeze Toggle
        CreateToggle("Freeze", UDim2.new(0, 0, 0, 120), function(state)
            Freeze = state
            if Freeze then
                ActivateFreeze()
            else
                DeactivateFreeze()
            end
        end)
        
        -- Walk Speed
        CreateSlider("Walk Speed", UDim2.new(0, 0, 0, 160), 16, 1, 100, function(value)
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.WalkSpeed = value
            end
        end)
        
        -- Jump Power (FIXED)
        CreateSlider("Jump Power", UDim2.new(0, 0, 0, 210), 50, 1, 200, function(value)
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.JumpPower = value
            end
        end)
        
    elseif CurrentTab == "Flight" then
        -- Fly Toggle
        CreateToggle("Fly", UDim2.new(0, 0, 0, 0), function(state)
            if state then
                ActivateSmoothFly()
            else
                DeactivateFly()
            end
        end)
        
        -- Fly Speed
        CreateSlider("Fly Speed", UDim2.new(0, 0, 0, 40), 50, 1, 200, function(value)
            FlySpeed = value
        end)
        
    elseif CurrentTab == "Visuals" then
        -- ESP Toggle
        CreateToggle("ESP", UDim2.new(0, 0, 0, 0), function(state)
            ESPEnabled = state
            if ESPEnabled then
                ActivateESP()
            else
                DeactivateESP()
            end
        end)
        
        -- X-Ray Toggle
        CreateToggle("X-Ray", UDim2.new(0, 0, 0, 40), function(state)
            XRay = state
            if XRay then
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.LocalTransparencyModifier = 0.4
                    end
                end
            else
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        obj.LocalTransparencyModifier = 0
                    end
                end
            end
        end)
        
        -- Full Bright Toggle
        CreateToggle("Full Bright", UDim2.new(0, 0, 0, 80), function(state)
            if state then
                game:GetService("Lighting").GlobalShadows = false
                game:GetService("Lighting").Brightness = 2
            else
                game:GetService("Lighting").GlobalShadows = true
                game:GetService("Lighting").Brightness = 1
            end
        end)
        
    elseif CurrentTab == "Teleport" then
        -- Player Dropdown Label
        local DropdownLabel = Instance.new("TextLabel")
        DropdownLabel.Name = "DropdownLabel"
        DropdownLabel.Size = UDim2.new(1, -10, 0, 20)
        DropdownLabel.Position = UDim2.new(0, 0, 0, 0)
        DropdownLabel.BackgroundTransparency = 1
        DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownLabel.Text = "Select Player:"
        DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        DropdownLabel.Parent = ContentFrame
        
        -- Player Dropdown
        PlayerDropdown = Instance.new("TextBox")
        PlayerDropdown.Name = "PlayerDropdown"
        PlayerDropdown.Size = UDim2.new(1, -10, 0, 30)
        PlayerDropdown.Position = UDim2.new(0, 0, 0, 25)
        PlayerDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        PlayerDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        PlayerDropdown.PlaceholderText = "Enter player name..."
        PlayerDropdown.Text = SelectedPlayer
        PlayerDropdown.Parent = ContentFrame
        
        -- TP Button
        CreateButton("Teleport to Player", UDim2.new(0, 0, 0, 65), function()
            local targetName = PlayerDropdown.Text
            if targetName ~= "" then
                TeleportToPlayer(targetName)
            end
        end)
        
        -- Refresh Players Button
        CreateButton("Refresh Players List", UDim2.new(0, 0, 0, 105), function()
            UpdatePlayersList()
        end)
        
        -- Players List Label
        local PlayersListLabel = Instance.new("TextLabel")
        PlayersListLabel.Name = "PlayersListLabel"
        PlayersListLabel.Size = UDim2.new(1, -10, 0, 20)
        PlayersListLabel.Position = UDim2.new(0, 0, 0, 145)
        PlayersListLabel.BackgroundTransparency = 1
        PlayersListLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        PlayersListLabel.Text = "Online Players (Click to select):"
        PlayersListLabel.TextXAlignment = Enum.TextXAlignment.Left
        PlayersListLabel.Parent = ContentFrame
        
        -- Scrollable Players Frame
        PlayersScrollFrame = Instance.new("ScrollingFrame")
        PlayersScrollFrame.Name = "PlayersScrollFrame"
        PlayersScrollFrame.Size = UDim2.new(1, -10, 0, 200)
        PlayersScrollFrame.Position = UDim2.new(0, 0, 0, 170)
        PlayersScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        PlayersScrollFrame.BorderSizePixel = 0
        PlayersScrollFrame.ScrollBarThickness = 8
        PlayersScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        PlayersScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        PlayersScrollFrame.Parent = ContentFrame
        
        UpdatePlayersList()
        
    elseif CurrentTab == "Follow" then
        -- Player Dropdown Label
        local DropdownLabel = Instance.new("TextLabel")
        DropdownLabel.Name = "DropdownLabel"
        DropdownLabel.Size = UDim2.new(1, -10, 0, 20)
        DropdownLabel.Position = UDim2.new(0, 0, 0, 0)
        DropdownLabel.BackgroundTransparency = 1
        DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        DropdownLabel.Text = "Select Player to Follow:"
        DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        DropdownLabel.Parent = ContentFrame
        
        -- Player Dropdown
        local FollowDropdown = Instance.new("TextBox")
        FollowDropdown.Name = "FollowDropdown"
        FollowDropdown.Size = UDim2.new(1, -10, 0, 30)
        FollowDropdown.Position = UDim2.new(0, 0, 0, 25)
        FollowDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        FollowDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
        FollowDropdown.PlaceholderText = "Enter player name..."
        FollowDropdown.Text = ""
        FollowDropdown.Parent = ContentFrame
        
        -- Start Follow Button
        CreateButton("Start Follow", UDim2.new(0, 0, 0, 65), function()
            local targetName = FollowDropdown.Text
            if targetName ~= "" and not Following then
                StartFollow(targetName)
            end
        end)
        
        -- Stop Follow Button
        CreateButton("Stop Follow", UDim2.new(0, 0, 0, 105), function()
            if Following then
                StopFollow()
            end
        end)
        
        -- Status Label
        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Name = "StatusLabel"
        StatusLabel.Size = UDim2.new(1, -10, 0, 20)
        StatusLabel.Position = UDim2.new(0, 0, 0, 145)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        StatusLabel.Text = "Status: Not Following"
        StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
        StatusLabel.Parent = ContentFrame
        
        -- Refresh Players Button
        CreateButton("Refresh Players List", UDim2.new(0, 0, 0, 175), function()
            UpdateFollowPlayersList()
        end)
        
        -- Players List Label
        local FollowPlayersListLabel = Instance.new("TextLabel")
        FollowPlayersListLabel.Name = "FollowPlayersListLabel"
        FollowPlayersListLabel.Size = UDim2.new(1, -10, 0, 20)
        FollowPlayersListLabel.Position = UDim2.new(0, 0, 0, 215)
        FollowPlayersListLabel.BackgroundTransparency = 1
        FollowPlayersListLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        FollowPlayersListLabel.Text = "Online Players (Click to select):"
        FollowPlayersListLabel.TextXAlignment = Enum.TextXAlignment.Left
        FollowPlayersListLabel.Parent = ContentFrame
        
        -- Scrollable Players Frame for Follow
        local FollowPlayersScrollFrame = Instance.new("ScrollingFrame")
        FollowPlayersScrollFrame.Name = "FollowPlayersScrollFrame"
        FollowPlayersScrollFrame.Size = UDim2.new(1, -10, 0, 150)
        FollowPlayersScrollFrame.Position = UDim2.new(0, 0, 0, 240)
        FollowPlayersScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        FollowPlayersScrollFrame.BorderSizePixel = 0
        FollowPlayersScrollFrame.ScrollBarThickness = 8
        FollowPlayersScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
        FollowPlayersScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        FollowPlayersScrollFrame.Parent = ContentFrame
        
        local function UpdateFollowPlayersList()
            if not FollowPlayersScrollFrame then return end
            
            -- Clear existing player buttons
            FollowPlayersScrollFrame:ClearAllChildren()
            
            local players = game:GetService("Players"):GetPlayers()
            local buttonHeight = 25
            local totalHeight = 0
            
            for i, targetPlayer in pairs(players) do
                if targetPlayer ~= Player then
                    local PlayerButton = Instance.new("TextButton")
                    PlayerButton.Name = "PlayerButton"
                    PlayerButton.Size = UDim2.new(1, -5, 0, buttonHeight)
                    PlayerButton.Position = UDim2.new(0, 2, 0, (i-1)*buttonHeight)
                    PlayerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    PlayerButton.BorderSizePixel = 0
                    PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    PlayerButton.Text = targetPlayer.Name
                    PlayerButton.TextSize = 12
                    PlayerButton.Parent = FollowPlayersScrollFrame
                    
                    PlayerButton.MouseButton1Click:Connect(function()
                        FollowDropdown.Text = targetPlayer.Name
                    end)
                    
                    PlayerButton.MouseEnter:Connect(function()
                        PlayerButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    end)
                    
                    PlayerButton.MouseLeave:Connect(function()
                        PlayerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    end)
                    
                    totalHeight = totalHeight + buttonHeight
                end
            end
            
            -- Update scroll frame size
            FollowPlayersScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        end
        
        UpdateFollowPlayersList()
        
    elseif CurrentTab == "Troll" then
        -- Push Players Toggle
        CreateToggle("Push Players", UDim2.new(0, 0, 0, 0), function(state)
            PushPlayers = state
            if PushPlayers then
                StartPushPlayers()
            else
                StopPushPlayers()
            end
        end)
        
        -- Spin Players Toggle
        CreateToggle("Spin Players", UDim2.new(0, 0, 0, 40), function(state)
            SpinPlayers = state
            if SpinPlayers then
                StartSpinPlayers()
            else
                StopSpinPlayers()
            end
        end)
        
        -- Float Players Toggle
        CreateToggle("Float Players", UDim2.new(0, 0, 0, 80), function(state)
            FloatPlayers = state
            if FloatPlayers then
                StartFloatPlayers()
            else
                StopFloatPlayers()
            end
        end)
        
        -- Camera Shake Button
        CreateButton("Camera Shake", UDim2.new(0, 0, 0, 120), function()
            CameraShake()
        end)
        
        -- Info Label
        local InfoLabel = Instance.new("TextLabel")
        InfoLabel.Name = "InfoLabel"
        InfoLabel.Size = UDim2.new(1, -10, 0, 40)
        InfoLabel.Position = UDim2.new(0, 0, 0, 160)
        InfoLabel.BackgroundTransparency = 1
        InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 150)
        InfoLabel.Text = "Use Noclip + these functions to troll players effectively"
        InfoLabel.TextSize = 12
        InfoLabel.TextWrapped = true
        InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
        InfoLabel.Parent = ContentFrame
        
    elseif CurrentTab == "Tools" then
        -- Get Delete Tool Button
        CreateButton("Get Delete Tool", UDim2.new(0, 0, 0, 0), function()
            local tool = Instance.new("Tool")
            tool.Name = "DeleteTool"
            tool.RequiresHandle = false
            tool.Parent = Player.Backpack
            
            tool.Activated:Connect(function()
                local target = Mouse.Target
                if target then
                    target:Destroy()
                end
            end)
        end)
        
        -- Anti-Cheat Bypass Button
        CreateButton("Anti-Cheat Bypass", UDim2.new(0, 0, 0, 40), function()
            for _, connection in pairs(getconnections(game:GetService("ScriptContext").Error)) do
                connection:Disable()
            end
            for _, child in pairs(ContentFrame:GetChildren()) do
                if child:IsA("TextButton") and child.Text == "Anti-Cheat Bypass" then
                    child.Text = "Bypass Activated"
                    wait(1)
                    child.Text = "Anti-Cheat Bypass"
                end
            end
        end)
        
        -- Load Infinite Yield Button
        CreateButton("Load Infinite Yield", UDim2.new(0, 0, 0, 80), function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
    end
end

function UpdatePlayersList()
    if not PlayersScrollFrame then return end
    
    -- Clear existing player buttons
    PlayersScrollFrame:ClearAllChildren()
    
    local players = game:GetService("Players"):GetPlayers()
    local buttonHeight = 25
    local totalHeight = 0
    
    for i, targetPlayer in pairs(players) do
        if targetPlayer ~= Player then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Name = "PlayerButton"
            PlayerButton.Size = UDim2.new(1, -5, 0, buttonHeight)
            PlayerButton.Position = UDim2.new(0, 2, 0, (i-1)*buttonHeight)
            PlayerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            PlayerButton.BorderSizePixel = 0
            PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerButton.Text = targetPlayer.Name
            PlayerButton.TextSize = 12
            PlayerButton.Parent = PlayersScrollFrame
            
            PlayerButton.MouseButton1Click:Connect(function()
                PlayerDropdown.Text = targetPlayer.Name
                SelectedPlayer = targetPlayer.Name
            end)
            
            PlayerButton.MouseEnter:Connect(function()
                PlayerButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            end)
            
            PlayerButton.MouseLeave:Connect(function()
                PlayerButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end)
            
            totalHeight = totalHeight + buttonHeight
        end
    end
    
    -- Update scroll frame size
    PlayersScrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

function TeleportToPlayer(playerName)
    local targetPlayer = game:GetService("Players"):FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end

-- Follow Functions
function StartFollow(playerName)
    local targetPlayer = game:GetService("Players"):FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Following = true
            FollowTarget = targetPlayer
            
            -- Update status
            local statusLabel = ContentFrame:FindFirstChild("StatusLabel")
            if statusLabel then
                statusLabel.Text = "Status: Following " .. playerName
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            end
            
            -- Start follow loop
            FollowConnection = RunService.Heartbeat:Connect(function()
                if not Following or not FollowTarget or not FollowTarget.Character then
                    StopFollow()
                    return
                end
                
                local targetRoot = FollowTarget.Character:FindFirstChild("HumanoidRootPart")
                local myRoot = Player.Character:FindFirstChild("HumanoidRootPart")
                
                if targetRoot and myRoot then
                    -- Calculate position behind the target (3 studs behind)
                    local backOffset = targetRoot.CFrame.LookVector * -3
                    local newPosition = targetRoot.Position + backOffset + Vector3.new(0, 0, 0)
                    
                    -- Move to position behind target
                    myRoot.CFrame = CFrame.new(newPosition, targetRoot.Position)
                end
            end)
        end
    end
end

function StopFollow()
    Following = false
    FollowTarget = nil
    
    if FollowConnection then
        FollowConnection:Disconnect()
        FollowConnection = nil
    end
    
    -- Update status
    local statusLabel = ContentFrame:FindFirstChild("StatusLabel")
    if statusLabel then
        statusLabel.Text = "Status: Not Following"
        statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Troll Functions
function StartPushPlayers()
    PushConnection = RunService.Heartbeat:Connect(function()
        if not PushPlayers then return end
        
        for _, targetPlayer in pairs(game:GetService("Players"):GetPlayers()) do
            if targetPlayer ~= Player and targetPlayer.Character then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                
                if targetRoot and myRoot then
                    local distance = (targetRoot.Position - myRoot.Position).Magnitude
                    if distance < 10 then -- Push radius
                        local direction = (targetRoot.Position - myRoot.Position).Unit
                        local pushForce = direction * 50 -- Push strength
                        
                        -- Apply push force
                        targetRoot.Velocity = targetRoot.Velocity + pushForce
                    end
                end
            end
        end
    end)
end

function StopPushPlayers()
    if PushConnection then
        PushConnection:Disconnect()
        PushConnection = nil
    end
end

function StartSpinPlayers()
    SpinConnection = RunService.Heartbeat:Connect(function()
        if not SpinPlayers then return end
        
        for _, targetPlayer in pairs(game:GetService("Players"):GetPlayers()) do
            if targetPlayer ~= Player and targetPlayer.Character then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if targetRoot then
                    -- Create or update spin force
                    local spin = targetRoot:FindFirstChild("YnvSpin")
                    if not spin then
                        spin = Instance.new("BodyAngularVelocity")
                        spin.Name = "YnvSpin"
                        spin.MaxTorque = Vector3.new(0, math.huge, 0)
                        spin.P = 1000
                        spin.AngularVelocity = Vector3.new(0, 20, 0) -- Spin speed
                        spin.Parent = targetRoot
                    end
                end
            end
        end
    end)
end

function StopSpinPlayers()
    if SpinConnection then
        SpinConnection:Disconnect()
        SpinConnection = nil
    end
    
    -- Remove all spin effects
    for _, targetPlayer in pairs(game:GetService("Players"):GetPlayers()) do
        if targetPlayer.Character then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local spin = targetRoot:FindFirstChild("YnvSpin")
                if spin then
                    spin:Destroy()
                end
            end
        end
    end
end

function StartFloatPlayers()
    FloatConnection = RunService.Heartbeat:Connect(function()
        if not FloatPlayers then return end
        
        for _, targetPlayer in pairs(game:GetService("Players"):GetPlayers()) do
            if targetPlayer ~= Player and targetPlayer.Character then
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                local myRoot = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                
                if targetRoot and myRoot then
                    local distance = (targetRoot.Position - myRoot.Position).Magnitude
                    if distance < 15 then -- Float radius
                        -- Create or update float force
                        local float = targetRoot:FindFirstChild("YnvFloat")
                        if not float then
                            float = Instance.new("BodyVelocity")
                            float.Name = "YnvFloat"
                            float.MaxForce = Vector3.new(0, math.huge, 0)
                            float.Velocity = Vector3.new(0, 10, 0) -- Float upward
                            float.Parent = targetRoot
                        end
                    else
                        -- Remove float if too far
                        local float = targetRoot:FindFirstChild("YnvFloat")
                        if float then
                            float:Destroy()
                        end
                    end
                end
            end
        end
    end)
end

function StopFloatPlayers()
    if FloatConnection then
        FloatConnection:Disconnect()
        FloatConnection = nil
    end
    
    -- Remove all float effects
    for _, targetPlayer in pairs(game:GetService("Players"):GetPlayers()) do
        if targetPlayer.Character then
            local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local float = targetRoot:FindFirstChild("YnvFloat")
                if float then
                    float:Destroy()
                end
            end
        end
    end
end

function CameraShake()
    local camera = workspace.CurrentCamera
    local originalPosition = camera.CFrame
    
    for i = 1, 30 do -- Shake duration
        local offset = Vector3.new(
            math.random(-2, 2),
            math.random(-1, 1),
            math.random(-2, 2)
        )
        camera.CFrame = originalPosition + offset
        wait(0.05)
    end
    
    camera.CFrame = originalPosition
end

function CreateToggle(name, position, callback)
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = name
    ToggleButton.Size = UDim2.new(1, -10, 0, 30)
    ToggleButton.Position = position
    ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Text = name .. ": OFF"
    ToggleButton.Parent = ContentFrame
    
    local originalColor = ToggleButton.BackgroundColor3
    
    ToggleButton.MouseButton1Click:Connect(function()
        local newState = ToggleButton.Text:find("OFF") and true or false
        ToggleButton.Text = name .. ": " .. (newState and "ON" or "OFF")
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 100)
        
        callback(newState)
        
        wait(1)
        ToggleButton.BackgroundColor3 = newState and Color3.fromRGB(100, 255, 100) or originalColor
    end)
end

function CreateSlider(name, position, default, min, max, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = name
    SliderFrame.Size = UDim2.new(1, -10, 0, 50)
    SliderFrame.Position = position
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = ContentFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Position = UDim2.new(0, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Text = name .. ": " .. default
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local Slider = Instance.new("TextBox")
    Slider.Size = UDim2.new(1, 0, 0, 25)
    Slider.Position = UDim2.new(0, 0, 0, 25)
    Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Slider.TextColor3 = Color3.fromRGB(255, 255, 255)
    Slider.Text = tostring(default)
    Slider.Parent = SliderFrame
    
    Slider.FocusLost:Connect(function()
        local value = tonumber(Slider.Text) or default
        value = math.clamp(value, min, max)
        Slider.Text = tostring(value)
        Label.Text = name .. ": " .. value
        callback(value)
    end)
end

function CreateButton(name, position, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, -10, 0, 30)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = name
    Button.Parent = ContentFrame
    
    Button.MouseButton1Click:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(255, 255, 100)
        callback()
        wait(1)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
    end)
end

-- Improved ESP Function
function ActivateESP()
    ESPEnabled = true
    
    -- Clear existing connections
    for _, connection in pairs(ESPConnections) do
        connection:Disconnect()
    end
    ESPConnections = {}
    
    local function AddESP(player)
        if player == Player then return end
        
        local function ApplyHighlight()
            if player.Character then
                -- Remove existing highlight
                local existingHighlight = player.Character:FindFirstChild("YnvESP")
                if existingHighlight then
                    existingHighlight:Destroy()
                end
                
                -- Create new highlight
                local highlight = Instance.new("Highlight")
                highlight.Name = "YnvESP"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = player.Character
                highlight.Adornee = player.Character
            end
        end
        
        -- Apply ESP immediately if character exists
        if player.Character then
            ApplyHighlight()
        end
        
        -- Connect to character added event
        local characterConnection = player.CharacterAdded:Connect(function(character)
            wait(1) -- Wait for character to fully load
            if ESPEnabled then
                ApplyHighlight()
            end
        end)
        
        table.insert(ESPConnections, characterConnection)
    end
    
    -- Add ESP to all existing players
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        AddESP(player)
    end
    
    -- Add ESP to new players
    local playerAddedConnection = game:GetService("Players").PlayerAdded:Connect(function(player)
        if ESPEnabled then
            AddESP(player)
        end
    end)
    
    table.insert(ESPConnections, playerAddedConnection)
end

function DeactivateESP()
    ESPEnabled = false
    
    -- Disconnect all connections
    for _, connection in pairs(ESPConnections) do
        connection:Disconnect()
    end
    ESPConnections = {}
    
    -- Remove all highlights
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player.Character then
            local highlight = player.Character:FindFirstChild("YnvESP")
            if highlight then
                highlight:Destroy()
            end
        end
    end
end

-- Freeze Function
function ActivateFreeze()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local humanoid = Player.Character.Humanoid
        OriginalWalkSpeed = humanoid.WalkSpeed
        OriginalJumpPower = humanoid.JumpPower
        
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        
        -- Stop animations
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
        end
        
        -- Freeze body parts
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = true
            end
        end
    end
end

function DeactivateFreeze()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local humanoid = Player.Character.Humanoid
        humanoid.WalkSpeed = OriginalWalkSpeed
        humanoid.JumpPower = OriginalJumpPower
        
        -- Unfreeze body parts
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Anchored = false
            end
        end
    end
end

-- Improved Smooth Fly Function
function ActivateSmoothFly()
    if FLYING then return end
    
    local Torso = Player.Character:FindFirstChild("HumanoidRootPart")
    if not Torso then return end
    
    FLYING = true
    
    -- Remove existing body velocity
    if BODYVELOCITY then
        BODYVELOCITY:Destroy()
    end
    
    -- Create new body velocity
    BODYVELOCITY = Instance.new("BodyVelocity")
    BODYVELOCITY.Velocity = Vector3.new(0, 0, 0)
    BODYVELOCITY.MaxForce = Vector3.new(40000, 40000, 40000)
    BODYVELOCITY.P = 1250
    BODYVELOCITY.Parent = Torso
    
    local Camera = workspace.CurrentCamera
    local FlyKeys = {
        Forward = false,
        Backward = false,
        Left = false,
        Right = false,
        Up = false,
        Down = false
    }
    
    -- Key handling
    local function onInputBegan(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            FlyKeys.Forward = true
        elseif input.KeyCode == Enum.KeyCode.S then
            FlyKeys.Backward = true
        elseif input.KeyCode == Enum.KeyCode.A then
            FlyKeys.Left = true
        elseif input.KeyCode == Enum.KeyCode.D then
            FlyKeys.Right = true
        elseif input.KeyCode == Enum.KeyCode.Space then
            FlyKeys.Up = true
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            FlyKeys.Down = true
        end
    end
    
    local function onInputEnded(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.W then
            FlyKeys.Forward = false
        elseif input.KeyCode == Enum.KeyCode.S then
            FlyKeys.Backward = false
        elseif input.KeyCode == Enum.KeyCode.A then
            FlyKeys.Left = false
        elseif input.KeyCode == Enum.KeyCode.D then
            FlyKeys.Right = false
        elseif input.KeyCode == Enum.KeyCode.Space then
            FlyKeys.Up = false
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            FlyKeys.Down = false
        end
    end
    
    UIS.InputBegan:Connect(onInputBegan)
    UIS.InputEnded:Connect(onInputEnded)
    
    -- Smooth fly loop
    FlyConnection = RunService.Heartbeat:Connect(function()
        if not FLYING or not Torso then
            FlyConnection:Disconnect()
            return
        end
        
        local direction = Vector3.new(0, 0, 0)
        
        -- Get camera direction for free movement
        local camCF = Camera.CFrame
        local lookVector = camCF.LookVector
        local rightVector = camCF.RightVector
        local upVector = Vector3.new(0, 1, 0)
        
        -- Apply movement based on camera direction
        if FlyKeys.Forward then
            direction = direction + lookVector
        end
        if FlyKeys.Backward then
            direction = direction - lookVector
        end
        if FlyKeys.Right then
            direction = direction + rightVector
        end
        if FlyKeys.Left then
            direction = direction - rightVector
        end
        if FlyKeys.Up then
            direction = direction + upVector
        end
        if FlyKeys.Down then
            direction = direction - upVector
        end
        
        -- Normalize and apply speed
        if direction.Magnitude > 0 then
            direction = direction.Unit * FlySpeed
        end
        
        BODYVELOCITY.Velocity = direction
    end)
end

function DeactivateFly()
    FLYING = false
    if BODYVELOCITY then
        BODYVELOCITY:Destroy()
        BODYVELOCITY = nil
    end
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
end

-- Infinite Jump (FIXED Jump Power)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJump and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- Initialize
UpdateContent()
