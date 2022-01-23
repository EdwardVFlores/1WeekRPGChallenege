local DEBUG = false

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local swordAttack = require(game.ReplicatedStorage.Shared.swordAttack)
local swordRE = game.ReplicatedStorage.Remotes.Swords.RE.DoDamage
local swordsFolder = ReplicatedStorage:FindFirstChild("Swords"):GetChildren()
local Players = game:GetService("Players")
local sendMoneyE = ServerStorage:WaitForChild("events"):WaitForChild("sendMoneyE")
local sendExpE = ServerStorage:WaitForChild("events"):WaitForChild("sendExpE")


function playAttack(player, sword)
    swordAttack.attack(player, sword)
end

function damageOnSwords(sword, parent)
    if sword == nil or parent == nil then return end
    local hitbox = sword:FindFirstChild("HitBox")
    if not hitbox then 
        warn("No hitbox for some goddamn reason :[")
        return
	end
    local cooldown = false
    hitbox.Touched:Connect(function(part)
        if cooldown then return end
        cooldown = true
        
        if part.Parent == nil then
            return
		end
		if CollectionService:HasTag(part.Parent, "Mob") then
            local mob = part.Parent
            if not mob then return end
            local humanoid = mob:FindFirstChildWhichIsA("Humanoid")
            if not humanoid then if debug then warn("Ayo no fucking humanoid fix yo sht") end return end
            if humanoid.Health > 0 then
                humanoid:TakeDamage(sword:GetAttribute("Damage"))
                if debug then
                    print(sword:GetAttribute("Damage"))
                end
            end
            if humanoid.Health < 1 then
                local character = sword.Parent
                if not character then return end
                local player = Players:GetPlayerFromCharacter(character)
                if not player then return end
                sendMoneyE:Fire(player,mob:GetAttribute("smorgDrop"))
                sendExpE:Fire(player,mob:GetAttribute("expDrop"))
            end
        end
        task.wait(1)
        cooldown = false
    end)
end

function main()
end

swordRE.OnServerEvent:Connect(playAttack)
while true do
    for _, sword in pairs(CollectionService:GetTagged("Sword")) do
        if debug then warn("Ayo wasup we working in swordcoll") end
        sword.AncestryChanged:Connect(damageOnSwords)
    end
    task.wait(1)
end

main() 