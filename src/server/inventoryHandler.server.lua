local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local swordsFolder = ReplicatedStorage:WaitForChild("Swords"):GetChildren()
local serverEvents = ServerStorage:WaitForChild("events")
local sendInventoryE = serverEvents:WaitForChild("sendInventoryE")
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
    end
    
    inventory.Name = "NewInventory"
    inventory.Parent = player
    task.wait(.5)
    inventory.Name = "Inventory"
    --TODO MAKE INVENTORY GUI TO PUT IN BACKPACK
    local backpack = player.Backpack
    backpack:ClearAllChildren()
    print("Put inventory in backpack")
    if backpack then
        
        for _, sword in ipairs(inventory:GetChildren()) do
            if player.Character:FindFirstChild(sword.Name) and player.Character[sword.Name]:IsA("Tool") then
                print("equipped already")
            else
                local swordClone = sword:Clone()
                swordClone.Parent = backpack
                swordDamageE:Fire(swordClone)
            end
        end
    end
   
end

sendInventoryE.Event:Connect(sendInventory)