local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventoryStorage = ReplicatedStorage:WaitForChild("Inventory")
local player = game:GetService("Players").LocalPlayer

local inventoryGui = player:WaitForChild("PlayerGui"):WaitForChild("InventoryGui")
local inventory = inventoryGui:WaitForChild("Inventory")
local inventoryScroll = inventory:WaitForChild("scroll")
local openBtn = inventoryGui:WaitForChild("openBtn")
local closeBtn = inventory:WaitForChild("closeBtn")
local viewportFrame = inventory:WaitForChild("characterVP")

function addCharacterToInventory()
    local cloneModel = Players:CreateHumanoidModelFromUserId(player.UserId)

    if cloneModel then
        cloneModel.Parent = workspace
        task.wait(1)
        cloneModel.Parent = viewportFrame
        
        local primaryPart = cloneModel.PrimaryPart
        local Offset =  CFrame.new(0, 0, 7)
        
        local viewportCamera = Instance.new("Camera")
        viewportFrame.CurrentCamera = viewportCamera
        viewportCamera.Parent = viewportFrame

        task.spawn(function()
            while true do
                for i = 1, 360 do
                    viewportCamera.CFrame = primaryPart.CFrame * CFrame.Angles(0,math.rad(i),0) * Offset
                    task.wait()
                end
            end
        end)
        viewportCamera.CFrame = CFrame.new(Vector3.new(0, 2, 12), primaryPart.Position)
    else 
        print(cloneModel)
    end
end

function addItemsToInventory()
    local playerInventory = player:WaitForChild("Inventory"):GetChildren()
    
    for i, tool in pairs(playerInventory) do
        local inventoryFrame = InventoryStorage:WaitForChild("InventoryItem"):Clone()
        local itemBtn = inventoryFrame:FindFirstChild("itemBtn")
        itemBtn.Image = tool.TextureId
        inventoryFrame.Parent = inventoryScroll
    end
end

closeBtn.Activated:Connect(function()
    inventory.Visible = not inventory.Visible
end)

openBtn.Activated:Connect(function()
    inventory.Visible = not inventory.Visible
end)

addCharacterToInventory()
addItemsToInventory()
