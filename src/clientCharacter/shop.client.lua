local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local shopGui = playerGui:WaitForChild("ShopGui")
local openShopBtn = shopGui:WaitForChild("openShop"):WaitForChild("openBtn")
local shopFrame = shopGui:WaitForChild("Shop")

openShopBtn.Activated:Connect(function()
	shopFrame.Visible = not shopFrame.Visible
end)