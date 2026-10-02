-- Santer Hub Script

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Santer Hub",
   LoadingTitle = "Santer Hub Loading...",
   LoadingSubtitle = "by Faisal",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SanterHubConfig",
      FileName = "BigConfig"
   },
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

----------------------------------------------------
-- Variables
----------------------------------------------------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- ICBM Settings
local ICBMSpeed = 50
local ICBMActive = false

-- Shield / Domain Settings
local ShieldActive = false
local ShieldSizeLevel = 3 -- Default medium (1 to 5)
local ShieldFolder = Instance.new("Folder", Workspace)
ShieldFolder.Name = "SanterShieldFolder"

-- Super Throw Settings
local ThrowForce = 500

----------------------------------------------------
-- Toys Mode Tab
----------------------------------------------------
local ToysTab = Window:CreateTab("Toys Mode", 4483362458) -- Icon ID

-- ICBM Missile Launch
ToysTab:CreateButton({
   Name = "Launch ICBM Rocket",
   Callback = function()
      local char = LocalPlayer.Character
      if not char or not char:FindFirstChild("HumanoidRootPart") then return end
      
      local hrp = char.HumanoidRootPart
      local rocket = Instance.new("Part")
      rocket.Size = Vector3.new(2, 8, 2)
      rocket.CFrame = hrp.CFrame + Vector3.new(0, 10, 0)
      rocket.BrickColor = BrickColor.new("Bright red")
      rocket.Material = Enum.Material.Neon
      rocket.CanCollide = false
      rocket.Parent = Workspace
      
      local bv = Instance.new("BodyVelocity")
      bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
      bv.Velocity = Vector3.new(0, ICBMSpeed, 0)
      bv.Parent = rocket
      
      game:GetService("Debris"):AddItem(rocket, 10)
   end,
})

-- ICBM Speed Slider
ToysTab:CreateSlider({
   Name = "ICBM Rocket Speed",
   Range = {10, 500},
   Increment = 5,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "ICBMSpeedSlider",
   Callback = function(Value)
      ICBMSpeed = Value
   end,
})

ToysTab:CreateSection("Shield Protection")

-- Function to build Domain Shield
local function BuildShield()
   ShieldFolder:ClearAllChildren()
   if not ShieldActive then return end
   
   local char = LocalPlayer.Character
   if not char or not char:FindFirstChild("HumanoidRootPart") then return end
   
   -- Radius scaling based on level (1 to 5)
   -- Level 1 = Small (15), Level 3 = Medium (35), Level 5 = Large (60)
   local radiusMap = {
      [1] = 15,
      [2] = 25,
      [3] = 35,
      [4] = 48,
      [5] = 60
   }
   local radius = radiusMap[ShieldSizeLevel] or 35
   local segments = 16
   local center = char.HumanoidRootPart.Position
   
   for i = 1, segments do
      local angle = (i / segments) * math.pi * 2
      local nextAngle = ((i + 1) / segments) * math.pi * 2
      
      local x1 = math.cos(angle) * radius
      local z1 = math.sin(angle) * radius
      local x2 = math.cos(nextAngle) * radius
      local z2 = math.sin(nextAngle) * radius
      
      local wall = Instance.new("Part")
      wall.Name = "ShieldWall"
      wall.Material = Enum.Material.Wood
      wall.BrickColor = BrickColor.new("Wood")
      wall.Anchored = true
      wall.CanCollide = true
      
      local pos1 = center + Vector3.new(x1, 0, z1)
      local pos2 = center + Vector3.new(x2, 0, z2)
      local dist = (pos1 - pos2).Magnitude
      
      wall.Size = Vector3.new(2, radius * 1.2, dist)
      wall.CFrame = CFrame.new((pos1 + pos2) / 2, pos1)
      wall.Parent = ShieldFolder
   end
end

-- Shield Toggle
ToysTab:CreateToggle({
   Name = "Shield (Domain Shield)",
   CurrentValue = false,
   Flag = "ShieldToggle",
   Callback = function(Value)
      ShieldActive = Value
      if ShieldActive then
         BuildShield()
      else
         ShieldFolder:ClearAllChildren()
      end
   end,
})

-- Shield Size Slider (1 to 5)
ToysTab:CreateSlider({
   Name = "Shield Size (1: Small | 3: Medium | 5: Large)",
   Range = {1, 5},
   Increment = 1,
   Suffix = "Level",
   CurrentValue = 3,
   Flag = "ShieldSizeSlider",
   Callback = function(Value)
      ShieldSizeLevel = Value
      if ShieldActive then
         BuildShield()
      end
   end,
})

----------------------------------------------------
-- Combat / Throw Section
----------------------------------------------------
local MainTab = Window:CreateTab("Main Features", 4483363465)

MainTab:CreateSlider({
   Name = "Super Throw Force",
   Range = {200, 10000},
   Increment = 100,
   Suffix = "Force",
   CurrentValue = 500,
   Flag = "SuperThrowSlider",
   Callback = function(Value)
      ThrowForce = Value
   end,
})

-- Apply Super Throw to held tools
RunService.Stepped:Connect(function()
   local char = LocalPlayer.Character
   if char then
      local tool = char:FindFirstChildOfClass("Tool")
      if tool and tool:FindFirstChild("Handle") then
         tool.Handle.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5, 1, 1)
      end
   end
end)

Rayfield:Notify({
   Title = "Santer Hub",
   Content = "Script loaded successfully!",
   Duration = 5,
   Image = 4483362458,
})
