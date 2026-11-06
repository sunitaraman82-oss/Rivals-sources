-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("ProximityPromptService")
local v2 = game:GetService("ReplicatedStorage")
local v_u_3 = game:GetService("GuiService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v2.Modules.BetterDebris)
local v_u_6 = require(v2.Modules.ItemLibrary)
local v_u_7 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("PlayerDataController"))
local v_u_8 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("ControlsController"))
local v_u_9 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))
local v_u_10 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("MobileInputs"))
local v_u_11 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Teleporting"))
local v_u_12 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Equipment"))
local v_u_13 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Shutdown"))
local v_u_14 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Queue"))
local v_u_15 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface:WaitForChild("Pages"))
local v_u_16 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("WeaponStatusHandler"))
local v_u_17 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("ButtonEffect"))
local v_u_18 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("ProximityPrompts")
local v_u_19 = {}
v_u_19.__index = v_u_19
function v_u_19._new() -- name: _new
	-- upvalues: (copy) v_u_19
	local v20 = v_u_19
	local v21 = setmetatable({}, v20)
	v21._custom_prompt = nil
	v21._custom_prompt_hash = 0
	v21._custom_prompt_connections = {}
	v21:_Init()
	return v21
end
function v_u_19._UpdateEnabled(_) -- name: _UpdateEnabled
	-- upvalues: (copy) v_u_1, (copy) v_u_9, (copy) v_u_10, (copy) v_u_15, (copy) v_u_11, (copy) v_u_13, (copy) v_u_14, (copy) v_u_3, (copy) v_u_12, (copy) v_u_7
	local v22 = v_u_1
	local v23 = not (v_u_9.CurrentDuelSubject or v_u_10.EditorEnabled or (v_u_15.PageSystem.CurrentPage or v_u_11.Enabled) or (v_u_13.Enabled or v_u_14:IsVisible() or (v_u_3.MenuIsOpen or v_u_12.IsOpen)))
	if v23 then
		v23 = not v_u_7:GetSetting("Hide HUD")
	end
	v22.Enabled = v23
end
function v_u_19._Cleanup(p24) -- name: _Cleanup
	-- upvalues: (copy) v_u_5, (copy) v_u_4
	p24._custom_prompt_hash = p24._custom_prompt_hash + 1
	for _, v25 in pairs(p24._custom_prompt_connections) do
		v25:Disconnect()
	end
	p24._custom_prompt_connections = {}
	if p24._custom_prompt then
		v_u_5:AddItem(p24._custom_prompt, 0.15)
		if p24._custom_prompt:FindFirstChild("Button") and p24._custom_prompt:IsDescendantOf(v_u_4) then
			p24._custom_prompt.Button:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quint", 0.25, true)
		end
		p24._custom_prompt = nil
	end
