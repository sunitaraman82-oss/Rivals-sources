-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("GuiService")
local v_u_2 = game:GetService("StarterGui")
local v3 = game:GetService("Players")
local v_u_4 = require(v3.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_5 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("MobileInputs"))
local v_u_6 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Teleporting"))
local v_u_7 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("PlayerList"))
local v_u_8 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Equipment"))
local v_u_9 = require(v3.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages"))
local v_u_10 = {}
v_u_10.__index = v_u_10
function v_u_10._new() -- name: _new
	-- upvalues: (copy) v_u_10
	local v11 = v_u_10
	local v12 = setmetatable({}, v11)
	v12.LocalFighter = nil
	v12:_Init()
	return v12
end
function v_u_10._UpdatePlayerList(_) -- name: _UpdatePlayerList
	-- upvalues: (copy) v_u_1, (copy) v_u_7, (copy) v_u_2
	v_u_7:SetScale(v_u_1.ViewportDisplaySize == Enum.DisplaySize.Small and 0.75 or 1)
	v_u_7:SetDisabled(false)
	v_u_2:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
end
function v_u_10._UpdateTouchControls(_) -- name: _UpdateTouchControls
	-- upvalues: (copy) v_u_1, (copy) v_u_8, (copy) v_u_9
	local v13 = v_u_1
	local v14 = not v_u_8.IsOpen
	if v14 then
		v14 = not v_u_9.PageSystem.CurrentPage
	end
	v13.TouchControlsEnabled = v14
end
function v_u_10._UpdateChat(_) -- name: _UpdateChat
	-- upvalues: (copy) v_u_6, (copy) v_u_5, (copy) v_u_2
	local v15 = not v_u_6.Enabled
	if v15 then
		v15 = not v_u_5.EditorEnabled
	end
	v_u_2:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, v15 or false)
end
function v_u_10._UpdateLoop(p16) -- name: _UpdateLoop
	-- upvalues: (copy) v_u_2
	while true do
		pcall(v_u_2.SetCoreGuiEnabled, v_u_2, Enum.CoreGuiType.EmotesMenu, false)
		pcall(v_u_2.SetCoreGuiEnabled, v_u_2, Enum.CoreGuiType.Health, false)
		task.defer(p16._UpdatePlayerList, p16)
		task.defer(p16._UpdateChat, p16)
		wait(1)
	end
end
function v_u_10._Init(p_u_17) -- name: _Init
	-- upvalues: (copy) v_u_6, (copy) v_u_5, (copy) v_u_7, (copy) v_u_1, (copy) v_u_4, (copy) v_u_8, (copy) v_u_9
	v_u_6.EnabledChanged:Connect(function()
		-- upvalues: (copy) p_u_17
		p_u_17:_UpdateChat()
	end)
	v_u_5.EditorEnabledChanged:Connect(function()
		-- upvalues: (copy) p_u_17
		p_u_17:_UpdateChat()
	end)
	v_u_7.BaseVisibilityChanged:Connect(function()
		-- upvalues: (copy) p_u_17
		p_u_17:_UpdatePlayerList()
	end)
	v_u_1:GetPropertyChangedSignal("ViewportDisplaySize"):Connect(function()
		-- upvalues: (copy) p_u_17
		p_u_17:_UpdatePlayerList()
	end)
	v_u_4.ControlsChanged:Connect(function()
		-- upvalues: (copy) p_u_17
		p_u_17:_UpdatePlayerList()
	end)
	v_u_8.Opened:Connect(function()
		-- upvalues: (copy) p_u_17
		p_u_17:_UpdateTouchControls()
	end)
	v_u_9.PageSystem.PagesActivity:Connect(function()
		-- upvalues: (copy) p_u_17
		p_u_17:_UpdateTouchControls()
	end)
	task.defer(p_u_17._UpdateLoop, p_u_17)
	task.defer(p_u_17._UpdateChat, p_u_17)
	task.defer(p_u_17._UpdatePlayerList, p_u_17)
	task.defer(p_u_17._UpdateTouchControls, p_u_17)
end
return v_u_10._new()