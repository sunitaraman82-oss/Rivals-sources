-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("GamepadService")
local v_u_4 = game:GetService("GuiService")
local v_u_5 = game:GetService("Players")
local v_u_6 = require(v1.Modules.CONSTANTS)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v1.Modules.Signal)
local v_u_9 = {
	["Desktop"] = "MouseKeyboard",
	["Mobile"] = "Touch",
	["Console"] = "Gamepad",
	["VR"] = "VR"
}
local v_u_10 = {
	[Enum.UserInputType.MouseButton1] = "MouseKeyboard",
	[Enum.UserInputType.MouseButton2] = "MouseKeyboard",
	[Enum.UserInputType.MouseButton3] = "MouseKeyboard",
	[Enum.UserInputType.Keyboard] = "MouseKeyboard",
	[Enum.UserInputType.Touch] = "Touch",
	[Enum.UserInputType.Gamepad1] = "Gamepad",
	[Enum.UserInputType.Gamepad2] = "Gamepad",
	[Enum.UserInputType.Gamepad3] = "Gamepad",
	[Enum.UserInputType.Gamepad4] = "Gamepad",
	[Enum.UserInputType.Gamepad5] = "Gamepad",
	[Enum.UserInputType.Gamepad6] = "Gamepad",
	[Enum.UserInputType.Gamepad7] = "Gamepad",
	[Enum.UserInputType.Gamepad8] = "Gamepad"
}
local v_u_11 = {
	[Enum.KeyCode.W] = "MouseKeyboard",
	[Enum.KeyCode.A] = "MouseKeyboard",
	[Enum.KeyCode.S] = "MouseKeyboard",
	[Enum.KeyCode.D] = "MouseKeyboard"
}
local v_u_12 = {
	["Mouse & Keyboard"] = "MouseKeyboard",
	["Touch Buttons"] = "Touch",
	["Controller"] = "Gamepad"
}
local v_u_13 = {}
v_u_13.__index = v_u_13
function v_u_13._new() -- name: _new
	-- upvalues: (copy) v_u_13, (copy) v_u_8, (copy) v_u_9, (copy) v_u_6
	local v14 = v_u_13
	local v15 = setmetatable({}, v14)
	v15.ControlsChanged = v_u_8.new()
	v15.CurrentControls = v_u_9[v_u_6.DEVICE]
	v15._toggled_inputs = {}
	v15._is_verification_disabled = false
	v15._set_controls_hash = 0
	v15._control_scheme_setting = nil
	v15:_Init()
	return v15
end
function v_u_13.IsInputDown(p16, p17) -- name: IsInputDown
	-- upvalues: (copy) v_u_2
	return p17.EnumType == Enum.KeyCode and v_u_2:IsKeyDown(p17) or (p17.EnumType == Enum.UserInputType and v_u_2:IsMouseButtonPressed(p17) or p17.EnumType == Enum.KeyCode and (p16.CurrentControls == "Gamepad" or p16.CurrentControls == "VR") and v_u_2:IsGamepadButtonDown(v_u_2:GetLastInputType(), p17) or p16:IsToggled(p17))
end
function v_u_13.IsToggled(p18, p19) -- name: IsToggled
	return p18._toggled_inputs[p19]
end
function v_u_13.ToggleInput(p20, p21, p22) -- name: ToggleInput
	p20._toggled_inputs[p21] = p22 or nil
end
function v_u_13.SetControls(p_u_23, p_u_24) -- name: SetControls
	-- upvalues: (copy) v_u_12
	if p_u_23._control_scheme_setting and p_u_23._control_scheme_setting ~= "Automatic" then
		p_u_24 = v_u_12[p_u_23._control_scheme_setting] or p_u_24
	end
	if p_u_24 and p_u_24 ~= p_u_23.CurrentControls then
		if p_u_24 ~= "VR" and p_u_23.CurrentControls ~= "VR" then
			p_u_23._set_controls_hash = p_u_23._set_controls_hash + 1
			local v_u_25 = p_u_23._set_controls_hash
			task.defer(function()
				-- upvalues: (copy) v_u_25, (copy) p_u_23, (ref) p_u_24
				if v_u_25 == p_u_23._set_controls_hash then
					p_u_23.CurrentControls = p_u_24
					p_u_23.ControlsChanged:Fire()
				end
			end)
		end
	else
		return
	end
end
function v_u_13.DisableVerification(p26, p27) -- name: DisableVerification
	p26._is_verification_disabled = p27
end
function v_u_13._ProcessInput(p28, p29, p30) -- name: _ProcessInput
	-- upvalues: (copy) v_u_7, (copy) v_u_3, (copy) v_u_4, (copy) v_u_10, (copy) v_u_11
	if p28._is_verification_disabled or (p30 or v_u_7:IsTextBoxFocused()) then
		return
	elseif v_u_3.GamepadCursorEnabled or v_u_4.SelectedObject then
		return
	elseif p29.KeyCode ~= Enum.KeyCode.Thumbstick1 and p29.KeyCode ~= Enum.KeyCode.Thumbstick2 or (p29.Position * Vector3.new(1, 1, 0)).Magnitude >= 0.75 then
		p28:SetControls(v_u_10[p29.UserInputType] or v_u_11[p29.KeyCode])
	end
end
function v_u_13._SetupControlSchemeSetting(p_u_31) -- name: _SetupControlSchemeSetting
	-- upvalues: (copy) v_u_5
	local v_u_32 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
	local function v33() -- name: verify
		-- upvalues: (copy) p_u_31, (copy) v_u_32
		p_u_31._control_scheme_setting = v_u_32:GetSetting("Control Scheme")
		p_u_31:SetControls(p_u_31.CurrentControls)
	end
	v_u_32:GetSettingChangedSignal("Control Scheme"):Connect(v33)
	task.defer(v33)
end
function v_u_13._Init(p_u_34) -- name: _Init
	-- upvalues: (copy) v_u_2
	v_u_2.InputBegan:Connect(function(...)
		-- upvalues: (copy) p_u_34
		p_u_34:_ProcessInput(...)
	end)
	v_u_2.InputChanged:Connect(function(...)
		-- upvalues: (copy) p_u_34
		p_u_34:_ProcessInput(...)
	end)
	v_u_2.InputEnded:Connect(function(...)
		-- upvalues: (copy) p_u_34
		p_u_34:_ProcessInput(...)
	end)
	task.defer(p_u_34._SetupControlSchemeSetting, p_u_34)
end
return v_u_13._new()