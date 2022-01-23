local CollectionService = game:GetService("CollectionService")
local swordRE = game.ReplicatedStorage.Remotes.Swords.RE.DoDamage
local player = game.Players.LocalPlayer

local activatedCooldown = false
function activated(sword)
	if(CollectionService:HasTag(sword, "Sword")) and not sword:GetAttribute("Connected") then
		sword:SetAttribute("Connected", true)
		sword.Activated:Connect(function()
			if activatedCooldown then return end
			activatedCooldown = true
            print("backpack connection")
			swordRE:FireServer(sword)
			task.wait(1)
			activatedCooldown = false
		end)
	end
end

local backPack = player.Backpack
if backPack then 
	backPack.ChildAdded:Connect(activated)
end
