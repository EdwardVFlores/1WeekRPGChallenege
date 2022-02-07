local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InventoryStorage = ReplicatedStorage:WaitForChild("Inventory")
local setUpInventoryRE = InventoryStorage:WaitForChild("setUpInventory")
local equipMyItemRE = InventoryStorage:WaitForChild("equipMyItem")
local player = game:GetService("Players").LocalPlayer

local StarterGui = game:GetService("StarterGui")
local inventoryGui = player:WaitForChild("PlayerGui"):WaitForChild("InventoryGui")
local inventorySlot = inventoryGui:WaitForChild("EquippedItems"):WaitForChild("InventorySlot1")
local inventory = inventoryGui:WaitForChild("Inventory")
local inventoryScroll = inventory:WaitForChild("scroll")
local openBtn = inventoryGui:WaitForChild("openBtn")
local closeBtn = inventory:WaitForChild("closeBtn")

local weilding = false
local equippedTool
local equippedItem
function weildItem(tool, wield)
    equipMyItemRE:FireServer(tool, wield)
end

function toolToInventorySlot(inventorySlotFrame)
    local inventoryItems = player:FindFirstChild("Inventory"):GetChildren() -- If item is in inventory
    local counter = 0
    repeat
        task.wait()
        counter += 1
        print(#inventoryItems)
        inventoryItems = player:FindFirstChild("Inventory"):GetChildren()
    until #inventoryItems > 0 or counter > 10
    local character = player.Character
    if character and #inventoryItems > 0 then
        for _, item in ipairs(inventoryItems) do
            if item:IsA("Tool") then
                item.Parent = inventorySlotFrame
            end
        end
    end
end

function weildAble(inventorySlotFrame)
    if inventorySlotFrame then
        ContextActionService:BindAction("Wieldable",function(name, state, object)
            if state == Enum.UserInputState.End then
                if not weilding then
                    equippedTool = inventorySlotFrame:FindFirstChildWhichIsA("Tool")
                    weildItem(equippedTool, true)
                    weilding = true
                else
                    weildItem(equippedTool, false)
                    toolToInventorySlot(inventorySlotFrame)
                    weilding = false
                end
            end
        end, true, Enum.KeyCode.One)
    end
end

function equipItem(inventoryFrame)
    local character = player.Character
    if not character then return end
    if equippedItem == nil then -- Not holding item
        inventoryFrame.Parent = inventorySlot
        weildAble(inventoryFrame)
    elseif equippedItem == inventoryFrame then  -- Putting holding item back into inventory
       equippedItem.Parent = inventoryScroll
       equippedItem = nil
       ContextActionService:UnbindAction("Wieldable")
    else -- Swapping holding item with inventory item
        equippedItem.Parent = inventoryScroll
        inventoryFrame.Parent = inventorySlot
        weildAble(inventoryFrame)
    end
end

function addItemsToInventory(tool)
    local inventoryFrame = InventoryStorage:WaitForChild("InventoryItem"):Clone()
    local itemBtn = inventoryFrame:FindFirstChild("itemBtn")
    itemBtn.Image = tool.TextureId
    tool.Parent = inventoryFrame
    inventoryFrame.Parent = inventoryScroll
    itemBtn.Activated:Connect(function()
        equipItem(inventoryFrame)
    end)
end

closeBtn.Activated:Connect(function()
    inventory.Visible = not inventory.Visible
end)

openBtn.Activated:Connect(function()
    inventory.Visible = not inventory.Visible
end)


setUpInventoryRE.OnClientEvent:Connect(addItemsToInventory)
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)