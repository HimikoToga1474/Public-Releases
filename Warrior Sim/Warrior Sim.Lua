--Library
spawn(function()
    for i,v in pairs(game.CoreGui:GetDescendants()) do
        if v.Name == "ScreenGui" and v:FindFirstChild("Container") then
            v:Destroy()
        end
    end
end)
wait(0.1)
local library = loadstring(game:HttpGet("https://pastebin.com/raw/Y33wKG6S", true))()
library.options.underlinecolor = "rainbow"
local Main = library:CreateWindow("Main")
--Library

--Variables
local localPlayer = game:GetService("Players").LocalPlayer

_G.KillAura = false
_G.InstaKill = false
_G.AutoFarming = false
_G.Noclip = false
--Variables

--Functions
local function GetCharacter()
	local char = game:GetService("Players").LocalPlayer.Character or game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
	if char then return char else return false end
end

function GetClosestMob()
    local ClosestMob = nil
    local ShortestDistance = math.huge
    
    pcall(function()
        for i, v in pairs(workspace.Map:GetDescendants()) do
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health ~= 0 and v:FindFirstChild("HumanoidRootPart") then
                local magnitude = (v.HumanoidRootPart.Position - GetCharacter().HumanoidRootPart.Position).magnitude

                if magnitude < ShortestDistance then
                    ClosestMob = v
                    ShortestDistance = magnitude
                end
            end
        end
    end)

    return ClosestMob
end

function GetClosestCoin()
    local ClosestPickup = nil
    local ShortestDistance = math.huge
    
    pcall(function()
        for i, v in pairs(workspace.Map:GetDescendants()) do
            if v.Name == "Detector" and v.Parent.Parent.Name == "CoinStorage" then
                local magnitude = (v.Position - GetCharacter().HumanoidRootPart.Position).magnitude

                if magnitude < ShortestDistance then
                    ClosestPickup = v
                    ShortestDistance = magnitude
                end
            end
        end
    end)

    return ClosestPickup
end

function GetClosestGinger()
    local ClosestPickup = nil
    local ShortestDistance = math.huge
    
    pcall(function()
        for i, v in pairs(workspace.Winter.Collectibles:GetChildren()) do
            if v.ClassName == "Model" and v:FindFirstChild("Main") then
                local magnitude = (v.Main.Position - GetCharacter().HumanoidRootPart.Position).magnitude

                if magnitude < ShortestDistance then
                    ClosestPickup = v
                    ShortestDistance = magnitude
                end
            end
        end
    end)

    return ClosestPickup
end
--Functions

--Script
Main:Button("Unlock All Areas", function()
    game:GetService("Players").LocalPlayer.Data.Zone.Value = 9
end)

Main:Toggle("Kill Aura", {flag = ""}, function(State)
    _G.KillAura = State
    coroutine.wrap(function()
        while _G.KillAura and wait() do
            for i,v in pairs(workspace.Map:GetDescendants()) do
                if v.ClassName == "Model" and v:FindFirstChildOfClass("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude < 50 then
                        local userdata_1 = v.Humanoid;
                        local userdata_2 = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Model");
                        local userdata_3 = Vector3.new(0,0,0);
                        local number_1 = 5;
                        local Target = game:GetService("ReplicatedStorage").RemoteEvents.Client.SwordAttack;
                        Target:FireServer(userdata_1, userdata_2, userdata_3, number_1);
                    end
                end
            end
        end
    end)()
end)

Main:Toggle("AutoFarm", {flag = "Af"}, function(State)
    _G.AutoFarming = State
    _G.Noclip = State
    coroutine.wrap(function()
        while _G.AutoFarming and wait() do
            local Mob = GetClosestMob()
            if Mob:FindFirstChild("Humanoid") and Mob:FindFirstChild("HumanoidRootPart") then
                repeat
                    wait()
                    GetCharacter().HumanoidRootPart.CFrame = Mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 15)
                until Mob.Humanoid.Health == 0 or not _G.AutoFarming
            end
        end
    end)()
end)

Main:Toggle("Coin Farm", {flag = "cf"}, function(State)
    _G.CoinFarm = State
    coroutine.wrap(function()
        while _G.CoinFarm and wait() do
            pcall(function()
                local Pickup = GetClosestCoin()
                GetCharacter().HumanoidRootPart.CFrame = Pickup.CFrame
            end)
        end
    end)()
end)

Main:Toggle("Gingerbread Farm", {flag = "pf"}, function(State)
    _G.GingerFarm = State
    coroutine.wrap(function()
        while _G.GingerFarm and wait() do
            pcall(function()
                local Pickup = GetClosestGinger()
                GetCharacter().HumanoidRootPart.CFrame = Pickup.Main.CFrame
                Pickup.Main.Touched:Connect(function()
                    wait(0.2)
                    Pickup.Main:Destroy()
                end)
            end)
        end
    end)()
end)
--Script

--Constants
game:GetService('RunService').Stepped:connect(function()
    if _G.Noclip then
        GetCharacter():WaitForChild("Humanoid"):ChangeState(11)
    end
end)
--Constants
