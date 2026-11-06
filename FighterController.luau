-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("StarterGui")
game:GetService("RunService")
local v_u_3 = game:GetService("Players")
require(v_u_1.Modules.CONSTANTS)
local v_u_4 = require(v_u_1.Modules.EnumLibrary)
local v_u_5 = require(v_u_1.Modules.Utility)
require(v_u_3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.ReplicatedController)
local v_u_9 = v_u_3.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("DefaultCharacter")
local v_u_10 = setmetatable({}, v_u_8)
v_u_10.__index = v_u_10
function v_u_10._new() -- name: _new
	-- upvalues: (copy) v_u_8, (copy) v_u_10
	local v11 = v_u_8.new("Fighter")
	local v12 = v_u_10
	local v13 = setmetatable(v11, v12)
	v13.LocalFighter = nil
	v13._network_id_map = {}
	v13._last_encoded_camera_rotation = nil
	v13._last_connection_level = nil
	v13._player_to_fighter = {}
	v13._model_to_fighter = {}
	v13._last_controls_replicated_time = 0
	v13._character_model_cache = {}
	v13:_Init()
	return v13
end
function v_u_10.GetFighter(p14, p15) -- name: GetFighter
	-- upvalues: (copy) v_u_3
	local v16 = p14._player_to_fighter[p15] or p14._model_to_fighter[p15]
	if v16 then
		return v16
	elseif p15 then
		if typeof(p15) == "Instance" then
			if not p15:IsA("Player") then
				return p14:GetFighter(v_u_3:GetPlayerFromCharacter(p15))
			end
			for v17, v18 in pairs(p14.Objects) do
				if v18.Player == p15 then
					return v18, v17
				end
			end
			return nil
		end
		if typeof(p15) == "number" then
			return p14:GetFighter(v_u_3:GetPlayerByUserId(p15))
		end
		local v19 = "Argument 1 invalid, expected a Player or a Model or nil, got " .. tostring(p15) .. " (type: " .. (typeof(p15) == "Instance" and p15.ClassName or typeof(p15)) .. ")"
		assert(false, v19)
	end
end
function v_u_10.GetFighterFromNetworkID(p20, p21) -- name: GetFighterFromNetworkID
	return p20._network_id_map[p21]
end
function v_u_10.GetFightersNotInDuel(p22) -- name: GetFightersNotInDuel
	local v23 = {}
	for _, v24 in pairs(p22.Objects) do
		if not v24:Get("IsInDuel") then
			table.insert(v23, v24)
		end
	end
	return v23
end
function v_u_10.GetEntities(p25) -- name: GetEntities
	local v26 = {}
	for _, v27 in pairs(p25.Objects) do
		if v27.Entity then
			local v28 = v27.Entity
			table.insert(v26, v28)
		end
	end
	return v26
end
function v_u_10.GetFighterModels(p29, p30) -- name: GetFighterModels
	local v31 = {}
	for _, v32 in pairs(p29.Objects) do
		if v32.Entity and not (p30 and v32.IsLocalPlayer) then
			local v33 = v32.Entity.Model
			table.insert(v31, v33)
		end
	end
	return v31
end
function v_u_10.GetWrap(p34, p35) -- name: GetWrap
	for _, v36 in pairs(p34.Objects) do
		local v37 = v36:GetItem(p35)
		if v37 then
			return v37:GetWrap()
		end
	end
end
function v_u_10.WaitForFighter(p38, ...) -- name: WaitForFighter
	while true do
		local v39 = p38:GetFighter(...)
		if v39 then
			break
		end
		p38.ObjectAdded:Wait()
	end
	return v39
end
function v_u_10.WaitForLocalFighter(p40) -- name: WaitForLocalFighter
	-- upvalues: (copy) v_u_3
	return p40:WaitForFighter(v_u_3.LocalPlayer)
end
function v_u_10.GenerateCharacterModel(p_u_41, p_u_42, p43) -- name: GenerateCharacterModel
	-- upvalues: (copy) v_u_3, (copy) v_u_9
	if p_u_41._character_model_cache[tostring(p_u_42)] then
		return p_u_41._character_model_cache[tostring(p_u_42)]
	end
	local function v50() -- name: generate
		-- upvalues: (ref) v_u_3, (copy) p_u_42, (copy) p_u_41
		local v44, v45 = pcall(v_u_3.GetHumanoidDescriptionFromUserIdAsync, v_u_3, p_u_42)
		if v44 then
			v45.Torso = 15365012259
			v45.LeftArm = 15365010034
			v45.RightArm = 15365012263
			v45.LeftLeg = 15365010038
			v45.RightLeg = 15365010030
			local v46, v47 = pcall(v_u_3.CreateHumanoidModelFromDescriptionAsync, v_u_3, v45, Enum.HumanoidRigType.R15)
			if v46 then
				p_u_41._preloaded_character_model = v47
				local v48 = {
					["Template"] = v47
				}
				local v49 = p_u_42
				p_u_41._character_model_cache[tostring(v49)] = v48
				return v48
			end
			warn("Failed to create humanoid model:", v47)
		else
			warn("Failed to fetch humanoid description:", v45)
		end
	end
	if p43 then
		return v50()
	end
	task.spawn(v50)
	return p_u_41._character_model_cache[tostring(p_u_42)] or {
		["Template"] = v_u_9
	}
