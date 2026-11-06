-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
local v_u_3 = game:GetService("GuiService")
local v_u_4 = game:GetService("Players")
require(v1.Modules.CONSTANTS)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local v_u_7 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_8 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("MatchmakingCountdown"))
local v_u_9 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("MobileInputs"))
local v_u_10 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Teleporting"))
require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("PlayerList"))
local v_u_11 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UserInterface"):WaitForChild("Pages"))
local v_u_12 = require(v_u_4.LocalPlayer.PlayerScripts.Modules:WaitForChild("UILibrary"))
local v_u_13 = v_u_4.LocalPlayer.PlayerScripts.UserInterface:WaitForChild("PlayerInteractionGui")
local v_u_14 = {}
v_u_14.__index = v_u_14
function v_u_14._new() -- name: _new
	-- upvalues: (copy) v_u_14, (copy) v_u_13
	local v15 = v_u_14
	local v16 = setmetatable({}, v15)
	v16.LocalFighter = nil
	v16._connections = {}
	v16._changed_connections = {}
	v16._bbg = v_u_13:Clone()
	v16._highlight = nil
	v16._next_whitelist = 0
	v16._whitelist = {}
	v16._disabled_until = 0
	v16._hash = 0
	v16:_Init()
	return v16
end
function v_u_14._SetAdornee(p17, p18) -- name: _SetAdornee
	-- upvalues: (copy) v_u_4
	p17._bbg.Adornee = p18 or nil
	local v19 = p17._bbg
	local v20
	if p18 then
		v20 = v_u_4.LocalPlayer.PlayerGui
	else
		v20 = nil
	end
	v19.Parent = v20
end
function v_u_14._GetWhitelist(p21) -- name: _GetWhitelist
	-- upvalues: (copy) v_u_7
	if tick() > p21._next_whitelist then
		p21._next_whitelist = tick() + 3
		p21._whitelist = v_u_7:GetFighterModels()
	end
	return p21._whitelist
end
function v_u_14._ClearChangedConnections(p22) -- name: _ClearChangedConnections
	for _, v23 in pairs(p22._changed_connections) do
		v23:Disconnect()
	end
	p22._changed_connections = {}
