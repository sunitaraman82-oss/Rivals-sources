-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.PermissionsLibrary)
require(v1.Modules.DebugLibrary)
local v_u_6 = require(v1.Modules.Signal)
local v_u_7 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.PrivateServerController)
local v_u_8 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_9 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_10 = v_u_3.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("CustomFreecam")
local v_u_11 = {
	["FirstPerson"] = "FirstPerson",
	["ThirdPerson"] = "ThirdPerson",
	["ThirdPersonMirrored"] = "ThirdPersonMirrored",
	["ThirdPersonUnlockedMouse"] = "ThirdPersonUnlockedMouse",
	["CustomFreecam"] = "CustomFreecam"
}
local v_u_12 = {}
v_u_12.__index = v_u_12
v_u_12.States = v_u_11
v_u_12.POVStates = {
	"FirstPerson",
	"ThirdPerson",
	"ThirdPersonMirrored",
	"ThirdPersonUnlockedMouse"
}
function v_u_12.new(p13) -- name: new
	-- upvalues: (copy) v_u_12, (copy) v_u_6, (copy) v_u_10
	local v14 = v_u_12
	local v15 = setmetatable({}, v14)
	v15.StateChanged = v_u_6.new()
	v15.FreecamAccessChanged = v_u_6.new()
	v15.CameraController = p13
	v15._public_state = nil
	v15._pov_state = nil
	v15._is_active = false
	v15._custom_freecam_enabled = false
	v15._custom_freecam = v_u_10:Clone()
	v15._custom_freecam_script = v15._custom_freecam:WaitForChild("LocalScript")
	v15:_Init()
	return v15
end
function v_u_12.GetPublicState(p16) -- name: GetPublicState
	return p16._public_state
end
function v_u_12.HasFreecamAccess(_) -- name: HasFreecamAccess
	-- upvalues: (copy) v_u_4, (copy) v_u_7, (copy) v_u_5, (copy) v_u_8
	return v_u_4.IS_STUDIO or v_u_4.IS_TESTING_SERVER or (v_u_7:Get("FreecamEnabled") or v_u_5:HasPermission("permission_freecam", v_u_8:Get("PermissionsRoles")))
end
function v_u_12.SetActive(p17, p18) -- name: SetActive
	if p18 ~= p17._is_active then
		p17._is_active = p18
		p17:_UpdateState()
	end
end
function v_u_12.SetCustomFreecamEnabled(p19, p20) -- name: SetCustomFreecamEnabled
	-- upvalues: (copy) v_u_3
	if p20 ~= p19._custom_freecam_enabled then
		p19._custom_freecam_enabled = p20
		p19:_UpdateState()
		p19._custom_freecam_script.Disabled = false
		p19._custom_freecam.Parent = v_u_3.LocalPlayer:WaitForChild("PlayerGui")
		task.defer(p19._custom_freecam.LocalScript.Toggle.Fire, p19._custom_freecam.LocalScript.Toggle, p19._custom_freecam_enabled)
	end
end
function v_u_12.TogglePOV(p21) -- name: TogglePOV
	local v22 = p21.CameraController:HasThirdPersonAccess()
	local v23
	if v22 then
		v23 = p21.CameraController:HasUnlockedMouseAccess()
	else
		v23 = v22
	end
	if p21._pov_state == p21.States.FirstPerson and v22 then
		p21:_SetPOVState(p21.States.ThirdPerson)
		return
	elseif p21._pov_state == p21.States.ThirdPerson and v22 then
		p21:_SetPOVState(p21.States.ThirdPersonMirrored)
		return
	elseif p21._pov_state == p21.States.ThirdPersonMirrored and v23 then
		p21:_SetPOVState(p21.States.ThirdPersonUnlockedMouse)
		return
	elseif p21.CameraController:IsSubjectEmoting() then
		p21:_SetPOVState(p21.States.ThirdPerson)
	else
		p21:_SetPOVState(p21.States.FirstPerson)
	end
end
function v_u_12.VerifyPOV(p24) -- name: VerifyPOV
	local v25
	if p24._pov_state == p24.States.FirstPerson then
		v25 = false
	else
		v25 = not p24.CameraController:HasThirdPersonAccess()
	end
	local v26
	if p24._pov_state == p24.States.ThirdPersonUnlockedMouse then
		v26 = not p24.CameraController:HasUnlockedMouseAccess()
	else
		v26 = false
	end
	if v26 then
		if v25 then
			p24:_SetPOVState(p24.States.FirstPerson)
		else
			p24:_SetPOVState(p24.States.ThirdPerson)
		end
	else
		if v25 then
			p24:_SetPOVState(p24.States.FirstPerson)
		end
		return
	end
end
function v_u_12._SetState(p27, p28) -- name: _SetState
	-- upvalues: (copy) v_u_11
	local v29 = not p28 or v_u_11[p28]
	assert(v29, p28)
	if p28 ~= p27._public_state then
		local v30 = p27._public_state
		p27._public_state = p28
		p27.StateChanged:Fire(p27._public_state, v30)
	end
end
function v_u_12._UpdateState(p31) -- name: _UpdateState
	p31.CameraController:GetCurrentSubject()
	local v32
	if p31._custom_freecam_enabled then
		v32 = p31.States.CustomFreecam
	elseif p31._is_active then
		v32 = p31._pov_state
	else
		v32 = nil
	end
	p31:_SetState(v32)
