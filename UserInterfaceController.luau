-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("GamepadService")
local v_u_4 = game:GetService("GuiService")
local v_u_5 = game:GetService("Players")
local v_u_6 = require(v1.Modules.InputLibrary)
local v_u_7 = require(v1.Modules.Utility)
local v_u_8 = require(v1.Modules.Signal)
local v_u_9 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local v_u_10 = v_u_5.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface")
local v_u_11 = v_u_5.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("MainGui")
local v_u_12 = {
	"Shutdown",
	"PurchasePrompt",
	"MobileInputs",
	"Inset",
	"SwitchCameraPOV",
	"Pages",
	"Panels",
	"Equipment",
	"Queue",
	"EliminatedEffect",
	"Spectate",
	"HUD",
	"Lobby",
	"Notifications",
	"SideTasks",
	"Teleporting",
	"PlayerList",
	"MatchmakingCountdown",
	"Spotlight",
	"JoystickModal",
	"SideParty",
	"BossHealth",
	"MainGlowyBackground"
}
local v_u_13 = {}
v_u_13.__index = v_u_13
function v_u_13._new() -- name: _new
	-- upvalues: (copy) v_u_13, (copy) v_u_8, (copy) v_u_11
	local v14 = v_u_13
	local v15 = setmetatable({}, v14)
	v15.ElementsLoaded = v_u_8.new()
	v15.PageSystemPagesActivity = v_u_8.new()
	v15.EquipmentOpened = v_u_8.new()
	v15.MainGui = v_u_11
	v15._are_elements_loaded = false
	v15._elements = {}
	v15._selected_object_connections = {}
	v15._gamepad_connections = {}
	v15:_Init()
	return v15
end
function v_u_13.GetDefaultElement(p16) -- name: GetDefaultElement
	return p16._elements.Pages and p16._elements.Pages:GetDefaultElement() or nil
end
function v_u_13.IsPageOpen(p17, p18) -- name: IsPageOpen
	local v19 = p17._elements[p18 or "Pages"]
	local v20 = v19 and v19.PageSystem
	if v20 then
		v20 = v19.PageSystem.CurrentPage
	end
	return v20
end
function v_u_13.IsEquipmentOpen(p21) -- name: IsEquipmentOpen
	local v22 = p21._elements.Equipment
	if v22 then
		v22 = p21._elements.Equipment.IsOpen
	end
	return v22
end
function v_u_13.GetPage(p23, ...) -- name: GetPage
	local v24 = p23._elements.Pages
	if v24 then
		v24 = p23._elements.Pages.PageSystem:GetPage(...)
	end
	return v24
end
function v_u_13.OpenPage(p25, ...) -- name: OpenPage
	local v26 = p25._elements.Pages
	if v26 then
		v26 = p25._elements.Pages.PageSystem:OpenPage(...)
	end
	return v26
end
function v_u_13.WaitUntilLoaded(p27) -- name: WaitUntilLoaded
	if not p27._are_elements_loaded then
		p27.ElementsLoaded:Wait()
	end
end
function v_u_13.CloseRequest(p28) -- name: CloseRequest
	local v29 = p28:IsPageOpen()
	if v29 then
		if not v29.CantBeClosedFromInputs then
			p28._elements.Pages:CloseRequest()
		end
		return
	elseif p28:IsEquipmentOpen() then
		p28._elements.Equipment:CloseRequest()
		return
	else
		local v30 = p28:_GetSpectatedDuelInterface()
		if v30 and (v30.FinalResults.Buttons.LeaveFrame.Visible or v30.FinalResults.Buttons.ContinueFrame.Visible) then
			if v30.FinalResults.Buttons.ContinueFrame.Visible then
				v30.FinalResults.Buttons:Continue()
			else
				v30.FinalResults.Buttons:LeaveRequest()
			end
		else
			return
		end
	end
