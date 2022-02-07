local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ShopRemotes = Remotes:WaitForChild("Shops")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local shopGui = playerGui:WaitForChild("ShopGui")
local shopFrame = shopGui:WaitForChild("Shop")
local openShopBtn = shopGui:WaitForChild("openShop"):WaitForChild("openBtn")
local closeShopBtn = shopFrame:WaitForChild("closeBtn")
local shopScroll = shopFrame:WaitForChild("ShopScroll")
local buyBtn = shopFrame:WaitForChild("buyBtn")
local buyItemRF = ShopRemotes:WaitForChild("buyItemRF")

local selectedItem = nil
openShopBtn.Activated:Connect(function()
	shopFrame.Visible = not shopFrame.Visible
end)
closeShopBtn.Activated:Connect(function()
	shopFrame.Visible = not shopFrame.Visible
end)

local function checkInventory(item)
    local inventory = player:WaitForChild("Inventory")
    if inventory then
        local inv = inventory:GetChildren()
        for _, tool in ipairs(inv) do
            print(tool.Name .. " " .. item.itemName.Text)
            if tool.Name == item.itemName.Text then
                return true
            end
        end
    end
    return false
end

shopScroll.ChildAdded:Connect(function(itemFrame)
    if itemFrame:IsA("Frame") then
        itemFrame:FindFirstChild("itemBtn").Activated:Connect(function()
            if selectedItem then
                selectedItem.itemBtn.Image = "rbxassetid://8680948872"
            end
            selectedItem = itemFrame
            selectedItem.itemBtn.Image = "rbxassetid://8681303844"
            local playerSelectedItem = shopFrame:FindFirstChild("selectedItemImg")
            local image = itemFrame.itemImg
            playerSelectedItem.Image = image.Image
            local Description = shopFrame.selectedItemDesc
            Description.Text = itemFrame:GetAttribute("Damage") .. " Damage, \nCost " .. itemFrame:GetAttribute("Cost") .. " Smorgs"
            if checkInventory(selectedItem) then
                buyBtn.Image = "rbxassetid://8681424835"
                buyBtn.HoverImage = "rbxassetid://8681424835"
                buyBtn.Active = false
            else 
                buyBtn.Image = "rbxassetid://8681174183"
                buyBtn.HoverImage = "rbxassetid://8681170584"
                buyBtn.Active = true
            end
        end)
    end
end)

buyBtn.Activated:Connect(function()
    if selectedItem then
        print("Trying to buy and fired .. " .. selectedItem.Name)
        if buyItemRF:InvokeServer(selectedItem) then
            buyBtn.Image = "rbxassetid://8681424835"
            buyBtn.HoverImage = "rbxassetid://8681424835"
            buyBtn.Active = false
        end
    end
end)