local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = script.Parent:FindFirstChild("modules")
local swords = require(Modules:FindFirstChild("swords"))
local swordAttack = require(game.ReplicatedStorage.Shared.swordAttack)
local swordRE = game.ReplicatedStorage.Remotes.Swords.RE.DoDamage
local swordsFolder = ReplicatedStorage:FindFirstChild("Swords"):GetChildren()

function playAttack(player, sword)
    swordAttack.attack(player, sword)
end

function createSwords()
    local count = 1
    for sword, swordStat in pairs(swords) do
        swordsFolder[count].Name = sword
        for statName, value in pairs(swordStat) do
            swordsFolder[count]:SetAttribute(statName, value)
        end
        count+=1
    end
end

function main()
    createSwords()
end

main()

swordRE.OnServerEvent:Connect(playAttack)