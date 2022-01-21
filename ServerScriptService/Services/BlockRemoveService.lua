local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)
local trove = require(ReplicatedStorage.Packages.Trove)



local BlockRemoveService = Knit.CreateService {
    Name = "BlockRemoveService";
    Client = {};
}
local spawns = workspace:FindFirstChild("Spawns"):GetChildren()
function BlockRemoveService:StartGame()

    trove:Add(Players.PlayerAdded:Connect(function(player)
        local tycoon = ReplicatedStorage:FindFirstChild("Tycoon"):Clone()
        trove:Add(tycoon)
        tycoon:SetAttribute("owner", player.Name)
        local playerSpawn = nil
        for _, spawnPoint in ipairs(spawns) do
            if not spawnPoint:GetAttribute("occupied") then
                playerSpawn = spawnPoint
            end
        end
        if playerSpawn then
            tycoon:PivotTo(playerSpawn.CFrame)
            tycoon.Parent = workspace
        end
    end))
end

function BlockRemoveService:KnitStart()
    
end


function BlockRemoveService:KnitInit()
    self:StartGame()
    trove:Add(Players.PlayerRemoving:Connect(function(player)
        trove:Clean()
    end))
end


return BlockRemoveService
