-- Corrected Fly Script (W forward, S backward)

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flying = false
local speed = 50
local control = {F=0,B=0,L=0,R=0,U=0,D=0}
local lastControl = {F=0,B=0,L=0,R=0,U=0,D=0}

function Fly()
	flying = true
	local BodyGyro = Instance.new("BodyGyro")
	local BodyVel = Instance.new("BodyVelocity")
	BodyGyro.P = 9e4
	BodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
	BodyGyro.CFrame = HumanoidRootPart.CFrame
	BodyGyro.Parent = HumanoidRootPart
	BodyVel.Velocity = Vector3.new(0,0,0)
	BodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
	BodyVel.Parent = HumanoidRootPart

	RunService.RenderStepped:Connect(function()
		if flying then
			BodyGyro.CFrame = workspace.CurrentCamera.CFrame
			local new = Vector3.new(
				(control.R - control.L) * speed,
				(control.U - control.D) * speed,
				-(control.F - control.B) * speed -- FIX: invert Z
			)
			if new ~= Vector3.zero then
				BodyVel.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(new)
				lastControl = control
			else
				BodyVel.Velocity = workspace.CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new(
					(lastControl.R - lastControl.L) * speed,
					(lastControl.U - lastControl.D) * speed,
					-(lastControl.F - lastControl.B) * speed
				)) * 0.9
			end
		else
			BodyGyro:Destroy()
			BodyVel:Destroy()
		end
	end)
end

-- Keybinds
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.F then
		flying = not flying
		if flying then Fly() end
	elseif input.KeyCode == Enum.KeyCode.W then
		control.F = 1
	elseif input.KeyCode == Enum.KeyCode.S then
		control.B = 1
	elseif input.KeyCode == Enum.KeyCode.A then
		control.L = 1
	elseif input.KeyCode == Enum.KeyCode.D then
		control.R = 1
	elseif input.KeyCode == Enum.KeyCode.Space then
		control.U = 1
	elseif input.KeyCode == Enum.KeyCode.LeftShift then
		control.D = 1
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.W then
		control.F = 0
	elseif input.KeyCode == Enum.KeyCode.S then
		control.B = 0
	elseif input.KeyCode == Enum.KeyCode.A then
		control.L = 0
	elseif input.KeyCode == Enum.KeyCode.D then
		control.R = 0
	elseif input.KeyCode == Enum.KeyCode.Space then
		control.U = 0
	elseif input.KeyCode == Enum.KeyCode.LeftShift then
		control.D = 0
	end
end)

print("Press F to toggle Fly")
