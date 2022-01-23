local Players = game:GetService("Players")


function defaultValuesPlayer(player)
    player:SetAttribute("Attacking", false)
end

function defaultValuesCharacter(character)
    local player = Players:GetPlayerFromCharacter(character)
    defaultValuesPlayer(player)
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
