local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local inventoryStorage = ReplicatedStorage:WaitForChild("Inventory")
local setUpInventoryRE = inventoryStorage:WaitForChild("setUpInventory")
local swordsFolder = ReplicatedStorage:WaitForChild("Swords"):GetChildren()
local serverEvents = ServerStorage:WaitForChild("events")
local sendInventoryE = serverEvents:WaitForChild("sendInventoryE")
local equipMyItemRE = inventoryStorage:WaitForChild("equipMyItem")
local ServerScriptService = game:GetService("ServerScriptService")
local Server = ServerScriptService:WaitForChild("Server")
local Services = Server:WaitForChild("services")
local swordDamageE = serverEvents:WaitForChild("connectSwordDamage")
local Debris = game:GetService("Debris")

local ds2 = require(Services:WaitForChild("DataStore2"))

ds2.Combine("DATA", "playerData")
local databaseTable = {
    Smorgs = 0,
    Exp = 0,
    Swords = {},
}

function sendInventory(player, putInBackpack)
    local foundInventory = player:FindFirstChild("Inventory")
    if player:FindFirstChild("Inventory") then
        foundInventory:Destroy()
    end
    local playerData = ds2("playerData", player)
    local data = playerData:Get(databaseTable)
    local inventory = Instance.new("Folder")
    for _, sword in pairs(data["Swords"]) do
        local foundSword = nil
        for _, tool in pairs(swordsFolder) do
            if sword == tool.Name then
                foundSword = tool
            end
        end
        if not foundSword then return end
        local clonedSword = foundSword:Clone()
        clonedSword.Parent = inventory
        swordDamageE:Fire(clonedSword)
    end
    inventory.Name = "Inventory"
    inventory.Parent = player

    for i, tool in pairs(inventory:GetChildren()) do
        setUpInventoryRE:FireClient(player,tool)
    end
end

function equipMyItem(player, tool, wield)
    local playerInventory = player:FindFirstChild("Inventory")
    local character = player.Character
    if not character then return end
    if not wield and playerInventory then
        for i, v in ipairs(character:GetChildren()) do
            if v == tool then
                print("Put in inventory")
                v.Parent = playerInventory
            end
        end
    elseif wield and playerInventory then
        for i, v in ipairs(playerInventory:GetChildren()) do
            if v == tool then
                v.Parent = character
            end
        end
    end
end

sendInventoryE.Event:Connect(sendInventory)
equipMyItemRE.OnServerEvent:Connect(equipMyItem)