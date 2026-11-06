-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("ContextActionService")
game:GetService("CollectionService")
local v_u_2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("UserInputService")
local v_u_4 = game:GetService("GamepadService")
game:GetService("StarterGui")
local v_u_5 = game:GetService("RunService")
local v_u_6 = game:GetService("GuiService")
local v_u_7 = game:GetService("Players")
local v_u_8 = require(v_u_2.Modules.CONSTANTS)
local v_u_9 = require(v_u_2.Modules.SettingsLibrary)
local v_u_10 = require(v_u_2.Modules.CosmeticLibrary)
local v_u_11 = require(v_u_2.Modules.GameplayUtility)
require(v_u_2.Modules.BetterDebris)
local v_u_12 = require(v_u_2.Modules.InputLibrary)
local v_u_13 = require(v_u_2.Modules.EnumLibrary)
require(v_u_2.Modules.ItemLibrary)
require(v_u_2.Modules.TestLibrary)
local v_u_14 = require(v_u_2.Modules.Utility)
local v_u_15 = require(v_u_2.Modules.Signal)
local v_u_16 = require(v_u_7.LocalPlayer.PlayerScripts.Controllers.UserInterfaceController)
local v_u_17 = require(v_u_7.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local v_u_18 = require(v_u_7.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_19 = require(v_u_7.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_20 = require(v_u_7.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_21 = require(v_u_7.LocalPlayer.PlayerScripts.Controllers.EmoteController)
local v_u_22 = require(v_u_7.LocalPlayer.PlayerScripts.Controllers.DebugController.DebugState)
local v_u_23 = { "Aim", "Sprint", "Crouch" }
local v_u_24 = {
	["Aim"] = false,
	["Sprint"] = false,
	["Crouch"] = false
}
local v_u_25 = {}
v_u_25.__index = v_u_25
function v_u_25._new() -- name: _new
	-- upvalues: (copy) v_u_25, (copy) v_u_15
	local v26 = v_u_25
	local v27 = setmetatable({}, v26)
	v27.StateChanged = v_u_15.new()
	v27.SlideStep = v_u_15.new()
	v27.LocalFighter = nil
	v27.IsCrouching = false
	v27.IsSprinting = false
	v27.IsSliding = false
	v27.CameraLean = 0
	v27._internal_local_fighter_added = v_u_15.new()
	v27._controls_connections = {}
	v27._crouching_start_time = 0
	v27._crouching_release_time = 0
	v27._sprinting_start_time = 0
	v27._sprinting_release_time = 0
	v27._sliding_cooldown = 0
	v27._sliding_start_time = 0
	v27._sliding_release_time = 0
	v27._sliding_velocity = nil
	v27._sliding_last_floor = nil
	v27._sliding_last_floor_physical_properties = nil
	v27._update_slide_direction = nil
	v27._is_input_spamming = {}
	v27._mobile_input_down = {}
	v27._quick_attack_down_starts = {}
	v27._is_leaning_right = false
	v27._is_leaning_left = false
	v27._original_jump_power = nil
	v27._jump_hash = 0
	v27._double_jumps_used = {}
	v27._auto_shoot_hash = 0
	v27._auto_shoot_connection = nil
	v27._scroll_delta = 0.5
	v27:_Init()
	return v27
end
function v_u_25.AreInputsDisabled(p28) -- name: AreInputsDisabled
	-- upvalues: (copy) v_u_4, (copy) v_u_6, (copy) v_u_19, (copy) v_u_7, (copy) v_u_18
	if v_u_4.GamepadCursorEnabled or v_u_6.SelectedObject then
		return true
	end
	if p28.LocalFighter and p28.LocalFighter:Get("IsHiddenByCutscene") then
		return true
	end
	if v_u_19.CurrentControls == "Gamepad" then
		local v29 = require(v_u_7.LocalPlayer.PlayerScripts.Modules.UserInterface.Equipment)
		if require(v_u_7.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages).PageSystem.CurrentPage or (v29.IsOpen or v_u_18.CurrentDuelSubject and v_u_18.CurrentDuelSubject.DuelInterface.Voting:IsOpen()) then
			return true
		end
	end
	return false
end
function v_u_25.IsAlive(p30) -- name: IsAlive
	local v31 = p30.LocalFighter
	if v31 then
		v31 = p30.LocalFighter:IsAlive()
	end
	return v31
end
function v_u_25.IsFrozen(p32) -- name: IsFrozen
	local v33 = p32.LocalFighter and p32.LocalFighter.Entity
	if v33 then
		v33 = p32.LocalFighter.Entity:Get("IsFrozen")
	end
	return v33
end
function v_u_25.IsInputDown(p34, p35) -- name: IsInputDown
	-- upvalues: (copy) v_u_20, (copy) v_u_19, (copy) v_u_12
	local v36 = v_u_20:GetPublicState() == v_u_20.CameraState.States.ThirdPersonUnlockedMouse and { Enum.UserInputType.MouseButton2 } or nil
	if v_u_19.CurrentControls == "Touch" then
		return p34:IsMobileInputDown(p35)
	else
		return v_u_12:IsInputDown(p35, v36)
	end
end
function v_u_25.IsMobileInputDown(p37, p38) -- name: IsMobileInputDown
	return p37._mobile_input_down[p38]
end
function v_u_25.GetTimeSince(p39, p40, p41) -- name: GetTimeSince
	return tick() - p39["_" .. string.lower(p40) .. "_" .. string.lower(p41) .. "_time"]
end
function v_u_25.SetCameraLean(p42, p43) -- name: SetCameraLean
	p42.CameraLean = p43
	p42.LocalFighter.LocalCameraLean = p42.CameraLean
	p42:_UpdateServerState("CameraLean", p42.CameraLean)
end
function v_u_25.SetCrouching(p44, p45) -- name: SetCrouching
	-- upvalues: (copy) v_u_19
	if not p45 then
		v_u_19:ToggleInput("Crouch", false)
	end
	if p45 ~= p44.IsCrouching then
		p44.IsCrouching = p45
		p44.LocalFighter.IsCrouchingLocally = p44.IsCrouching
		p44[p44.IsCrouching and "_crouching_start_time" or "_crouching_release_time"] = tick()
		p44:_UpdateServerState("IsCrouching", p44.IsCrouching)
		p44.StateChanged:Fire("IsCrouching")
		p44:_UpdateWalkSpeed()
		if p44.IsCrouching then
			p44:SetSprinting(false)
			local v46 = p44.LocalFighter.Entity.RootPart
			local v47 = p44.LocalFighter.Entity.RootPart.Velocity.X
			local v48 = p44.LocalFighter.Entity.RootPart.Velocity.Y
			local v49 = math.min(0, v48)
			local v50 = p44.LocalFighter.Entity.RootPart.Velocity.Z
			v46.Velocity = Vector3.new(v47, v49, v50)
		end
	end
end
function v_u_25.SetSprinting(p51, p52) -- name: SetSprinting
	if p52 ~= p51.IsSprinting then
		if not (p51.LocalFighter and (p51.LocalFighter:CanSprint() and p52)) then
			p52 = false
		end
		p51.IsSprinting = p52
		p51.LocalFighter.IsSprintingLocally = p51.IsSprinting
		p51[p51.IsSprinting and "_sprinting_start_time" or "_sprinting_release_time"] = tick()
		p51:_UpdateServerState("IsSprinting", p51.IsSprinting)
		p51.StateChanged:Fire("IsSprinting")
		p51:_UpdateWalkSpeed()
		if p51.IsSprinting then
			p51:SetCrouching(false)
		end
	end
end
function v_u_25.PlayMechanicsSound(p53, ...) -- name: PlayMechanicsSound
	-- upvalues: (copy) v_u_2
	if p53.LocalFighter then
		v_u_2.Remotes.Replication.Fighter.PlayMechanicsSound:FireServer(...)
		return p53.LocalFighter:PlayMechanicsSound(...)
	end
end
function v_u_25.StopSliding(p54, p55) -- name: StopSliding
	-- upvalues: (copy) v_u_8
	if p54.IsSliding then
		if p54._sliding_last_floor then
			p54._sliding_last_floor.CustomPhysicalProperties = p54._sliding_last_floor_physical_properties
			p54._sliding_last_floor = nil
			p54._sliding_last_floor_physical_properties = nil
		end
		if p54._sliding_velocity then
			p54._sliding_velocity:Destroy()
			p54._sliding_velocity = nil
		end
		p54._sliding_cooldown = tick() + 0.25
		p54._update_slide_direction = nil
		p54.IsSliding = false
		p54.LocalFighter.IsSlidingLocally = false
		p54._sliding_release_time = tick()
		p54:_UpdateServerState("IsSliding", false)
		p54.StateChanged:Fire("IsSliding")
		p54:_UpdateWalkSpeed()
		if p54:IsAlive() then
			p54.LocalFighter.Entity:StopSlidingAnimation()
			p54.LocalFighter.Entity.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
			if p55 then
				local v56 = p54.LocalFighter.Entity.RootPart.Velocity * 0.6
				local v57 = v_u_8.BASE_JUMPPOWER * 0.5
				local v58 = v56 + Vector3.new(0, v57, 0)
				p54.LocalFighter.Entity:AirborneTrigger(v58, 12, true)
			end
			if p54:IsInputDown("Sprint") then
				p54:SetSprinting(true)
			end
		end
	end
end
function v_u_25.Slide(p_u_59) -- name: Slide
	-- upvalues: (copy) v_u_14, (copy) v_u_5
	if not p_u_59.IsSliding and (tick() >= p_u_59._sliding_cooldown and (p_u_59:IsAlive() and (p_u_59.LocalFighter.Entity.Humanoid:GetState() ~= Enum.HumanoidStateType.Climbing and (not p_u_59.LocalFighter:AreItemsLocked() and (p_u_59.LocalFighter:CanSlide() and not p_u_59:IsFrozen()))))) then
		p_u_59._sliding_cooldown = (1 / 0)
		p_u_59.IsSliding = true
		p_u_59.LocalFighter.IsSlidingLocally = true
		p_u_59._sliding_start_time = tick()
		p_u_59:_UpdateServerState("IsSliding", true)
		p_u_59.StateChanged:Fire("IsSliding")
		p_u_59.LocalFighter.Entity.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
		p_u_59.LocalFighter.Entity.Humanoid.AutoRotate = false
		p_u_59.LocalFighter.Entity:AirborneCancel()
		p_u_59:SetCrouching(false)
		p_u_59:SetSprinting(false)
		p_u_59:_UpdateWalkSpeed()
		p_u_59._sliding_velocity = Instance.new("BodyVelocity")
		p_u_59._sliding_velocity.Parent = p_u_59.LocalFighter.Entity.RootPart
		local v60 = tick()
		local v61 = p_u_59.LocalFighter.Entity.RootPart.Position.Y
		local v62 = nil
		local v_u_63 = nil
		local v64 = p_u_59:PlayMechanicsSound("Slide")
		local v65 = tick() + 0.25
		local v66 = p_u_59.LocalFighter.Entity.RootPart.CFrame.Rotation
		local v67 = p_u_59:_GetWalkSpeed(true)
		function p_u_59._update_slide_direction(p68)
			-- upvalues: (ref) v_u_63, (copy) p_u_59
			v_u_63 = p68 or p_u_59.LocalFighter:GetMoveVector(true, true, p_u_59.LocalFighter.Entity.RootPart.CFrame.LookVector)
			task.spawn(p_u_59.LocalFighter.Entity.PlaySlidingAnimationAsync, p_u_59.LocalFighter.Entity, v_u_63)
		end
		p_u_59._update_slide_direction()
		local v69 = v_u_63
		local v70 = 0
		while p_u_59:IsAlive() and (p_u_59.IsSliding and tick() < v60 + 1) do
			local v71 = p_u_59.LocalFighter:GetFloor()
			local v72 = p_u_59.LocalFighter.Entity.RootPart.Position.Y
			if v71 then
				v62 = nil
			else
				v62 = v62 or tick()
			end
			if v72 < v61 - 1 then
				v60 = tick()
				if v64 and v65 < tick() then
					v64.TimePosition = 0
					v64.Volume = 0
				end
				v65 = tick() + 0.25
			else
				v72 = math.max(v61, v72)
			end
			if v64 and (v64.Volume == 0 and v71) then
				v64.TimePosition = 0
				v64.Volume = 0.375
			end
			local v73 = v69.Magnitude <= 0.01 and p_u_59.LocalFighter.Entity.RootPart.CFrame.LookVector or v69.Unit
			local v74 = Vector3.new(0, 1, 0)
			if v71 ~= p_u_59._sliding_last_floor then
				if p_u_59._sliding_last_floor then
					p_u_59._sliding_last_floor.CustomPhysicalProperties = p_u_59._sliding_last_floor_physical_properties
					p_u_59._sliding_last_floor = nil
					p_u_59._sliding_last_floor_physical_properties = nil
				end
				if v71 and not v71:IsA("Terrain") then
					p_u_59._sliding_last_floor = v71
					p_u_59._sliding_last_floor_physical_properties = p_u_59._sliding_last_floor.CurrentPhysicalProperties
				end
			end
			if v71 then
				local v75 = p_u_59.LocalFighter.Entity.RootPart.Position
				local v76 = v75 + v73 * 0.1
				local v77 = v_u_14:Raycast(v75, v75 + Vector3.new(0, -1, 0), 999, { v71 }, Enum.RaycastFilterType.Include)
				local v78 = v_u_14:Raycast(v76, v76 + Vector3.new(0, -1, 0), 999, { v71 }, Enum.RaycastFilterType.Include)
				if v_u_14:AngleBetweenVectors((v78.Position - v77.Position).Unit, Vector3.new(-0, -1, -0)) > 0.7853981633974483 then
					v73 = (v78.Position - v77.Position).Unit
					v74 = v78.Normal or (v77.Normal or v74)
				end
			end
			if v74.Magnitude < 0.5 then
				p_u_59.SlideStep:Fire()
			end
			if v71 then
				v70 = (tick() - v60) / 1 or v70
			end
			local v79 = p_u_59.LocalFighter:Get("SlidingSpeedMax") or 3
			local v80 = v73 * (v79 + (1 - v79) * v70) * v67
			local v81 = not v62 and Vector3.new(0, 0, 0) or v74 * -workspace.Gravity * (tick() - v62) ^ 2
			p_u_59._sliding_velocity.Velocity = v80 + v81
			p_u_59._sliding_velocity.MaxForce = Vector3.new(1, v62 and 0.1 or 1, 1) * 100000
			if v80.Magnitude > 0.01 then
				p_u_59.LocalFighter.Entity.RootPart.CFrame = p_u_59.LocalFighter.Entity.RootPart.CFrame:Lerp(CFrame.new(p_u_59.LocalFighter.Entity.RootPart.Position, p_u_59.LocalFighter.Entity.RootPart.Position + v80), 0.25)
				v66 = p_u_59.LocalFighter.Entity.RootPart.CFrame.Rotation
			else
				p_u_59.LocalFighter.Entity.RootPart.CFrame = CFrame.new(p_u_59.LocalFighter.Entity.RootPart.Position) * v66
			end
			v_u_5.RenderStepped:Wait()
			v61 = v72
		end
		v64:Destroy()
		if p_u_59.IsSliding then
			p_u_59:StopSliding()
		end
	end
end
function v_u_25.Jump(p_u_82, p83, p84, p85) -- name: Jump
	if p_u_82:IsAlive() and (not p_u_82:IsFrozen() and (p85 or not p_u_82.LocalFighter.Entity:IsAirborne())) then
		p_u_82._original_jump_power = p_u_82._original_jump_power or p_u_82.LocalFighter.Entity.Humanoid.JumpPower
		p_u_82._jump_hash = p_u_82._jump_hash + 1
		local v_u_86 = p_u_82._jump_hash
		p_u_82.LocalFighter.Entity.Humanoid.JumpPower = (p83 or p_u_82._original_jump_power) * (p84 or 1)
		p_u_82.LocalFighter.Entity.Humanoid.Jump = true
		if p83 or p84 then
			task.defer(function()
				-- upvalues: (copy) v_u_86, (copy) p_u_82
				if v_u_86 == p_u_82._jump_hash and p_u_82:IsAlive() then
					p_u_82.LocalFighter.Entity.Humanoid.JumpPower = p_u_82._original_jump_power
					p_u_82._original_jump_power = nil
				end
			end)
		end
	end
end
function v_u_25.DoubleJump(p87) -- name: DoubleJump
	if p87:IsAlive() and not p87:IsFrozen() then
		local v88 = p87.LocalFighter:GetMoveVector(true, true)
		local v89 = p87.LocalFighter.Entity.RootPart
		local v90 = v88 * p87.LocalFighter.Entity.Humanoid.WalkSpeed * 1
		local v91 = p87.LocalFighter.Entity.Humanoid.JumpPower * 1.1
		v89.Velocity = v90 + Vector3.new(0, v91, 0)
		p87.LocalFighter.Entity:AirborneRedirect()
		p87:PlayMechanicsSound("DoubleJump")
	end
end
function v_u_25.JumpRequest(p92, ...) -- name: JumpRequest
	p92:Jump(...)
end
function v_u_25.DoubleJumpRequest(p93) -- name: DoubleJumpRequest
	local v94 = p93.LocalFighter and p93.LocalFighter.EquippedItem
	if v94 then
		v94 = p93.LocalFighter.EquippedItem:Get("ObjectID")
	end
	local v95 = p93.LocalFighter and (p93.LocalFighter.EquippedItem and not p93.LocalFighter:Get("DisableDoubleJumping"))
	if v95 then
		v95 = p93.LocalFighter.EquippedItem.Info.MaxDoubleJumps
	end
	if v94 and (v95 and ((p93._double_jumps_used[v94] or 0) < (v95 or 0) and not p93.LocalFighter:IsGrounded())) then
		p93._double_jumps_used[v94] = (p93._double_jumps_used[v94] or 0) + 1
		p93:DoubleJump()
	end
end
function v_u_25.HighJump(p96) -- name: HighJump
	if p96:IsAlive() then
		p96:StopSliding(true)
		p96:_SpamJumpRequests(nil, 1.25, true)
	end
end
function v_u_25.EquippedItemInput(p97, ...) -- name: EquippedItemInput
	if p97.LocalFighter then
		p97.LocalFighter:Input(...)
	end
end
function v_u_25.SimulateInputBegan(p_u_98, p99, p100) -- name: SimulateInputBegan
	-- upvalues: (copy) v_u_12, (copy) v_u_16, (copy) v_u_23, (copy) v_u_19, (copy) v_u_20, (copy) v_u_18, (copy) v_u_17, (copy) v_u_21, (copy) v_u_8, (copy) v_u_2
	if v_u_12:InputIs(p99, "UseEmote") then
		local v101 = v_u_16:GetPage("PickEmote")
		if v101 and v101:IsOpen() then
			v101:SetAllEmotesOpen(true)
		end
	end
	if p_u_98:AreInputsDisabled() then
		return
	else
		for _, v102 in pairs(v_u_23) do
			if v_u_12:InputIs(p99, v102) and v_u_19:IsToggled(v102) then
				v_u_19:ToggleInput(v102, false)
				return p_u_98:SimulateInputEnded(p99, p100)
			end
			if v_u_12:InputIs(p99, v102) and p_u_98:_IsToggleInput(v102) then
				v_u_19:ToggleInput(v102, true)
			end
		end
		if p100 and (not v_u_16:IsPageOpen("Panels") and v_u_19.CurrentControls == "MouseKeyboard") then
			return
		elseif v_u_20:GetPublicState() == v_u_20.CameraState.States.ThirdPersonUnlockedMouse and p99.UserInputType == Enum.UserInputType.MouseButton2 then
			return
		else
			if v_u_12:InputIs(p99, "OpenPlayerList") then
				if v_u_18.CurrentDuelSubject then
					v_u_18.CurrentDuelSubject.DuelInterface.Scoreboard:Open(true)
				end
			elseif v_u_12:InputIs(p99, "Ping") then
				p_u_98.LocalFighter:Ping()
			end
			if p_u_98:IsAlive() then
				if v_u_12:InputIs(p99, "Jump") and p_u_98.LocalFighter.Entity.Humanoid:GetState() ~= Enum.HumanoidStateType.Climbing then
					if p_u_98.IsSliding then
						p_u_98:HighJump()
					else
						p_u_98:DoubleJumpRequest()
						p_u_98:_SpamJumpRequests()
					end
				elseif v_u_12:InputIs(p99, "Crouch") and not (p_u_98.IsSliding or p_u_98:IsFrozen()) then
					local v103 = p_u_98.IsSprinting or tick() - p_u_98._sprinting_release_time < 0.125
					local v104
					if v_u_19.CurrentControls == "Touch" then
						v104 = v_u_17:GetSetting("Easy Slide Mobile")
					else
						v104 = v_u_17:GetSetting("Easy Slide")
					end
					if v104 and (v103 and (p_u_98.LocalFighter:GetMoveVector(true, true).Magnitude > 0.01 and p_u_98.LocalFighter:IsGrounded())) then
						p_u_98:Slide()
					else
						p_u_98:SetCrouching(true)
					end
				elseif v_u_12:InputIs(p99, "Slide") and (not p_u_98.IsSliding and p_u_98.LocalFighter:IsGrounded()) then
					p_u_98:Slide()
					return
				elseif (v_u_12:InputIs(p99, "Sprint") or v_u_12:InputIs(p99, "AutoSprint")) and not p_u_98.IsSliding then
					p_u_98:SetSprinting(true)
				elseif v_u_12:InputIs(p99, "LeanLeft") then
					if not p_u_98._is_leaning_left then
						p_u_98._is_leaning_left = true
						p_u_98:SetCameraLean(p_u_98.CameraLean - 1)
						return
					end
				elseif v_u_12:InputIs(p99, "LeanRight") then
					if not p_u_98._is_leaning_right then
						p_u_98._is_leaning_right = true
						p_u_98:SetCameraLean(p_u_98.CameraLean + 1)
						return
					end
				else
					if v_u_21:CanEmote() then
						for v105 = 1, v_u_8.MAX_EQUIPPABLE_EMOTES do
							if v_u_12:InputIs(p99, "UseEmote" .. v105) then
								v_u_21:UseEmote((tostring(v105)))
							end
						end
					end
					if v_u_12:InputIs(p99, "EquipPrimary") then
						p_u_98.LocalFighter:EquipItem(1)
						return
					end
					if v_u_12:InputIs(p99, "EquipSecondary") then
						p_u_98.LocalFighter:EquipItem(2)
						return
					end
					if v_u_12:InputIs(p99, "EquipMelee") then
						p_u_98.LocalFighter:EquipItem(3)
						return
					end
					if v_u_12:InputIs(p99, "EquipUtility") then
						p_u_98.LocalFighter:EquipItem(4)
						return
					end
					if v_u_12:InputIs(p99, "EquipLast") then
						p_u_98.LocalFighter:EquipIncrement(-1)
						return
					end
					if v_u_12:InputIs(p99, "EquipNext") then
						p_u_98.LocalFighter:EquipIncrement(1)
						return
					end
					if v_u_12:InputIs(p99, "QuickMelee") then
						p_u_98:_QuickAttack("Melee", p99)
						return
					end
					if v_u_12:InputIs(p99, "QuickUtility") then
						p_u_98:_QuickAttack("Utility", p99)
						return
					end
					if v_u_12:InputIs(p99, "UseEmote") and v_u_21:CanEmote() then
						local v106 = v_u_16:GetPage("PickEmote")
						if not (v106 and v106:IsOpen()) then
							v_u_16:OpenPage("PickEmote", true)
							return
						end
					else
						if p_u_98.LocalFighter.EquippedItem then
							for _, v_u_107 in pairs(v_u_12.ItemInputs) do
								if v_u_12:InputIs(p99, v_u_107) then
									task.spawn(function()
										-- upvalues: (ref) v_u_12, (copy) v_u_107, (copy) p_u_98
										local v108 = v_u_12.Inputs[v_u_107].StartName
										if p_u_98.LocalFighter.EquippedItem.Info.InputSpammingEnabled[v108] then
											p_u_98:_InputSpam(v_u_107, v108)
										else
											p_u_98:EquippedItemInput(v108)
										end
									end)
								end
							end
							return
						end
						if v_u_12:InputIs(p99, "Shoot") and (p_u_98.LocalFighter.Entity and p_u_98.LocalFighter.Entity:Get("IsGrabbingSnowball")) then
							local v109 = p_u_98.LocalFighter:GetCameraData(nil, nil, true, true)
							local v110 = v109[utf8.char(2)]
							local v111 = v109[utf8.char(3)]
							if v110 then
								v110 = v110.CFrame * v111
							end
							if v110 then
								v_u_2.Remotes.Replication.Fighter.SnowballThrow:FireServer(v110.Position)
							end
						end
					end
				end
			else
				return
			end
		end
	end
end
function v_u_25.SimulateInputEnded(p112, p113) -- name: SimulateInputEnded
	-- upvalues: (copy) v_u_20, (copy) v_u_23, (copy) v_u_12, (copy) v_u_19, (copy) v_u_18, (copy) v_u_16
	if p112.LocalFighter then
		if v_u_20:GetPublicState() == v_u_20.CameraState.States.ThirdPersonUnlockedMouse and p113.UserInputType == Enum.UserInputType.MouseButton2 then
			return
		else
			for _, v114 in pairs(v_u_23) do
				if v_u_12:InputIs(p113, v114) and (p112:_IsToggleInput(v114) and v_u_19:IsToggled(v114)) then
					return
				end
			end
			if v_u_12:InputIs(p113, "Crouch") then
				if p112.IsCrouching then
					p112:SetCrouching(false)
					if p112:IsInputDown("Sprint") then
						p112:SetSprinting(true)
					end
				end
			elseif v_u_12:InputIs(p113, "Sprint") or v_u_12:InputIs(p113, "AutoSprint") then
				p112:SetSprinting(false)
			elseif v_u_12:InputIs(p113, "LeanLeft") then
				if p112._is_leaning_left then
					p112._is_leaning_left = false
					p112:SetCameraLean(p112.CameraLean + 1)
				end
			elseif v_u_12:InputIs(p113, "LeanRight") and p112._is_leaning_right then
				p112._is_leaning_right = false
				p112:SetCameraLean(p112.CameraLean - 1)
			end
			if v_u_12:InputIs(p113, "QuickMelee") then
				p112:_DontKeepQuickAttack("Melee")
				return
			elseif v_u_12:InputIs(p113, "QuickUtility") then
				p112:_DontKeepQuickAttack("Utility")
			elseif v_u_12:InputIs(p113, "OpenPlayerList") then
				if v_u_18.CurrentDuelSubject then
					v_u_18.CurrentDuelSubject.DuelInterface.Scoreboard:Open(false)
					return
				end
			elseif v_u_12:InputIs(p113, "UseEmote") and v_u_19.CurrentControls == "MouseKeyboard" then
				local v115 = v_u_16:GetPage("PickEmote")
				if v115 then
					v115:PickEarly()
					return
				end
			elseif p112.LocalFighter.EquippedItem then
				for _, v116 in pairs(v_u_12.ItemInputs) do
					if v_u_12:InputIs(p113, v116) then
						p112:EquippedItemInput(v_u_12.Inputs[v116].FinishName)
					end
				end
			end
		end
	else
		return
	end
end
function v_u_25.MobileInput(p117, p118, p119) -- name: MobileInput
	-- upvalues: (copy) v_u_12
	if not (p119 and p117:AreInputsDisabled()) then
		local v120 = v_u_12.MobileButtons[p118]
		local v121 = p117._mobile_input_down
		local v122
		if v120 then
			v122 = v120.InputName or p118
		else
			v122 = p118
		end
		v121[v122] = p119
		p117[p119 and "SimulateInputBegan" or "SimulateInputEnded"](p117, p118, false)
	end
end
function v_u_25.WaitForLocalFighter(p123) -- name: WaitForLocalFighter
	if not p123.LocalFighter then
		p123._internal_local_fighter_added:Wait()
	end
	return p123.LocalFighter
end
function v_u_25._CanAutoShoot(p124) -- name: _CanAutoShoot
	-- upvalues: (copy) v_u_19, (copy) v_u_22
	if p124.LocalFighter and (p124.LocalFighter.EquippedItem and not p124.LocalFighter:Get("IsHiddenByCutscene")) then
		return (v_u_19.CurrentControls == "Touch" or v_u_19.CurrentControls == "Gamepad") and true or (p124.LocalFighter:Get("CheaterMode") or v_u_22:Get("AreHandicapsEnabled"))
	else
		return false
	end
end
function v_u_25._ToggleAutoShoot(p_u_125) -- name: _ToggleAutoShoot
	-- upvalues: (copy) v_u_17, (copy) v_u_7, (copy) v_u_14, (copy) v_u_11, (copy) v_u_5
	p_u_125._auto_shoot_hash = p_u_125._auto_shoot_hash + 1
	local v_u_126 = p_u_125._auto_shoot_hash
	if p_u_125._auto_shoot_connection then
		p_u_125._auto_shoot_connection:Disconnect()
		p_u_125._auto_shoot_connection = nil
	end
	if p_u_125:_CanAutoShoot() then
		local v127 = p_u_125.LocalFighter:Get("CheaterMode")
		local v_u_128 = v127 and 0 or v_u_17:GetSetting("Auto Shoot Reaction Time") / 1000
		local v129
		if v127 then
			v129 = nil
		else
			v129 = v_u_17:GetSetting("Auto Shoot")
		end
		local v130
		if v127 then
			v130 = nil
		else
			v130 = p_u_125.LocalFighter:Get("AutoShootRestriction")
		end
		local v_u_131
		if v127 then
			v_u_131 = nil
		else
			v_u_131 = v130 or v129
		end
		if v129 ~= "Disabled" and v130 ~= "Disabled" then
			local v_u_132 = nil
			local v_u_133 = 0
			local v_u_134 = true
			local function v_u_140() -- name: can_autoshoot
				-- upvalues: (copy) p_u_125, (ref) v_u_133, (ref) v_u_132, (ref) v_u_7, (ref) v_u_14, (ref) v_u_11
				local v135 = p_u_125.LocalFighter and p_u_125.LocalFighter.EquippedItem
				if v135 then
					v135 = p_u_125.LocalFighter:IsAlive()
				end
				if v135 then
					local v136 = p_u_125.LocalFighter.EquippedItem:GetAutoShootReactionTime()
					local v137 = p_u_125.LocalFighter.EquippedItem:GetAutoShootReach()
					if v136 and v137 then
						if v_u_133 < tick() then
							v_u_133 = tick() + 2
							v_u_132 = p_u_125.LocalFighter:GetRaycastWhitelist(true, { p_u_125.LocalFighter }, nil, true)
						end
						if v_u_7.LocalPlayer.PlayerGui:FindFirstChild("FlashbangGui") then
							return
						else
							local v138 = v_u_14:Raycast(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + workspace.CurrentCamera.CFrame.LookVector * v137, v137, v_u_132, Enum.RaycastFilterType.Include)
							if v138.Instance then
								if v_u_14:AngleBetweenVectors(workspace.CurrentCamera.CFrame.LookVector, CFrame.new(p_u_125.LocalFighter.Entity.RootPart.Position, v138.Instance.Position).LookVector) < 1.5707963267948966 then
									local v139 = v138.Instance and (v138.Instance.AssemblyRootPart and v138.Instance.AssemblyRootPart.Parent)
									if v139 then
										v139 = v138.Instance.AssemblyRootPart.Parent:HasTag("Entity")
									end
									if v139 then
										v139 = v_u_11:GetEntityFromModel(v138.Instance.AssemblyRootPart.Parent)
									end
									if v139 and (not v139.AimAssistBlacklist and v139:IsAlive()) then
										if not v_u_11:GetSmokeCloudBetweenPoints(workspace.CurrentCamera.CFrame.Position, v138.Position) then
											return p_u_125.LocalFighter.EquippedItem, v136
										end
									end
								else
									return
								end
							else
								return
							end
						end
					else
						return
					end
				else
					return
				end
			end
			local v_u_141 = false
			local function v_u_146(p142) -- name: hold
				-- upvalues: (ref) v_u_141, (copy) p_u_125, (copy) v_u_140, (ref) v_u_134, (ref) v_u_5, (copy) v_u_126
				if not v_u_141 then
					v_u_141 = true
					local v143 = p_u_125.LocalFighter.EquippedItem
					local v144 = tick() + p142
					while true do
						local _, v145 = v_u_140()
						if not v145 or p_u_125.LocalFighter.EquippedItem ~= v143 then
							break
						end
						if v144 < tick() then
							v_u_134 = true
							p_u_125:EquippedItemInput("StartShooting")
							if p_u_125.LocalFighter.EquippedItem and (p_u_125.LocalFighter.EquippedItem.Name ~= "Flamethrower" and v_u_134) then
								v_u_134 = false
								task.delay(0.03, p_u_125.EquippedItemInput, p_u_125, "FinishShooting")
							end
						end
						v_u_5.RenderStepped:Wait()
						if v_u_126 ~= p_u_125._auto_shoot_hash then
							return
						end
					end
					v_u_141 = false
				end
			end
			p_u_125._auto_shoot_connection = v_u_5.RenderStepped:Connect(function()
				-- upvalues: (ref) v_u_141, (copy) v_u_140, (ref) v_u_134, (copy) p_u_125, (copy) v_u_131, (copy) v_u_128, (copy) v_u_146
				if v_u_141 then
					return
				else
					local _, v147 = v_u_140()
					if v147 then
						local v148
						if v_u_131 == "Dynamic" then
							v148 = math.clamp(v147, 0.025, 0.125)
						else
							v148 = v_u_128
						end
						task.defer(v_u_146, v148)
						return
					elseif v_u_134 then
						v_u_134 = false
						task.delay(0, p_u_125.EquippedItemInput, p_u_125, "FinishShooting")
					end
				end
			end)
		end
	else
		return
	end
end
function v_u_25._IsToggleInput(p149, p150) -- name: _IsToggleInput
	-- upvalues: (copy) v_u_19, (copy) v_u_24, (copy) v_u_9, (copy) v_u_17
	local v151
	if v_u_19.CurrentControls == "Touch" then
		v151 = v_u_24[p150]
	else
		v151 = nil
	end
	local v152 = "Toggle " .. p150
	local v153 = v151 == nil and v_u_9.Info[v152]
	if v153 then
		v153 = v_u_17:GetSetting(v152)
	end
	local v154 = p149.LocalFighter and p149.LocalFighter.EquippedItem
	if v154 then
		v154 = p149.LocalFighter.EquippedItem.ToggleAimEnabled
	end
	if v153 then
		v153 = p150 ~= "Aim" and true or v154
	end
	return v153
end
function v_u_25._AutoSprintEnabled(_) -- name: _AutoSprintEnabled
	-- upvalues: (copy) v_u_17, (copy) v_u_19
	return v_u_17:GetSetting("Auto Sprint") or v_u_19.CurrentControls == "Touch"
end
function v_u_25._UpdateServerState(_, p155, ...) -- name: _UpdateServerState
	-- upvalues: (copy) v_u_2, (copy) v_u_13
	v_u_2.Remotes.Replication.Fighter.UpdateState:FireServer(v_u_13:ToEnum(p155), ...)
end
function v_u_25._DontKeepQuickAttack(p156, p157) -- name: _DontKeepQuickAttack
	-- upvalues: (copy) v_u_17, (copy) v_u_2
	if p156._quick_attack_down_starts[p157] then
		if (not v_u_17:GetSetting("Keep Quick Attack Enabled") and (1 / 0) or v_u_17:GetSetting("Keep Quick Attack Window")) > tick() - p156._quick_attack_down_starts[p157] then
			v_u_2.Remotes.Replication.Fighter.DontKeepQuickAttack:FireServer()
		end
	end
end
function v_u_25._QuickAttack(p158, p159) -- name: _QuickAttack
	p158._quick_attack_down_starts[p159] = tick()
	p158.LocalFighter:QuickAttack(p159)
end
function v_u_25._InputSpam(p160, p161, p162) -- name: _InputSpam
	-- upvalues: (copy) v_u_5
	if p160._is_input_spamming[p161] then
		return
	end
	p160._is_input_spamming[p161] = true
	while p160.LocalFighter and (p160.LocalFighter.EquippedItem and (p160.LocalFighter.EquippedItem.Info.InputSpammingEnabled[p162] and p160:IsInputDown(p161))) do
		local v163 = p160:_IsToggleInput(p161)
		p160:EquippedItemInput(p162)
		local v164 = not v163 and p160.LocalFighter.EquippedItem.Info.InputSpammingEnabled[p162]
		if not v164 then
			break
		end
		if v164 <= 0 then
			v_u_5.RenderStepped:Wait()
		else
			wait(v164)
		end
	end
	p160._is_input_spamming[p161] = false
end
function v_u_25._SpamJumpRequests(p165, ...) -- name: _SpamJumpRequests
	-- upvalues: (copy) v_u_5
	while not p165.IsSliding and p165:IsInputDown("Jump") do
		p165:JumpRequest(...)
		v_u_5.RenderStepped:Wait()
	end
end
function v_u_25._GetWalkSpeed(p166, p167) -- name: _GetWalkSpeed
	-- upvalues: (copy) v_u_16, (copy) v_u_10, (copy) v_u_8
	if p166:IsFrozen() then
		return 0
	end
	local v168 = p166.LocalFighter.Entity:IsEmoting()
	local v169 = p166.LocalFighter.Entity:GetCurrentEmote()
	local v170 = v_u_16:IsPageOpen()
	local v171 = (p166.IsSprinting and not v168 and (p166.LocalFighter:Get("SprintingSpeedBoost") or 0.5) or 0) + (p166.LocalFighter and p166.LocalFighter.Entity and (p166.LocalFighter.Entity:GetBoost("Speed") or 0) or 0)
	local v172 = v170 and v170.Name == "PickEmote" and 0 or 1
	local v173 = v168 and v_u_10.Cosmetics[v169.Name].TraversalWalkSpeedMultiplier or 1
	local v174 = p166.LocalFighter and p166.LocalFighter.EquippedItem and (p166.LocalFighter.EquippedItem.Info.WalkSpeedMultiplier or 1) or 1
	local v175 = p166.IsCrouching and 0.5 or 1
	local v176 = p166.IsSliding and not p167 and 0 or 1
	local v177 = v172 * v173 * v174 * v175 * v176
	return v_u_8.BASE_WALKSPEED * (1 + v171) * v177
end
function v_u_25._UpdateWalkSpeed(p178) -- name: _UpdateWalkSpeed
	if not p178.IsSliding and p178:IsAlive() then
		p178.LocalFighter.Entity.Humanoid.WalkSpeed = p178:_GetWalkSpeed()
	end
end
function v_u_25._UpdateCharacterRotation(p179) -- name: _UpdateCharacterRotation
	-- upvalues: (copy) v_u_20
	if p179.IsSliding or not p179:IsAlive() then
		return
	else
		local v180 = v_u_20:GetPublicState()
		local v181 = p179.LocalFighter.Entity:IsEmoting()
		p179.LocalFighter.Entity.Humanoid.AutoRotate = not v180 or v180 == v_u_20.CameraState.States.ThirdPersonUnlockedMouse
		if v180 and (v180 ~= v_u_20.CameraState.States.CustomFreecam and (v180 ~= v_u_20.CameraState.States.ThirdPersonUnlockedMouse or not v181)) then
			local v182 = workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)
			if v182.Magnitude > 0.01 then
				p179.LocalFighter.Entity.RootPart.CFrame = CFrame.new(p179.LocalFighter.Entity.RootPart.Position, p179.LocalFighter.Entity.RootPart.Position + v182)
			end
		end
	end
end
function v_u_25._SetupControls(p_u_183) -- name: _SetupControls
	-- upvalues: (copy) v_u_5, (copy) v_u_19, (copy) v_u_3, (copy) v_u_20, (copy) v_u_17
	for _, v184 in pairs(p_u_183._controls_connections) do
		v184:Disconnect()
	end
	p_u_183._controls_connections = {}
	if p_u_183:IsMobileInputDown("AutoSprint") then
		task.spawn(p_u_183.MobileInput, p_u_183, "AutoSprint", false)
	end
	if p_u_183.LocalFighter then
		v_u_5.RenderStepped:Connect(function()
			-- upvalues: (copy) p_u_183
			p_u_183:_UpdateCharacterRotation()
			p_u_183:_UpdateWalkSpeed()
			if p_u_183:_AutoSprintEnabled() then
				local v185 = p_u_183.LocalFighter and not p_u_183.IsCrouching
				if v185 then
					v185 = not p_u_183.IsSliding
				end
				if v185 then
					v185 = p_u_183.LocalFighter:GetMoveVector()
				end
				if v185 then
					v185 = v185.Magnitude >= 0.9
				end
				if v185 and not p_u_183.IsSprinting then
					p_u_183:MobileInput("AutoSprint", true)
				elseif not v185 and p_u_183.IsSprinting then
					p_u_183:MobileInput("AutoSprint", false)
				end
			else
				return
			end
		end)
		if v_u_19.CurrentControls ~= "Touch" then
			local v186 = p_u_183._controls_connections
			local v187 = v_u_3.InputBegan
			table.insert(v186, v187:Connect(function(...)
				-- upvalues: (copy) p_u_183
				p_u_183:SimulateInputBegan(...)
			end))
			local v188 = p_u_183._controls_connections
			local v189 = v_u_3.InputEnded
			table.insert(v188, v189:Connect(function(...)
				-- upvalues: (copy) p_u_183
				p_u_183:SimulateInputEnded(...)
			end))
			if v_u_19.CurrentControls == "MouseKeyboard" then
				local v190 = p_u_183._controls_connections
				local v191 = v_u_3.InputChanged
				local function v199(p192, p193)
					-- upvalues: (ref) v_u_20, (copy) p_u_183, (ref) v_u_17
					if not p193 and (v_u_20:GetPublicState() ~= v_u_20.CameraState.States.ThirdPersonUnlockedMouse and (p_u_183:IsAlive() and v_u_17:GetSetting("Scroll Equip"))) then
						if p192.UserInputType == Enum.UserInputType.MouseWheel then
							local v194 = p_u_183._scroll_delta + p192.Position.Z
							local v195 = math.floor(v194)
							local v196 = p_u_183._scroll_delta
							local v197 = v195 - math.floor(v196)
							local v198 = p_u_183
							v198._scroll_delta = v198._scroll_delta + p192.Position.Z
							if math.abs(v197) > 0 then
								p_u_183.LocalFighter:EquipIncrement(-math.sign(v197))
							end
						end
					end
				end
				table.insert(v190, v191:Connect(v199))
			end
		end
	else
		return
	end
end
function v_u_25._BindMovementActionsLoop(_) -- name: _BindMovementActionsLoop
	-- upvalues: (copy) v_u_7, (copy) v_u_1, (copy) v_u_12, (copy) v_u_17
	local v_u_200 = require(v_u_7.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	local v_u_201 = require(v_u_7.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"):WaitForChild("Keyboard"))
	local v_u_218 = {
		["WalkForward"] = { "moveForwardAction", function(_, p202, _)
				-- upvalues: (copy) v_u_200, (copy) v_u_201
				for v203, v205 in pairs(v_u_200.controllers) do
					if v203 == v_u_201 then
						goto l4
					end
				end
				local v205 = nil
				::l4::
				if v205 then
					v205.forwardValue = p202 == Enum.UserInputState.Begin and -1 or 0
					v205:UpdateMovement(p202)
					return Enum.ContextActionResult.Pass
				end
			end },
		["WalkBackward"] = { "moveBackwardAction", function(_, p206, _)
				-- upvalues: (copy) v_u_200, (copy) v_u_201
				for v207, v209 in pairs(v_u_200.controllers) do
					if v207 == v_u_201 then
						goto l4
					end
				end
				local v209 = nil
				::l4::
				if v209 then
					v209.backwardValue = p206 == Enum.UserInputState.Begin and 1 or 0
					v209:UpdateMovement(p206)
					return Enum.ContextActionResult.Pass
				end
			end },
		["WalkLeftward"] = { "moveLeftAction", function(_, p210, _)
				-- upvalues: (copy) v_u_200, (copy) v_u_201
				for v211, v213 in pairs(v_u_200.controllers) do
					if v211 == v_u_201 then
						goto l4
					end
				end
				local v213 = nil
				::l4::
				if v213 then
					v213.leftValue = p210 == Enum.UserInputState.Begin and -1 or 0
					v213:UpdateMovement(p210)
					return Enum.ContextActionResult.Pass
				end
			end },
		["WalkRightward"] = { "moveRightAction", function(_, p214, _)
				-- upvalues: (copy) v_u_200, (copy) v_u_201
				for v215, v217 in pairs(v_u_200.controllers) do
					if v215 == v_u_201 then
						goto l4
					end
				end
				local v217 = nil
				::l4::
				if v217 then
					v217.rightValue = p214 == Enum.UserInputState.Begin and 1 or 0
					v217:UpdateMovement(p214)
					return Enum.ContextActionResult.Pass
				end
			end }
	}
	local function v_u_224(p219) -- name: update
		-- upvalues: (copy) v_u_218, (ref) v_u_1, (ref) v_u_12
		local v220 = v_u_218[p219]
		local v221, v222 = table.unpack(v220)
		if v_u_1:GetBoundActionInfo(v221) then
			v_u_1:UnbindAction(v221)
		end
		local v223 = v_u_12:GetInputs(p219)
		if v223 and #v223 > 0 then
			v_u_1:BindActionAtPriority(v221, v222, false, 2000, table.unpack(v223))
		end
	end
	for v_u_225 in pairs(v_u_218) do
		for _, v226 in pairs(v_u_12.HOTKEY_FORMATS) do
			for _, v227 in pairs(v226) do
				v_u_17:GetSettingChangedSignal(string.format(v227, v_u_225)):Connect(function()
					-- upvalues: (copy) v_u_224, (copy) v_u_225
					v_u_224(v_u_225)
				end)
			end
		end
	end
	while true do
		for v228, v229 in pairs(v_u_218) do
			local v230, _ = table.unpack(v229)
			local v231 = v_u_1:GetBoundActionInfo(v230)
			local v232 = not (v231 and (v231.inputTypes and v231.inputTypes[1]))
			if not v232 then
				local v233 = v231.inputTypes[1]
				if typeof(v233) == "EnumItem" then
					v232 = v231.inputTypes[1].EnumType == Enum.PlayerActions
				else
					v232 = false
				end
			end
			if v232 then
				v_u_224(v228)
			end
		end
		wait(1)
	end
end
function v_u_25._DisableRobloxJumpButton(_) -- name: _DisableRobloxJumpButton
	-- upvalues: (copy) v_u_1
	while true do
		if next(v_u_1:GetBoundActionInfo("jumpAction") or {}) then
			v_u_1:UnbindAction("jumpAction")
		end
		wait(1)
	end
end
function v_u_25._HookFighter(p_u_234) -- name: _HookFighter
	-- upvalues: (copy) v_u_7, (copy) v_u_17, (copy) v_u_8
	p_u_234.LocalFighter = require(v_u_7.LocalPlayer.PlayerScripts.Controllers.FighterController):WaitForLocalFighter()
	p_u_234.LocalFighter.StopSliding:Connect(function()
		-- upvalues: (copy) p_u_234
		p_u_234:StopSliding()
	end)
	p_u_234.LocalFighter:GetDataChangedSignal("AutoShootRestriction"):Connect(function()
		-- upvalues: (copy) p_u_234
		p_u_234:_ToggleAutoShoot()
	end)
	p_u_234.LocalFighter:GetDataChangedSignal("CheaterMode"):Connect(function()
		-- upvalues: (copy) p_u_234
		p_u_234:_ToggleAutoShoot()
	end)
	p_u_234.LocalFighter:GetDataChangedSignal("IsHiddenByCutscene"):Connect(function()
		-- upvalues: (copy) p_u_234
		p_u_234:_ToggleAutoShoot()
	end)
	local v_u_235 = {}
	p_u_234.LocalFighter.EquippedItemChanged:Connect(function(p236)
		-- upvalues: (ref) v_u_235, (copy) p_u_234
		for _, v237 in pairs(v_u_235) do
			v237:Disconnect()
		end
		v_u_235 = {}
		p_u_234:_UpdateWalkSpeed()
		p_u_234:_ToggleAutoShoot()
		if p236 then
			local v238 = v_u_235
			local v239 = p236.StopSprinting
			local function v240()
				-- upvalues: (ref) p_u_234
				p_u_234:SetSprinting(false)
			end
			table.insert(v238, v239:Connect(v240))
			local v241 = v_u_235
			local v242 = p236.AttemptToSprintAgain
			local function v243()
				-- upvalues: (ref) p_u_234
				if p_u_234:IsInputDown("Sprint") or p_u_234:IsInputDown("AutoSprint") then
					p_u_234:SetSprinting(true)
				end
			end
			table.insert(v241, v242:Connect(v243))
		end
	end)
	local function v244() -- name: update_auto_jump
		-- upvalues: (copy) p_u_234, (ref) v_u_17
		if p_u_234.LocalFighter.Entity and p_u_234.LocalFighter.Entity.Humanoid then
			p_u_234.LocalFighter.Entity.Humanoid.AutoJumpEnabled = v_u_17:GetSetting("Auto Jump")
		end
	end
	v_u_17:GetSettingChangedSignal("Auto Jump"):Connect(v244)
	local function v267(p_u_245) -- name: entity_added
		-- upvalues: (copy) p_u_234, (ref) v_u_8, (ref) v_u_17
		p_u_234._original_humanoid_animations = {}
		p_u_234._double_jumps_used = {}
		p_u_234:SetCrouching(false)
		p_u_234:SetSprinting(false)
		p_u_234:StopSliding()
		p_u_234:_UpdateWalkSpeed()
		p_u_245.Humanoid.CameraOffset = Vector3.new(0, 1, 0)
		local v_u_246 = Instance.new("BodyForce")
		v_u_246.Name = "CustomGravity"
		v_u_246.Parent = p_u_245.RootPart
		local function v_u_251() -- name: update_gravity
			-- upvalues: (ref) p_u_234, (copy) p_u_245, (ref) v_u_8, (copy) v_u_246
			local v247 = not p_u_234.IsCrouching and p_u_245:Get("Gravity") or 1
			local v248 = v_u_8.BASE_GRAVITY * v247
			local v249 = v_u_246
			local v250 = p_u_245.RootPart.AssemblyMass * workspace.Gravity * (1 - v248)
			v249.Force = Vector3.new(0, v250, 0)
			p_u_245.Humanoid.JumpPower = v_u_8.BASE_JUMPPOWER
		end
		p_u_245:GetDataChangedSignal("Gravity"):Connect(v_u_251)
		p_u_245.EmoteStatusChanged:Connect(v_u_251)
		p_u_234.StateChanged:Connect(v_u_251)
		local v252 = p_u_234.IsCrouching and 1 or (p_u_245:Get("Gravity") or 1)
		local v253 = v_u_8.BASE_GRAVITY * v252
		local v254 = p_u_245.RootPart.AssemblyMass * workspace.Gravity * (1 - v253)
		v_u_246.Force = Vector3.new(0, v254, 0)
		p_u_245.Humanoid.JumpPower = v_u_8.BASE_JUMPPOWER
		p_u_245.Model.DescendantAdded:Connect(function(p255) -- name: descendant_added
			-- upvalues: (copy) v_u_251
			if p255:IsA("BasePart") then
				p255:GetPropertyChangedSignal("AssemblyMass"):Connect(v_u_251)
				p255:GetPropertyChangedSignal("Mass"):Connect(v_u_251)
			end
		end)
		for _, v256 in pairs(p_u_245.Model:GetDescendants()) do
			if v256:IsA("BasePart") then
				v256:GetPropertyChangedSignal("AssemblyMass"):Connect(v_u_251)
				v256:GetPropertyChangedSignal("Mass"):Connect(v_u_251)
			end
		end
		p_u_245.Humanoid.Jumping:Connect(function()
			-- upvalues: (ref) p_u_234, (copy) p_u_245, (ref) v_u_8, (copy) v_u_246
			local v257 = not p_u_234.IsCrouching and p_u_245:Get("Gravity") or 1
			local v258 = v_u_8.BASE_GRAVITY * v257
			local v259 = v_u_246
			local v260 = p_u_245.RootPart.AssemblyMass * workspace.Gravity * (1 - v258)
			v259.Force = Vector3.new(0, v260, 0)
			p_u_245.Humanoid.JumpPower = v_u_8.BASE_JUMPPOWER
			p_u_234:StopSliding(true)
		end)
		p_u_245.Humanoid.StateChanged:Connect(function(_, p261)
			-- upvalues: (ref) p_u_234, (copy) p_u_245, (ref) v_u_8, (copy) v_u_246
			local v262 = p_u_234.IsCrouching and 1 or (p_u_245:Get("Gravity") or 1)
			local v263 = v_u_8.BASE_GRAVITY * v262
			local v264 = v_u_246
			local v265 = p_u_245.RootPart.AssemblyMass * workspace.Gravity * (1 - v263)
			v264.Force = Vector3.new(0, v265, 0)
			p_u_245.Humanoid.JumpPower = v_u_8.BASE_JUMPPOWER
			if p261 == Enum.HumanoidStateType.Climbing then
				p_u_234:StopSliding()
			elseif p261 == Enum.HumanoidStateType.Landed then
				p_u_234._double_jumps_used = {}
			end
		end)
		p_u_245.Humanoid.Died:Connect(function()
			-- upvalues: (ref) p_u_234
			p_u_234:SetSprinting(false)
			p_u_234:SetCrouching(false)
			p_u_234:StopSliding()
		end)
		p_u_245.AirborneChanged:Connect(function()
			-- upvalues: (ref) p_u_234, (copy) p_u_245
			p_u_234:_UpdateServerState("IsAirborne", p_u_245:IsAirborne())
		end)
		p_u_245.RedirectSliding:Connect(function(p266)
			-- upvalues: (ref) p_u_234
			if p_u_234._update_slide_direction then
				p_u_234._update_slide_direction(p266)
			end
		end)
		if p_u_234.LocalFighter.Entity and p_u_234.LocalFighter.Entity.Humanoid then
			p_u_234.LocalFighter.Entity.Humanoid.AutoJumpEnabled = v_u_17:GetSetting("Auto Jump")
		end
	end
	p_u_234.LocalFighter.EntityAdded:Connect(v267)
	if p_u_234.LocalFighter.Entity then
		task.spawn(v267, p_u_234.LocalFighter.Entity)
	end
	p_u_234._internal_local_fighter_added:Fire()
	p_u_234:_SetupControls()
	p_u_234:_ToggleAutoShoot()
	task.defer(p_u_234._DisableRobloxJumpButton, p_u_234)
	task.defer(p_u_234._BindMovementActionsLoop, p_u_234)
end
function v_u_25._Init(p_u_268) -- name: _Init
	-- upvalues: (copy) v_u_19, (copy) v_u_17, (copy) v_u_22
	v_u_19.ControlsChanged:Connect(function()
		-- upvalues: (copy) p_u_268
		p_u_268:_SetupControls()
		p_u_268:_ToggleAutoShoot()
	end)
	v_u_17:GetSettingChangedSignal("Auto Shoot"):Connect(function()
		-- upvalues: (copy) p_u_268
		p_u_268:_ToggleAutoShoot()
	end)
	v_u_17:GetSettingChangedSignal("Auto Shoot Reaction Time"):Connect(function()
		-- upvalues: (copy) p_u_268
		p_u_268:_ToggleAutoShoot()
	end)
	v_u_22:GetDataChangedSignal("AreHandicapsEnabled"):Connect(function()
		-- upvalues: (copy) p_u_268
		p_u_268:_ToggleAutoShoot()
	end)
	task.defer(p_u_268._HookFighter, p_u_268)
end
return v_u_25._new()