end
function v_u_10._VerifyEntityLoop(p_u_51) -- name: _VerifyEntityLoop
	-- upvalues: (copy) v_u_3, (copy) v_u_1
	local function v53() -- name: is_inaccurate
		-- upvalues: (copy) p_u_51, (ref) v_u_3
		local v52 = not (p_u_51.LocalFighter:Get("IsInDuel") or p_u_51.LocalFighter:Get("IsInShootingRange"))
		if v52 then
			v52 = not (v_u_3.LocalPlayer.Character and p_u_51.LocalFighter.Entity) or p_u_51.LocalFighter.Entity.Model ~= v_u_3.LocalPlayer.Character
		end
		return v52
	end
	while wait(1) do
		if v53() then
			wait(2)
			if v53() then
				v_u_1.Remotes.Replication.Fighter.VerifyClientEntity:FireServer()
				wait(10)
			end
		end
	end
end
function v_u_10._ConnectionLevelReplicationLoop(p54) -- name: _ConnectionLevelReplicationLoop
	-- upvalues: (copy) v_u_5, (copy) v_u_1
	while true do
		repeat
			wait(1)
		until p54.LocalFighter and p54.LocalFighter:Get("IsInDuel")
		local v55 = v_u_5:GetConnectionLevel((v_u_5:GetLocalConnectionPing()))
		if v55 ~= p54._last_connection_level then
			p54._last_connection_level = v55
			v_u_1.Remotes.Replication.Fighter.UpdateConnectionLevel:FireServer(v55)
		end
	end
end
function v_u_10._UpdateNetworkIDMap(p56) -- name: _UpdateNetworkIDMap
	p56._network_id_map = {}
	for _, v57 in pairs(p56.Objects) do
		local v58 = v57:Get("DecodedNetworkID")
		if v58 then
			p56._network_id_map[v58] = v57
		end
	end
end
function v_u_10._FighterAdded(p_u_59, p_u_60) -- name: _FighterAdded
	p_u_60:GetDataChangedSignal("DecodedNetworkID"):Connect(function()
		-- upvalues: (copy) p_u_59
		p_u_59:_UpdateNetworkIDMap()
	end)
	p_u_60.EntityAdded:Connect(function(p61)
		-- upvalues: (copy) p_u_59, (copy) p_u_60
		p_u_59._model_to_fighter[p61.Model] = p_u_60
	end)
	p_u_60.EntityRemoved:Connect(function(_)
		-- upvalues: (copy) p_u_59, (copy) p_u_60
		for v62, v63 in pairs(p_u_59._model_to_fighter) do
			if v63 == p_u_60 then
				p_u_59._model_to_fighter[v62] = nil
			end
		end
	end)
	if p_u_60.Entity and p_u_60.Entity.Model then
		p_u_59._model_to_fighter[p_u_60.Entity.Model] = p_u_60
	end
	p_u_59._player_to_fighter[p_u_60.Player] = p_u_60
	p_u_59:_UpdateNetworkIDMap()
end
function v_u_10._ReplicateControls(p64) -- name: _ReplicateControls
	-- upvalues: (copy) v_u_6, (copy) v_u_1
	if p64.LocalFighter then
		local v65 = 0.2 - (tick() - p64._last_controls_replicated_time)
		local v66 = math.max(v65, 0.2)
		task.delay(v66, function()
			-- upvalues: (ref) v_u_6, (ref) v_u_1
			local v67 = v_u_6.CurrentControls
			if typeof(v67) == "string" then
				v_u_1.Remotes.Replication.Fighter.SetControls:FireServer(v_u_6.CurrentControls)
			end
		end)
	end
end
function v_u_10._CameraReplicationLoop(p68) -- name: _CameraReplicationLoop
	-- upvalues: (copy) v_u_7, (copy) v_u_5, (copy) v_u_1
	while true do
		while true do
			wait(0.1)
			if p68.LocalFighter and (p68.LocalFighter:Get("IsSpectating") and v_u_7:GetPublicState()) then
				break
			end
			if not p68._replication_stopped then
				v_u_1.Remotes.Replication.Fighter.UpdateCameraRotation:FireServer(v_u_5:EncodeCameraRotation(Vector2.zero), nil)
				p68._replication_stopped = true
			end
		end
		local v69 = v_u_5:EncodeCameraRotation(v_u_7.Rotation)
		if p68._replication_stopped or v69 ~= p68._last_encoded_camera_rotation then
			v_u_1.Remotes.Replication.Fighter.UpdateCameraRotation:FireServer(v69, nil)
		end
		p68._last_encoded_camera_rotation = v69
		p68._replication_stopped = false
	end
