local CoreGui = game:GetService("CoreGui")
local UserInput = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Interface = import("rbxassetid://11389137937")

if oh.Cache["ui/main"] then
    return Interface
end

import("ui/controls/TabSelector")
local MessageBox, MessageType = import("ui/controls/MessageBox")

local RemoteSpy = import("ui/modules/RemoteSpy")
local ClosureSpy = import("ui/modules/ClosureSpy")
local ScriptScanner = import("ui/modules/ScriptScanner")
local ModuleScanner = import("ui/modules/ModuleScanner")
local UpvalueScanner = import("ui/modules/UpvalueScanner")
local ConstantScanner = import("ui/modules/ConstantScanner")

local constants = {
    opened = UDim2.new(0.5, -325, 0.5, -175),
    closed = UDim2.new(0.5, -325, 0, -400),
    reveal = UDim2.new(0.5, -15, 0, 20),
    conceal = UDim2.new(0.5, -15, 0, -75)
}

local Open = Interface.Open
local Base = Interface.Base
local Drag = Base.Drag
local Status = Base.Status
local Collapse = Drag.Collapse

function oh.setStatus(text)
    Status.Text = '• Status: ' .. text
end

function oh.getStatus()
    return Status.Text:gsub('• Status: ', '')
end

local dragging
local dragStart
local startPos

Drag.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local dragEnded 

        dragging = true
        dragStart = input.Position
        startPos = Base.Position

        dragEnded = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                dragEnded:Disconnect()
            end
        end)
    end
end)

oh.Events.Drag = UserInput.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Base.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

Open.MouseButton1Click:Connect(function()
    Open:TweenPosition(constants.conceal, "Out", "Quad", 0.15)
    Base:TweenPosition(constants.opened, "Out", "Quad", 0.15)
end)

Collapse.MouseButton1Click:Connect(function()
    Base:TweenPosition(constants.closed, "Out", "Quad", 0.15)
    Open:TweenPosition(constants.reveal, "Out", "Quad", 0.15)
end)

Interface.Name = HttpService:GenerateGUID(false)
if getHui then
    Interface.Parent = getHui()
else
    if syn then
        syn.protect_gui(Interface)
    end

    Interface.Parent = CoreGui
end

return Interface
