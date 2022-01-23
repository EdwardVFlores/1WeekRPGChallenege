local DEBUG = false
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local Events = ServerStorage:WaitForChild("events")
local Functions = ServerStorage:WaitForChild("functions")
local sendMoneyE = Events:WaitForChild("sendMoneyE")
local sendExpE = Events:WaitForChild("sendExpE")
local Services = ServerScriptService:WaitForChild("Server"):WaitForChild("services")
local canBuyF = Functions:WaitForChild("canBuyF")
local ds2 = require(Services:WaitForChild("DataStore2"))

ds2.Combine("DATA", "playerData")

local databaseTable = {
    Smorgs = 0,
    Exp = 0,
    Swords = {"Noob Sword"},
}

function initDatabase(player)
    local playerData = ds2("playerData", player)

    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"

    local smorgs = Instance.new("NumberValue")

    local data = playerData:GetTable(databaseTable)
    smorgs.Value = data["Smorgs"]
    smorgs.Name = "Smorgs"
    smorgs.Parent = leaderstats
    player:SetAttribute("Smorgs", data["Smorgs"])
    player:SetAttribute("Exp", data["Exp"])
    leaderstats.Parent = player
end

function getMoney(player)
    local playerData = ds2("playerData", player)
    local data = playerData:GetTable(databaseTable)
    return data["Smorgs"]
end


function giveMoney(player, money)
    local playerData = ds2("playerData", player)

    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
    end
    local smorgs = leaderstats:FindFirstChild("Smorgs")
    if not smorgs then warn("No smorgs in leaderstats for some awful reason") return end
    local data = playerData:GetTable(databaseTable)

    data["Smorgs"] += money

    playerData:Set(data)
    player:SetAttribute("Smorgs", data["Smorgs"])

    -- Leaderboard (We might not need this)
    smorgs.Value = data["Smorgs"]
end

function giveExp(player, expAmount)
    local playerData = ds2("playerData", player)
    local data = playerData:GetTable(databaseTable)
    data["Exp"] += expAmount
    playerData:Set(data)
    player:SetAttribute("Exp", data["Exp"])
end

function giveSword(player, sword)
    
    if DEBUG then 
        print("so watcha buying :3")
    end
    local cost = sword:GetAttribute("Cost")
    if DEBUG then
        print(cost)
        print(getMoney(player))
    end
    if getMoney(player) >= cost then
        giveMoney(player, -cost)
        local playerData = ds2("playerData", player)
        local data = playerData:GetTable(databaseTable)
        table.insert(data["Swords"],sword.Name)
        playerData:Set(data)
        return true
    else 
        return false
    end
end


Players.PlayerAdded:Connect(initDatabase)
sendMoneyE.Event:Connect(giveMoney)
sendExpE.Event:Connect(giveExp)
canBuyF.OnInvoke = giveSword