end
function v_u_10._HookLocalFighter(p_u_70) -- name: _HookLocalFighter
	-- upvalues: (copy) v_u_7, (copy) v_u_1, (copy) v_u_2
	p_u_70.LocalFighter = p_u_70:WaitForLocalFighter()
	local function v71() -- name: update_third_person_overide
		-- upvalues: (ref) v_u_7, (copy) p_u_70
		v_u_7:SetThirdPersonOverride(p_u_70.LocalFighter:Get("ThirdPersonOverride"))
	end
	p_u_70.LocalFighter:GetDataChangedSignal("ThirdPersonOverride"):Connect(v71)
	task.defer(v71)
	local v_u_72 = 0
	local v_u_73 = Instance.new("BindableEvent")
	v_u_73.Event:Connect(function()
		-- upvalues: (ref) v_u_1
		v_u_1.Remotes.Replication.Fighter.ResetCharacter:FireServer()
	end)
	local function v82() -- name: update_reset_button
		-- upvalues: (ref) v_u_72, (ref) v_u_2, (copy) p_u_70, (copy) v_u_73
		v_u_72 = v_u_72 + 1
		local v74 = v_u_72
		while v_u_72 == v74 do
			local v75 = pcall
			local v76 = v_u_2.SetCore
			local v77 = v_u_2
			local v78 = "ResetButtonCallback"
			local v79 = not p_u_70.LocalFighter:Get("IsInDuel")
			if v79 then
				v79 = v_u_73
			end
			local v80, v81 = v75(v76, v77, v78, v79)
			if v80 then
				break
			end
			warn("Failed to set reset button callback", v81)
			wait(0.1)
		end
	end
	p_u_70.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(v82)
	task.defer(v82)
	p_u_70:_ReplicateControls()
	task.defer(p_u_70._CameraReplicationLoop, p_u_70)
	task.defer(p_u_70._ConnectionLevelReplicationLoop, p_u_70)
	task.defer(p_u_70._VerifyEntityLoop, p_u_70)
end
function v_u_10._Setup(p83) -- name: _Setup
	-- upvalues: (copy) v_u_4, (copy) v_u_3
	function p83._reject_object_added_serial_callback(p84)
		-- upvalues: (ref) v_u_4, (ref) v_u_3
		local v85 = not p84[v_u_4:ToEnum("Player")]
		if v85 then
			v85 = not v_u_3:GetPlayerByUserId(p84[v_u_4:ToEnum("UserID")])
		end
		return v85
	end
end
function v_u_10._Init(p_u_86) -- name: _Init
	-- upvalues: (copy) v_u_6, (copy) v_u_1, (copy) v_u_5
	p_u_86.ObjectAdded:Connect(function(p87)
		-- upvalues: (copy) p_u_86
		p_u_86:_FighterAdded(p87)
	end)
	p_u_86.ObjectRemoved:Connect(function(p88)
		-- upvalues: (copy) p_u_86
		for v89, v90 in pairs(p_u_86._player_to_fighter) do
			if v90 == p88 then
				p_u_86._model_to_fighter[v89] = nil
			end
		end
		for v91, v92 in pairs(p_u_86._model_to_fighter) do
			if v92 == p88 then
				p_u_86._model_to_fighter[v91] = nil
			end
		end
	end)
	v_u_6.ControlsChanged:Connect(function()
		-- upvalues: (copy) p_u_86
		p_u_86:_ReplicateControls()
	end)
	v_u_1.Remotes.Replication.Fighter.UpdateCameraRotations.OnClientEvent:Connect(function(p93)
		-- upvalues: (ref) v_u_5, (copy) p_u_86
		local v94 = v_u_5:DecodeCameraRotationBulk(p93)
		for _, v95 in pairs(v94) do
			local v96, v97, v98 = table.unpack(v95)
			local v99 = p_u_86:GetFighterFromNetworkID(v96)
			if v99 then
				v99:SetReplicate("CameraRotation", v_u_5:FromXYToCameraRotation(v97, v98))
			end
		end
	end)
	for _, v100 in pairs(p_u_86.Objects) do
		task.spawn(p_u_86._FighterAdded, p_u_86, v100)
	end
	p_u_86:_Setup()
	task.defer(p_u_86._HookLocalFighter, p_u_86)
end
return v_u_10._new()