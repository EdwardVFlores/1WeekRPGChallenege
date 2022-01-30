local DEBUG = true

local ServerStorage = game:GetService("ServerStorage")
local Events = ServerStorage:WaitForChild("events")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Functions = ServerStorage:WaitForChild("functions")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ShopRemotes = Remotes:WaitForChild("Shops")
local Players = game:GetService("Players")
local shopStorage = ReplicatedStorage:WaitForChild("Shop")
local buyItemRF = ShopRemotes:WaitForChild("buyItemRF")
local canBuyF = Functions:WaitForChild("canBuyF")
local swords = ReplicatedStorage:WaitForChild("Swords"):GetChildren()
local sendInventoryE = Events:WaitForChild("sendInventoryE")


function putSwordsInShop(player)
    print("Fired swords in shpo")
    local playerGui = player:WaitForChild("PlayerGui")
    local shopGui = playerGui:WaitForChild("ShopGui")
    local shopItemScroll = shopGui:WaitForChild("Shop"):WaitForChild("ShopScroll")
    for index, sword in ipairs(swords) do
        print("adding sword to shop")
        local swordsFrame = shopStorage:WaitForChild("Swords"):Clone()
        local itemImg = swordsFrame:FindFirstChild("itemImg")
        local itemNameLabel = swordsFrame:FindFirstChild("itemName")
        local descriptionLabel = swordsFrame:FindFirstChild("itemDescription")
		swordsFrame:SetAttribute("SwordName", sword.Name)
        for attribute, value in pairs(sword:GetAttributes()) do
            swordsFrame:SetAttribute(attribute, value)
        end
		itemImg.Image = sword.TextureId
        swordsFrame.Name = sword:GetAttribute("Cost") .. sword.Name
        itemNameLabel.Text = sword.Name
        descriptionLabel.Text = "Cost: " .. sword:GetAttribute("Cost") .. "\n" ..sword:GetAttribute("Damage") .. " Damage"
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
    print("Reached server smiley")
    if findSword then
        if canBuyF:Invoke(player, findSword) then
            sendInventoryE:Fire(player)
            return true;
        end
    end
    return false;
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
buyItemRF.OnServerInvoke = getSwordFromFrame
