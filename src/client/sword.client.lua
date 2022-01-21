local CollectionService = game:GetService("CollectionService")
local swordRE = game.ReplicatedStorage.Remotes.Swords.RE.DoDamage
local player = game.Players.LocalPlayer

local connection
function activated(sword)
    print(sword)
    if(CollectionService:HasTag(sword, "sword")) then
        print("added equipped connection")
        connection = sword.Equipped:Connect(function() 
            print("added unequipped connection")
            sword.Unequipped:Connect(function()
                print("disconnected")
                connection:Disconnect()
            end)
            swordRE:FireServer(sword)
        end)

        
    end
end
local backPack = player.Backpack
if backPack then 
    backPack.ChildAdded:Connect(activated)
end
