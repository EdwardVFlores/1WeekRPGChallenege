local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local serverEvents = ServerStorage:WaitForChild("events")
local sendInventoryE = serverEvents:WaitForChild("sendInventoryE")

function defaultValuesPlayer(player, fromCharacter)
    player:SetAttribute("Attacking", false)
end

function defaultValuesCharacter(character)
    local player = Players:GetPlayerFromCharacter(character)
    sendInventoryE:Fire(player, true)
    defaultValuesPlayer(player, true)
end

Players.PlayerAdded:Connect(function(player)
    defaultValuesPlayer(player)
    player.CharacterAdded:Connect(function(character)
        print("Player died reseting things for " .. player.Name)
        defaultValuesCharacter(character)
    end)
end)
Players.PlayerRemoving:Connect(function(player)
    defaultValuesPlayer(player)
end)
