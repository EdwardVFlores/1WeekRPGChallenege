local DEBUG = true

-- SERVICES

local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local combatStorage = ReplicatedStorage:WaitForChild(("Combat"))
local events = ServerStorage:WaitForChild("events")
local swordAttack = require(game.ReplicatedStorage.Shared.swordAttack)
local swordRE = game.ReplicatedStorage.Remotes.Swords.RE.DoDamage
local swordsFolder = ReplicatedStorage:FindFirstChild("Swords"):GetChildren()
local Players = game:GetService("Players")
local sendMoneyE = events:WaitForChild("sendMoneyE")
local sendExpE = events:WaitForChild("sendExpE")
local connectSwordDamageE = events:WaitForChild("connectSwordDamage")
local damageBillboard = combatStorage:WaitForChild("DamageDealt")


function playAttack(player, sword)
    sword.HitBox.CanTouch = true
    swordAttack.attack(player, sword)
    
    while player:GetAttribute("Attacking") do
        print("Attacking")
        task.wait()
    end
    sword.HitBox.CanTouch = false
end

function showDamageDealt(mob, damage)
	local damageClone = damageBillboard:Clone()
	damageClone.Parent = mob
    local damageText = damageClone:FindFirstChild("DamageDealt")
    damageText.Text = damage
    TweenService:Create(damageClone,TweenInfo.new(.5),{StudsOffset = Vector3.new(math.random(-2,2),math.random(4,6),0)}):Play()
    TweenService:Create(damageText,TweenInfo.new(.5),{Size = UDim2.new(.5,0,.5,0)}):Play()
    Debris:AddItem(damageClone,.5)
end

function damageOnSwords(sword)
    print("actually put damage 1")
    if sword == nil then return end
    if sword.Parent == nil then return end
    
    local hitbox = sword:FindFirstChild("HitBox")
    if not hitbox then 
        warn("No hitbox for some goddamn reason :[")
        return
	end
    --print("actually put damage 2")
    
    
    hitbox.Touched:Connect(function(part)
        print("Hitbox")
        local character = sword.Parent
        if not character then return end
        local player = Players:GetPlayerFromCharacter(character)
        if not player then return end
        if part.Parent == nil then return end
        local mob = part.Parent
        if not mob then return end
        if CollectionService:HasTag(mob, "Mob") and not mob:GetAttribute(character.Name.."DamageCooldown") then
            mob:SetAttribute(character.Name.."DamageCooldown", true)
            local humanoid = mob:FindFirstChildWhichIsA("Humanoid")
            if not humanoid then if debug then warn("Ayo no fucking humanoid fix yo sht") end return end
			if humanoid.Health > 0 then
				showDamageDealt(mob, sword:GetAttribute("Damage"))
                humanoid:TakeDamage(sword:GetAttribute("Damage"))
                if debug then
                    print(sword:GetAttribute("Damage"))
                end
                if humanoid.Health < 1 then
                    
                    sendMoneyE:Fire(player,mob:GetAttribute("smorgDrop"))
                    sendExpE:Fire(player,mob:GetAttribute("expDrop"))
                end
            end
            while player:GetAttribute("Attacking") do
                print("CooldownForMobDamage")
                task.wait()
            end
            
            mob:SetAttribute(character.Name.."DamageCooldown", false)
        end
    end)
end

function main()
end

swordRE.OnServerEvent:Connect(playAttack)
connectSwordDamageE.Event:Connect(damageOnSwords)

main() 