end
function v_u_19._Create(p_u_26, p_u_27) -- name: _Create
	-- upvalues: (copy) v_u_8, (copy) v_u_18, (copy) v_u_4, (copy) v_u_16, (copy) v_u_6, (copy) v_u_17
	p_u_26:_Cleanup()
	p_u_27:SetAttribute("ClickablePrompt", p_u_27.ClickablePrompt)
	p_u_27.ClickablePrompt = v_u_8.CurrentControls == "Touch" and true or p_u_27:GetAttribute("ClickablePrompt")
	p_u_26._custom_prompt_hash = p_u_26._custom_prompt_hash + 1
	local v_u_28 = p_u_26._custom_prompt_hash
	local v29 = v_u_18[p_u_27:GetAttribute("Style") or "Default"]
	p_u_26._custom_prompt = v29:Clone()
	p_u_26._custom_prompt.Name = "ProximityPrompt - " .. v29.Name
	p_u_26._custom_prompt.Button.Inputs.MouseKeyboard.KeyText.Text = p_u_27.KeyboardKeyCode.Name
	p_u_26._custom_prompt.Button.Inputs.Gamepad.Container:SetAttribute("EnumType", "KeyCode")
	p_u_26._custom_prompt.Button.Inputs.Gamepad.Container:SetAttribute("EnumName", p_u_27.GamepadKeyCode.Name)
	p_u_26._custom_prompt.Button.Inputs.Gamepad.Container:AddTag("UIKeybindContainer")
	p_u_26._custom_prompt.Button.Interactable = p_u_27.ClickablePrompt
	p_u_26._custom_prompt.Adornee = p_u_27.Parent
	p_u_26._custom_prompt.Parent = v_u_4.LocalPlayer.PlayerGui
	local function v33() -- name: update
		-- upvalues: (copy) p_u_26, (copy) p_u_27, (ref) v_u_16, (ref) v_u_6
		p_u_26._custom_prompt.Button.ObjectText.Text = p_u_27.ObjectText
		p_u_26._custom_prompt.Button.ActionText.Text = p_u_27.ActionText
		v_u_16:ClearStatusElements(p_u_26._custom_prompt.Button.ObjectText)
		local v30 = v_u_16
		local v31 = p_u_26._custom_prompt.Button.ObjectText
		local v32 = v_u_6.Items[p_u_27.ObjectText]
		if v32 then
			v32 = v_u_6.Items[p_u_27.ObjectText].Status
		end
		v30:ApplyItemStatusToText(v31, v32)
	end
	local v34 = p_u_26._custom_prompt_connections
	local v35 = p_u_27:GetPropertyChangedSignal("ObjectText")
	table.insert(v34, v35:Connect(v33))
	local v36 = p_u_26._custom_prompt_connections
	local v37 = p_u_27:GetPropertyChangedSignal("ActionText")
	table.insert(v36, v37:Connect(v33))
	v33()
	p_u_26._custom_prompt.Button.Size = UDim2.new(p_u_26._custom_prompt.Button.Size.X.Scale * 0.5, p_u_26._custom_prompt.Button.Size.X.Offset * 0.5, p_u_26._custom_prompt.Button.Size.Y.Scale * 0.5, p_u_26._custom_prompt.Button.Size.Y.Offset * 0.5)
	p_u_26._custom_prompt.Button:TweenSize(v29.Button.Size, "Out", "Quint", 0.25, true, function()
		-- upvalues: (copy) p_u_26, (copy) v_u_28, (copy) p_u_27, (ref) v_u_17
		if p_u_26._custom_prompt_hash == v_u_28 and p_u_27.ClickablePrompt then
			p_u_26._custom_prompt.Button.MouseButton1Down:Connect(function()
				-- upvalues: (ref) p_u_27
				p_u_27:InputHoldBegin()
			end)
			p_u_26._custom_prompt.Button.MouseButton1Up:Connect(function()
				-- upvalues: (ref) p_u_27
				p_u_27:InputHoldEnd()
			end)
			p_u_26._custom_prompt.Button.MouseLeave:Connect(function()
				-- upvalues: (ref) p_u_27
				p_u_27:InputHoldEnd()
			end)
			v_u_17:Add(p_u_26._custom_prompt.Button, nil, {
				["DontReposition"] = true
			})
		end
	end)
	p_u_26:_UpdateEnabled()
end
function v_u_19._Init(p_u_38) -- name: _Init
	-- upvalues: (copy) v_u_1, (copy) v_u_15, (copy) v_u_11, (copy) v_u_13, (copy) v_u_14, (copy) v_u_9, (copy) v_u_10, (copy) v_u_3, (copy) v_u_12, (copy) v_u_7
	v_u_1.PromptShown:Connect(function(p39)
		-- upvalues: (copy) p_u_38
		if p39.Style == Enum.ProximityPromptStyle.Custom then
			p_u_38:_Create(p39)
		end
	end)
	v_u_1.PromptHidden:Connect(function(p40)
		-- upvalues: (copy) p_u_38
		if p40.Style == Enum.ProximityPromptStyle.Custom then
			p_u_38:_Cleanup()
		end
	end)
	v_u_15.PageSystem.PageOpened:Connect(function()
		-- upvalues: (copy) p_u_38
		p_u_38:_UpdateEnabled()
	end)
	v_u_15.PageSystem.PageClosed:Connect(function()
		-- upvalues: (copy) p_u_38
		p_u_38:_UpdateEnabled()
	end)
	v_u_11.EnabledChanged:Connect(function()
		-- upvalues: (copy) p_u_38
		p_u_38:_UpdateEnabled()
	end)
	v_u_13.EnabledChanged:Connect(function()
		-- upvalues: (copy) p_u_38
		p_u_38:_UpdateEnabled()
	end)
	v_u_14.VisibilityChanged:Connect(function()
		-- upvalues: (copy) p_u_38
		p_u_38:_UpdateEnabled()
	end)
	v_u_9.DuelSubjectChanged:Connect(function()
		-- upvalues: (copy) p_u_38
		p_u_38:_UpdateEnabled()
	end)
	v_u_10.EditorEnabledChanged:Connect(function()
		-- upvalues: (copy) p_u_38
		p_u_38:_UpdateEnabled()
	end)
	v_u_3:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
		-- upvalues: (copy) p_u_38
		p_u_38:_UpdateEnabled()
	end)
	v_u_12.Opened:Connect(function()
		-- upvalues: (copy) p_u_38
		p_u_38:_UpdateEnabled()
	end)
	v_u_7:GetSettingChangedSignal("Hide HUD"):Connect(function()
		-- upvalues: (copy) p_u_38
		p_u_38:_UpdateEnabled()
	end)
	p_u_38:_UpdateEnabled()
end
return v_u_19._new()