end
function v_u_13.PrimaryAction(p31) -- name: PrimaryAction
	-- upvalues: (copy) v_u_7
	if p31._elements.Lobby and (p31._elements.Lobby.Play and (p31._elements.Lobby.Play.IsPlayVisible and v_u_7:IsUIElementVisible(p31._elements.Lobby.Play.PlayButton))) then
		p31._elements.Lobby.Play:OpenPlayPage()
		return
	else
		local v32 = p31:_GetSpectatedDuelInterface()
		if v32 and v32.FinalResults.Buttons.PlayAgainFrame.Visible then
			v32.FinalResults.Buttons:PlayAgain()
		end
	end
end
function v_u_13.SecondaryAction(p33) -- name: SecondaryAction
	if p33._elements.Pages then
		local v34 = p33:_GetSpectatedDuelInterface()
		if v34 then
			if v34.FinalResults.Buttons.RematchFrame.Visible then
				v34.FinalResults.Buttons:Rematch()
			end
		else
			local v35 = p33:_GetSpectatedSubject()
			if v35 then
				v35 = v35:Get("IsInShootingRange") or v35:Get("IsInDuel")
			end
			local v36 = p33:IsPageOpen()
			if not (v36 or v35) or v36 and v36.Name ~= "Party" then
				local v37 = p33._elements.Lobby and p33._elements.Lobby.Party
				if v37 then
					v37 = p33._elements.Lobby.Party.IsVisible
				end
				local v38 = p33._elements.SideParty
				if v38 then
					v38 = p33._elements.SideParty.IsVisible
				end
				if v37 or v38 then
					p33._elements.Pages.PageSystem:OpenPage("Party", true)
					return
				end
			end
		end
	else
		return
	end
end
function v_u_13.TertiaryAction(p39) -- name: TertiaryAction
	-- upvalues: (copy) v_u_7
	if p39._elements.Lobby and (p39._elements.Lobby.Play and (p39._elements.Lobby.Play.IsHubVisible and v_u_7:IsUIElementVisible(p39._elements.Lobby.Play.HubButton))) then
		p39._elements.Lobby.Play:GoBackToHub()
	end
end
function v_u_13.QuaternaryAction(p40) -- name: QuaternaryAction
	-- upvalues: (copy) v_u_7
	if p40._elements.Lobby and (p40._elements.Lobby.Play and (p40._elements.Lobby.Play.IsRematchVisible and v_u_7:IsUIElementVisible(p40._elements.Lobby.Play.RematchButton))) then
		p40._elements.Lobby.Play:RematchRequest()
	end
end
function v_u_13._GetSpectatedSubject(_) -- name: _GetSpectatedSubject
	-- upvalues: (copy) v_u_5
	return require(v_u_5.LocalPlayer.PlayerScripts.Controllers.SpectateController).CurrentSubject
end
function v_u_13._GetSpectatedDuelInterface(_) -- name: _GetSpectatedDuelInterface
	-- upvalues: (copy) v_u_5
	local v41 = require(v_u_5.LocalPlayer.PlayerScripts.Controllers.SpectateController)
	local v42 = v41.CurrentDuelSubject
	if v42 then
		v42 = v41.CurrentDuelSubject.DuelInterface
	end
	return v42
end
function v_u_13._CheckSelectedObjectVisible(_) -- name: _CheckSelectedObjectVisible
	-- upvalues: (copy) v_u_4, (copy) v_u_7, (copy) v_u_3
	if v_u_4.SelectedObject and not v_u_7:IsUIElementVisible(v_u_4.SelectedObject) then
		v_u_3:DisableGamepadCursor()
	end
