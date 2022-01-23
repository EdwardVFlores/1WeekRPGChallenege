local DEBUG = true

local ServerStorage = game:GetService("ServerStorage")
local Events = ServerStorage:WaitForChild("events")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Functions = ServerStorage:WaitForChild("functions")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ShopRemotes = Remotes:WaitForChild("Shops")
local Players = game:GetService("Players")
local shopStorage = ReplicatedStorage:WaitForChild("Shop")
local buyItemRE = ShopRemotes:WaitForChild("buyItemRE")
local canBuyF = Functions:WaitForChild("canBuyF")
local swordDamageE = Events:WaitForChild("connectSwordDamage")
local swords = ReplicatedStorage:WaitForChild("Swords"):GetChildren()


function putSwordsInShop(player)
    print("Fired swords in shpo")
    local playerGui = player:WaitForChild("PlayerGui")
    local shopGui = playerGui:WaitForChild("ShopGui")
    local shopItemScroll = shopGui:WaitForChild("Shop"):WaitForChild("itemBarFront"):WaitForChild("shopScroll")
    for index, sword in ipairs(swords) do
        print("adding sword to shop")
        local swordsFrame = shopStorage:WaitForChild("Swords"):Clone()
        local itemBtn = swordsFrame:FindFirstChild("itemBtn")
        local itemImg = itemBtn:FindFirstChild("itemFrame"):FindFirstChild("image")
        local itemNameLabel = itemBtn:FindFirstChild("SwordNameLabel")
        local descriptionLabel = itemBtn:FindFirstChild("Description")
		swordsFrame:SetAttribute("SwordName", sword.Name)
        for attribute, value in pairs(sword:GetAttributes()) do
            swordsFrame:SetAttribute(attribute, value)
        end
		itemImg.Image = sword.TextureId
        swordsFrame.Name = sword:GetAttribute("Cost") .. sword.Name
        itemNameLabel.Text = sword.Name
        descriptionLabel.Text = sword:GetAttribute("Damage") .. " Damage"
        swordsFrame.Parent = shopItemScroll
    end
end

function getSwordFromFrame(player, frame)
    local findSword = nil
    for i, sword in pairs(swords) do
        if frame:GetAttribute("SwordName") == sword.Name then
            findSword = sword
        end
    end
    print(findSword)
    if findSword then
        if canBuyF:Invoke(player, findSword) then
            print("bought")
            -- TODO: put sword in inventory system
            local backpack = player.Backpack
            if not backpack then 
                    if DEBUG then 
                        warn("No backpack on player wtf?")
                    end
                return
            end
            local swordClone = findSword:Clone()
            -- Connect damage to this clone
            if DEBUG then
                print("we connected the damage :)")
            end
            swordClone.Parent = backpack
            swordDamageE:Fire(swordClone)
        end
    end
end

local function reconnectShop(player)
    player.CharacterAdded:Connect(function(character)
        local plr = Players:GetPlayerFromCharacter(character)
        if plr then
            task.wait(.5) -- Need this because character resets gui's on deaths
            putSwordsInShop(plr)
        end
    end)
end

Players.PlayerAdded:Connect(reconnectShop)
buyItemRE.OnServerEvent:Connect(getSwordFromFrame)