end
function v_u_14._Verify(p_u_24) -- name: _Verify
	-- upvalues: (copy) v_u_11, (copy) v_u_6, (copy) v_u_9, (copy) v_u_10, (copy) v_u_8, (copy) v_u_3, (copy) v_u_4, (copy) v_u_12, (copy) v_u_5, (copy) v_u_2
	for _, v25 in pairs(p_u_24._connections) do
		v25:Disconnect()
	end
	p_u_24._connections = {}
	if p_u_24._highlight then
		p_u_24._highlight:Destroy()
		p_u_24._highlight = nil
	end
	p_u_24:_SetAdornee(nil)
	p_u_24:_ClearChangedConnections()
	p_u_24._hash = p_u_24._hash + 1
	local v_u_26 = p_u_24._hash
	if p_u_24.LocalFighter and not (p_u_24.LocalFighter:Get("IsInDuel") or (p_u_24.LocalFighter:Get("IsInShootingRange") or p_u_24.LocalFighter.Entity and p_u_24.LocalFighter.Entity:Get("IsGrabbingSnowball"))) and tick() >= p_u_24._disabled_until then
		if not (v_u_11.PageSystem.CurrentPage or (v_u_6.CurrentDuelSubject or (v_u_9.EditorEnabled or (v_u_10.Enabled or (v_u_8:IsVisible() or v_u_3.MenuIsOpen))))) then
			p_u_24._highlight = Instance.new("Highlight")
			p_u_24._highlight.Name = "PlayerInteraction"
			p_u_24._highlight.FillColor = Color3.fromRGB(255, 255, 255)
			p_u_24._highlight.Parent = v_u_4.LocalPlayer.PlayerGui
			local function v_u_31() -- name: get_hovered_player_object
				-- upvalues: (ref) v_u_12, (ref) v_u_5, (copy) p_u_24, (ref) v_u_4
				local v27 = v_u_12:GetMouseLocation()
				local v28 = workspace.CurrentCamera:ScreenPointToRay(v27.X, v27.Y, 0)
				local v29 = v_u_5:GetCharacterModel(v_u_5:Raycast(v28.Origin, v28.Origin + v28.Direction * 100, 100, p_u_24:_GetWhitelist(), Enum.RaycastFilterType.Include).Instance)
				local v30
				if v29 then
					v30 = v_u_4:GetPlayerFromCharacter(v29)
				else
					v30 = v29
				end
				if not v29 or (not v29:FindFirstChild("HumanoidRootPart") or (workspace.CurrentCamera.CFrame.Position - v29.HumanoidRootPart.Position).Magnitude >= 5) then
					return v30, v29
				end
			end
			local v_u_32 = nil
			local v_u_33 = 0
			if p_u_24._hash == v_u_26 then
				local v34 = tick() - v_u_33 < 0.25
				p_u_24._highlight.FillTransparency = v34 and 0.5 or 0.75
				p_u_24._highlight.OutlineTransparency = v34 and 0 or 0.5
				p_u_24._bbg.Container.Title.Text = v34 and "Tap again to view profile" or "Double tap to view profile"
			end
			local v35 = p_u_24._connections
			local v36 = v_u_2.InputBegan
			local function v48(p_u_37)
				-- upvalues: (ref) v_u_33, (ref) v_u_32, (copy) p_u_24, (copy) v_u_26, (copy) v_u_31
				if p_u_37.UserInputType == Enum.UserInputType.MouseButton1 or (p_u_37.UserInputType == Enum.UserInputType.Touch or p_u_37.KeyCode == Enum.KeyCode.ButtonX) then
					if tick() - v_u_33 > 0.25 then
						v_u_32 = nil
					end
					v_u_33 = tick()
					if p_u_24._hash == v_u_26 then
						local v38 = tick() - v_u_33 < 0.25
						p_u_24._highlight.FillTransparency = v38 and 0.5 or 0.75
						p_u_24._highlight.OutlineTransparency = v38 and 0 or 0.5
						p_u_24._bbg.Container.Title.Text = v38 and "Tap again to view profile" or "Double tap to view profile"
					end
					task.delay(0.25, function()
						-- upvalues: (ref) p_u_24, (ref) v_u_26, (ref) v_u_33
						if p_u_24._hash == v_u_26 then
							local v39 = tick() - v_u_33 < 0.25
							p_u_24._highlight.FillTransparency = v39 and 0.5 or 0.75
							p_u_24._highlight.OutlineTransparency = v39 and 0 or 0.5
							p_u_24._bbg.Container.Title.Text = v39 and "Tap again to view profile" or "Double tap to view profile"
						end
					end)
					if p_u_37.UserInputType == Enum.UserInputType.Touch then
						p_u_24:_ClearChangedConnections()
						local v40 = p_u_24._changed_connections
						local v41 = p_u_37:GetPropertyChangedSignal("Position")
						local function v44()
							-- upvalues: (ref) v_u_31, (ref) p_u_24
							local _, v42 = v_u_31()
							p_u_24._highlight.Adornee = v42
							local v43 = p_u_24
							if v42 then
								v42 = v42:FindFirstChild("HumanoidRootPart")
							end
							v43:_SetAdornee(v42)
						end
						table.insert(v40, v41:Connect(v44))
						local v45 = p_u_24._changed_connections
						local v46 = p_u_37:GetPropertyChangedSignal("UserInputState")
						local function v47()
							-- upvalues: (copy) p_u_37, (ref) p_u_24
							if p_u_37.UserInputState == Enum.UserInputState.End then
								p_u_24:_ClearChangedConnections()
							end
						end
						table.insert(v45, v46:Connect(v47))
					end
				end
			end
			table.insert(v35, v36:Connect(v48))
			local v49 = p_u_24._connections
			local v50 = v_u_2.InputEnded
			local function v53(p51)
				-- upvalues: (ref) v_u_33, (copy) v_u_31, (ref) v_u_32, (ref) v_u_11
				if p51.UserInputType == Enum.UserInputType.MouseButton1 or (p51.UserInputType == Enum.UserInputType.Touch or p51.KeyCode == Enum.KeyCode.ButtonX) then
					if tick() - v_u_33 > 0.25 then
						return
					end
					local v52 = v_u_31()
					if not v52 then
						return
					end
					if v_u_32 == v52 then
						v_u_11.PageSystem:OpenPage("ViewProfile")
						v_u_11.PageSystem:WaitForPage("ViewProfile"):Fetch(v52)
						return
					end
					v_u_32 = v52
				end
			end
			table.insert(v49, v50:Connect(v53))
			local v54 = p_u_24._connections
			local v55 = workspace.CurrentCamera:GetPropertyChangedSignal("CFrame")
			table.insert(v54, v55:Connect(function() -- name: mouse_moved
				-- upvalues: (copy) v_u_31, (copy) p_u_24
				local _, v56 = v_u_31()
				p_u_24._highlight.Adornee = v56
				local v57 = p_u_24
				if v56 then
					v56 = v56:FindFirstChild("HumanoidRootPart")
				end
				v57:_SetAdornee(v56)
			end))
			local v58 = p_u_24._connections
			local v59 = v_u_2.InputChanged
			table.insert(v58, v59:Connect(function(p60)
				-- upvalues: (copy) v_u_31, (copy) p_u_24
				if p60.UserInputType == Enum.UserInputType.MouseMovement then
					local _, v61 = v_u_31()
					p_u_24._highlight.Adornee = v61
					local v62 = p_u_24
					if v61 then
						v61 = v61:FindFirstChild("HumanoidRootPart")
					end
					v62:_SetAdornee(v61)
				end
			end))
		end
	else
		return
	end