end
function v_u_13._UpdateSelectedObject(p_u_43) -- name: _UpdateSelectedObject
	-- upvalues: (copy) v_u_5, (copy) v_u_4, (copy) v_u_3
	if v_u_5.LocalPlayer:FindFirstChild("PlayerGui") then
		if v_u_4.SelectedObject then
			for _, v44 in pairs(p_u_43._selected_object_connections) do
				v44:Disconnect()
			end
			p_u_43._selected_object_connections = {}
			local v45 = p_u_43._selected_object_connections
			local v46 = v_u_4.SelectedObject.AncestryChanged
			table.insert(v45, v46:Connect(function()
				-- upvalues: (copy) p_u_43
				p_u_43:_CheckSelectedObjectVisible()
			end))
			local v47 = p_u_43._selected_object_connections
			local v48 = v_u_4.SelectedObject:GetPropertyChangedSignal("Visible")
			table.insert(v47, v48:Connect(function()
				-- upvalues: (copy) p_u_43
				p_u_43:_CheckSelectedObjectVisible()
			end))
			p_u_43:_CheckSelectedObjectVisible()
			return
		else
			local v49 = p_u_43:GetDefaultElement()
			local v50
			if v49 and (v49:IsDescendantOf(v_u_5.LocalPlayer.PlayerGui) and v49) then
				v50 = v49
			else
				v50 = nil
			end
			if v49 then
				v_u_3:EnableGamepadCursor(v50)
				v_u_4.SelectedObject = v50
			else
				v_u_3:DisableGamepadCursor()
				v_u_4.SelectedObject = nil
			end
		end
	else
		return
	end
end
function v_u_13._UpdateGamepadControls(p51) -- name: _UpdateGamepadControls
	-- upvalues: (copy) v_u_9
	for _, v52 in pairs(p51._gamepad_connections) do
		v52:Disconnect()
	end
	for _, v53 in pairs(p51._selected_object_connections) do
		v53:Disconnect()
	end
	p51._gamepad_connections = {}
	p51._selected_object_connections = {}
	if v_u_9.CurrentControls ~= "Gamepad" then
	end
end
function v_u_13._Setup(p_u_54) -- name: _Setup
	-- upvalues: (copy) v_u_12, (copy) v_u_10, (copy) v_u_5
	task.defer(function()
		-- upvalues: (ref) v_u_12, (copy) p_u_54, (ref) v_u_10
		for _, v55 in pairs(v_u_12) do
			p_u_54._elements[v55] = require(v_u_10:WaitForChild(v55))
		end
		p_u_54._elements.Pages.PageSystem.PagesActivity:Connect(function(...)
			-- upvalues: (ref) p_u_54
			p_u_54.PageSystemPagesActivity:Fire(...)
		end)
		p_u_54._elements.Equipment.Opened:Connect(function(...)
			-- upvalues: (ref) p_u_54
			p_u_54.EquipmentOpened:Fire(...)
		end)
		p_u_54._are_elements_loaded = true
		p_u_54.ElementsLoaded:Fire()
	end)
	p_u_54.MainGui.Parent = v_u_5.LocalPlayer:WaitForChild("PlayerGui")
end
function v_u_13._Init(p_u_56) -- name: _Init
	-- upvalues: (copy) v_u_9, (copy) v_u_2, (copy) v_u_6
	v_u_9.ControlsChanged:Connect(function()
		-- upvalues: (copy) p_u_56
		p_u_56:_UpdateGamepadControls()
	end)
	v_u_2.InputBegan:Connect(function(p57, p58)
		-- upvalues: (ref) v_u_6, (copy) p_u_56
		if p58 then
			return
		elseif v_u_6:InputIs(p57, "UICancelAction") then
			p_u_56:CloseRequest()
			return
		elseif v_u_6:InputIs(p57, "UIPrimaryAction") then
			p_u_56:PrimaryAction()
			return
		elseif v_u_6:InputIs(p57, "UISecondaryAction") then
			p_u_56:SecondaryAction()
			return
		elseif v_u_6:InputIs(p57, "UITertiaryAction") then
			p_u_56:TertiaryAction()
		elseif v_u_6:InputIs(p57, "UIQuaternaryAction") then
			p_u_56:QuaternaryAction()
		end
	end)
	p_u_56:_Setup()
	p_u_56:_UpdateGamepadControls()
end
return v_u_13._new()