end
function v_u_12._SetPOVState(p33, p34) -- name: _SetPOVState
	-- upvalues: (copy) v_u_11
	local v35 = not p34 or v_u_11[p34]
	assert(v35, p34)
	if p34 ~= p33._pov_state then
		p33._pov_state = p34
		p33:_UpdateState()
	end
end
function v_u_12._SetupEmoteLogic(p_u_36) -- name: _SetupEmoteLogic
	local v_u_37 = nil
	local v_u_38 = {}
	local function v_u_39() -- name: check
		-- upvalues: (copy) p_u_36, (ref) v_u_37
		task.defer(function()
			-- upvalues: (ref) p_u_36, (ref) v_u_37
			if p_u_36.CameraController:IsSubjectEmoting() then
				v_u_37 = v_u_37 or p_u_36._pov_state
				p_u_36:_SetPOVState(p_u_36.States.ThirdPersonUnlockedMouse)
			else
				if v_u_37 then
					p_u_36:_SetPOVState(v_u_37)
					v_u_37 = nil
				end
				p_u_36:VerifyPOV()
			end
		end)
	end
	local function v55() -- name: subject_changed
		-- upvalues: (ref) v_u_38, (copy) p_u_36, (copy) v_u_39, (ref) v_u_37
		for _, v40 in pairs(v_u_38) do
			v40:Disconnect()
		end
		v_u_38 = {}
		local v41 = p_u_36.CameraController:GetCurrentSubject()
		if v41 then
			local v42 = v_u_38
			local v43 = v41.EntityRemoved
			local v44 = v_u_39
			table.insert(v42, v43:Connect(v44))
			local function v49(p45) -- name: entity_added
				-- upvalues: (ref) v_u_38, (ref) v_u_39, (ref) p_u_36, (ref) v_u_37
				local v46 = v_u_38
				local v47 = p45.EmoteStatusChanged
				local v48 = v_u_39
				table.insert(v46, v47:Connect(v48))
				task.defer(function()
					-- upvalues: (ref) p_u_36, (ref) v_u_37
					if p_u_36.CameraController:IsSubjectEmoting() then
						v_u_37 = v_u_37 or p_u_36._pov_state
						p_u_36:_SetPOVState(p_u_36.States.ThirdPersonUnlockedMouse)
					else
						if v_u_37 then
							p_u_36:_SetPOVState(v_u_37)
							v_u_37 = nil
						end
						p_u_36:VerifyPOV()
					end
				end)
			end
			local v50 = v_u_38
			local v51 = v41.EntityAdded
			table.insert(v50, v51:Connect(v49))
			if v41.Entity then
				local v52 = v_u_38
				local v53 = v41.Entity.EmoteStatusChanged
				local v54 = v_u_39
				table.insert(v52, v53:Connect(v54))
				task.defer(function()
					-- upvalues: (ref) p_u_36, (ref) v_u_37
					if p_u_36.CameraController:IsSubjectEmoting() then
						v_u_37 = v_u_37 or p_u_36._pov_state
						p_u_36:_SetPOVState(p_u_36.States.ThirdPersonUnlockedMouse)
					else
						if v_u_37 then
							p_u_36:_SetPOVState(v_u_37)
							v_u_37 = nil
						end
						p_u_36:VerifyPOV()
					end
				end)
			end
		end
	end
	p_u_36.CameraController.SubjectChanged:Connect(v55)
	v55()
end
function v_u_12._SetupFreecam(p_u_56) -- name: _SetupFreecam
	-- upvalues: (copy) v_u_3, (copy) v_u_2
	task.spawn(function()
		-- upvalues: (ref) v_u_3
		v_u_3.LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(function(p57) -- name: child_added
			if p57:IsA("ScreenGui") and p57.Name == "Freecam" then
				task.defer(p57.Destroy, p57)
			end
		end)
		for _, v58 in pairs(v_u_3.LocalPlayer.PlayerGui:GetChildren()) do
			if v58:IsA("ScreenGui") and v58.Name == "Freecam" then
				task.defer(v58.Destroy, v58)
			end
		end
	end)
	v_u_2.InputBegan:Connect(function(p59, _)
		-- upvalues: (ref) v_u_2, (copy) p_u_56
		if p59.KeyCode == Enum.KeyCode.P and (v_u_2:IsKeyDown(Enum.KeyCode.LeftShift) and p_u_56:HasFreecamAccess()) then
			p_u_56:SetCustomFreecamEnabled(not p_u_56._custom_freecam_enabled)
		end
	end)
end
function v_u_12._Setup(p60) -- name: _Setup
	if p60.CameraController:HasThirdPersonAccess() then
		p60:_SetPOVState(p60.States.FirstPerson)
	end
end
function v_u_12._Init(p_u_61) -- name: _Init
	-- upvalues: (copy) v_u_9, (copy) v_u_7, (copy) v_u_8
	v_u_9.ControlsChanged:Connect(function()
		-- upvalues: (copy) p_u_61
		p_u_61:VerifyPOV()
	end)
	v_u_7:GetDataChangedSignal("FreecamEnabled"):Connect(function()
		-- upvalues: (copy) p_u_61
		p_u_61.FreecamAccessChanged:Fire()
	end)
	v_u_8:GetDataChangedSignal("PermissionsRoles"):Connect(function()
		-- upvalues: (copy) p_u_61
		p_u_61.FreecamAccessChanged:Fire()
	end)
	p_u_61:_Setup()
	p_u_61:_UpdateState()
	task.defer(p_u_61._SetupFreecam, p_u_61)
	task.defer(p_u_61._SetupEmoteLogic, p_u_61)
end
return v_u_12