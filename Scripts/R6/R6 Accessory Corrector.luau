--
-- Copyright (c) 2020-2026 Branquinho Studios.
--
-- Purpose: Convert bad quality R6 acessories to good quality acessories.
-- Authors: Jonas Malveira Menezes (jonasmenezes4641@gmail.com).
--

local AssetService = game:GetService("AssetService")
local Players = game:GetService("Players")
local Player = Players:GetPlayerFromCharacter(script.Parent)
Player.CharacterAppearanceLoaded:Wait()

local Player = script.Parent

local function ConvertAccessory(accessory: Accessory)
	-- We always expect the acessory have an 'Handle'
	local handle = accessory:FindFirstChild("Handle")
	if handle and handle:IsA("BasePart") then
		local specialMesh = handle:FindFirstChildWhichIsA("SpecialMesh")
		
		-- Set the mesh configuration obteined from the special mesh
		local success, msg = pcall(function(...)
			local handleMesh = AssetService:CreateMeshPartAsync(
				specialMesh.MeshId, -- Mesh ID
				{
					CollisionFidelity = Enum.CollisionFidelity.Default
				}
			)
			handleMesh.TextureID = specialMesh.TextureId
			handleMesh.Name = "Handle"
		end)
		
		if not success then
			warn("Error while converting acessory " .. accessory.Name .. ": " .. msg)
			return nil
		end
		
		-- Pick all instances from the original acessory handle, and
		-- apply to the new handle
		for _, instance in handle:GetChildren() do
			if instance:IsA("Weld") then
				instance.Part0 = handleMesh
			end
			instance.Parent = handleMesh
		end
		
		-- Set the new handle
		handle:Destroy()
		handleMesh.Parent = accessory
	end
	-- There's nothing to do, the acessory is already gone. (Without doing nothing)
	return nil
end

for _, accessory in pairs(script.Parent:GetChildren()) do
	if accessory:IsA("Accessory") then
		ConvertAccessory(accessory)
	end
end
