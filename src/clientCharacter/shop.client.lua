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
local shopScroll = shopFrame:WaitForChild("itemBarFront"):WaitForChild("shopScroll")
local buyBtn = shopFrame:WaitForChild("buyBtn")
local buyItemRE = ShopRemotes:WaitForChild("buyItemRE")

local selectedItem = nil
openShopBtn.Activated:Connect(function()
	shopFrame.Visible = not shopFrame.Visible
end)
closeShopBtn.Activated:Connect(function()
	shopFrame.Visible = not shopFrame.Visible
end)

shopScroll.ChildAdded:Connect(function(itemFrame)
    if itemFrame:IsA("Frame") then
        itemFrame:FindFirstChild("itemBtn").Activated:Connect(function()
            selectedItem = itemFrame
            local playerSelectedItem = shopFrame:FindFirstChild("ItemSelectedImg"):FindFirstChild("actualItem")
            local image = itemFrame.itemBtn.itemFrame.image
            playerSelectedItem.Image = image.Image
            local Description = shopFrame.descitemFrameFG.Description
            Description.Text = itemFrame:GetAttribute("Damage") .. " Damage, Cost " .. itemFrame:GetAttribute("Cost") .. " Smorgs"
            
        end)
    end
end)

buyBtn.Activated:Connect(function()
    if selectedItem then
        print("Trying to buy and fired .. " .. selectedItem.Name)
        buyItemRE:FireServer(selectedItem)
    end
end)