end
function v_u_14._HookLocalFighter(p_u_63) -- name: _HookLocalFighter
	-- upvalues: (copy) v_u_7
	p_u_63.LocalFighter = v_u_7:WaitForLocalFighter()
	p_u_63.LocalFighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
		-- upvalues: (copy) p_u_63
		p_u_63:_Verify()
	end)
	p_u_63.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(function()
		-- upvalues: (copy) p_u_63
		p_u_63:_Verify()
	end)
	local function v65(p64) -- name: entity_added
		-- upvalues: (copy) p_u_63
		p64:GetDataChangedSignal("IsGrabbingSnowball"):Connect(function()
			-- upvalues: (ref) p_u_63
			p_u_63._disabled_until = tick() + 2
			task.delay(2, p_u_63._Verify, p_u_63)
			p_u_63:_Verify()
		end)
		p_u_63:_Verify()
	end
	p_u_63.LocalFighter.EntityAdded:Connect(v65)
	if p_u_63.LocalFighter.Entity then
		task.defer(v65, p_u_63.LocalFighter.Entity)
	end
	p_u_63:_Verify()
end
function v_u_14._Setup(p66) -- name: _Setup
	-- upvalues: (copy) v_u_4
	p66._bbg.Name = "PlayerInteraction"
	p66._bbg.Parent = v_u_4.LocalPlayer.PlayerGui
end
function v_u_14._Init(p_u_67) -- name: _Init
	-- upvalues: (copy) v_u_11, (copy) v_u_6, (copy) v_u_10, (copy) v_u_9, (copy) v_u_8, (copy) v_u_3
	v_u_11.PageSystem.PageOpened:Connect(function()
		-- upvalues: (copy) p_u_67
		p_u_67:_Verify()
	end)
	v_u_11.PageSystem.PageClosed:Connect(function()
		-- upvalues: (copy) p_u_67
		p_u_67:_Verify()
	end)
	v_u_6.DuelSubjectChanged:Connect(function()
		-- upvalues: (copy) p_u_67
		p_u_67:_Verify()
	end)
	v_u_10.EnabledChanged:Connect(function()
		-- upvalues: (copy) p_u_67
		p_u_67:_Verify()
	end)
	v_u_9.EditorEnabledChanged:Connect(function()
		-- upvalues: (copy) p_u_67
		p_u_67:_Verify()
	end)
	v_u_8.VisibilityChanged:Connect(function()
		-- upvalues: (copy) p_u_67
		p_u_67:_Verify()
	end)
	v_u_3:GetPropertyChangedSignal("MenuIsOpen"):Connect(function()
		-- upvalues: (copy) p_u_67
		p_u_67:_Verify()
	end)
	p_u_67:_Setup()
	task.defer(p_u_67._Verify, p_u_67)
	task.spawn(p_u_67._HookLocalFighter, p_u_67)
end
return v_u_14._new()