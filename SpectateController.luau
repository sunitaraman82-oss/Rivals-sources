-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
game:GetService("StarterGui")
local v_u_3 = game:GetService("RunService")
local v_u_4 = game:GetService("Players")
local v_u_5 = require(v_u_1.Modules.CONSTANTS)
local v_u_6 = require(v_u_1.Modules.InputLibrary)
local v_u_7 = require(v_u_1.Modules.Signal)
local v_u_8 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_9 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.CameraController)
local v_u_10 = require(v_u_4.LocalPlayer.PlayerScripts.Controllers.DuelController)
local v_u_11 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface.Teleporting)
local v_u_12 = require(v_u_4.LocalPlayer.PlayerScripts.Modules.UserInterface.Queue)
local v_u_13 = {}
v_u_13.__index = v_u_13
function v_u_13._new() -- name: _new
	-- upvalues: (copy) v_u_13, (copy) v_u_7
	local v14 = v_u_13
	local v15 = setmetatable({}, v14)
	v15.SubjectChanged = v_u_7.new()
	v15.SubjectEmoteStatusChanged = v_u_7.new()
	v15.DuelSubjectChanged = v_u_7.new()
	v15.DuelSubjectEnvironmentIDChanged = v_u_7.new()
	v15.DuelSubjectStatusChanged = v_u_7.new()
	v15.Subjects = {}
	v15.CurrentSubject = nil
	v15.CurrentDuelSubject = nil
	v15._duel_connections = {}
	v15._subject_connections = {}
	v15._last_spectating_user_id = nil
	v15._spectate_duel_request_queue = {}
	v15._spectate_duel_request_queue_active = false
	v15._duel_just_spectated = {}
	v15._firing_subject_changed = nil
	v15._process_mb2_on_input_ended_delta = nil
	v15:_Init()
	return v15
end
function v_u_13.IsRendered(p16, p17) -- name: IsRendered
	-- upvalues: (copy) v_u_5, (copy) v_u_4
	local v18 = not v_u_5.IS_ARCADE_SERVER and (v_u_4.LocalPlayer:GetAttribute("EnvironmentID") ~= p17 and p16.CurrentDuelSubject)
	if v18 then
		v18 = p16.CurrentDuelSubject:Get("EnvironmentID") == p17
	end
	return v18
end
function v_u_13.IsSubjectEmoting(p19) -- name: IsSubjectEmoting
	local v20 = p19.CurrentSubject and p19.CurrentSubject.Entity
	if v20 then
		v20 = p19.CurrentSubject.Entity:IsEmoting()
	end
	return v20
end
function v_u_13.IsThereValidSubject(p21, p22) -- name: IsThereValidSubject
	for _, v23 in pairs(p21.Subjects) do
		if v23 ~= p22 and p21:_IsValidSubject(v23) then
			return true
		end
	end
	return false
end
function v_u_13.Increment(p24, p25) -- name: Increment
	if p24.CurrentDuelSubject and not (p24.CurrentSubject and p24.CurrentSubject.IsLocalPlayer) then
		if p24:IsThereValidSubject(p24.CurrentSubject) then
			local v26 = p24.CurrentSubject and (table.find(p24.Subjects, p24.CurrentSubject) or 0) or 0
			local v27
			if v26 or p25 ~= 1 then
				if v26 or p25 ~= -1 then
					if p25 == 1 and v26 == #p24.Subjects then
						v27 = 1
					elseif p25 == -1 and v26 == 1 then
						v27 = #p24.Subjects
					else
						v27 = v26 + p25
					end
				else
					v27 = #p24.Subjects
				end
			else
				v27 = 1
			end
			p24:_RawSetCurrentSubject(p24.Subjects[v27])
			p24:_VerifySubject(p25 == -1)
		end
	else
		return
	end
end
function v_u_13.Next(p28) -- name: Next
	p28._duel_just_spectated = {}
	p28:Increment(1)
end
function v_u_13.Last(p29) -- name: Last
	p29._duel_just_spectated = {}
	p29:Increment(-1)
end
function v_u_13.Exit(p30) -- name: Exit
	if p30.CurrentDuelSubject and not p30.CurrentDuelSubject.LocalDueler then
		p30:SpectateDuelRequest(nil)
	end
end
function v_u_13.SpectateDuelRequest(p_u_31, p32) -- name: SpectateDuelRequest
	-- upvalues: (copy) v_u_12, (copy) v_u_10, (copy) v_u_4, (copy) v_u_1
	if not p32 or (p32.LocalDueler or not v_u_12:IsVisible()) then
		local v33 = v_u_10:GetDuel(v_u_4.LocalPlayer) or p32
		local v34 = p_u_31._spectate_duel_request_queue
		table.insert(v34, { v33 })
		task.spawn(function()
			-- upvalues: (copy) p_u_31, (ref) v_u_1
			if not p_u_31._spectate_duel_request_queue_active then
				p_u_31._spectate_duel_request_queue_active = true
				while #p_u_31._spectate_duel_request_queue > 0 do
					local v35 = table.remove(p_u_31._spectate_duel_request_queue, 1)
					local v36 = p_u_31.CurrentDuelSubject and p_u_31.CurrentDuelSubject:Get("ObjectID") or nil
					local v37 = v35[1] and v35[1]:Get("ObjectID") or nil
					if v37 ~= v36 then
						v_u_1.Remotes.Replication.Fighter.SpectateDuel:FireServer(v37)
						wait(1)
					end
				end
				p_u_31._spectate_duel_request_queue = {}
				p_u_31._spectate_duel_request_queue_active = false
			end
		end)
	end
end
function v_u_13.Update(p38, p39) -- name: Update
	-- upvalues: (copy) v_u_8, (copy) v_u_5
	local v40 = p38.CurrentDuelSubject and p38.CurrentDuelSubject:GetFighters() or v_u_8:GetFightersNotInDuel()
	if v_u_8.LocalFighter and not table.find(v40, v_u_8.LocalFighter) then
		local v41 = v_u_8.LocalFighter
		table.insert(v40, v41)
	end
	local v42 = {}
	for _, v43 in pairs(v40) do
		if not v42[v43.Player] then
			v42[v43.Player] = true
			if v_u_5.IS_TESTING_SERVER then
				v43:Update(p39)
			else
				local v44, v45 = pcall(v43.Update, v43, p39)
				if not v44 then
					warn("ClientFighter::Update errored:", v45)
				end
			end
		end
	end
end
function v_u_13._IsValidSubject(p46, p47) -- name: _IsValidSubject
	-- upvalues: (copy) v_u_9
	if v_u_9:GetPublicState() == v_u_9.CameraState.States.CustomFreecam then
		return false
	end
	if not (p47 and p47:IsAlive()) then
		return false
	end
	if p46.CurrentDuelSubject and not table.find(p46.CurrentDuelSubject:GetFighters(), p47) then
		return false
	end
	if not (p46.CurrentDuelSubject and p46.CurrentDuelSubject.LocalDueler) then
		return true
	end
	if p46.CurrentDuelSubject and (p46.CurrentDuelSubject.LocalDueler and p46.CurrentDuelSubject.LocalDueler:IsAlive()) then
		return p47 == p46.CurrentDuelSubject.LocalDueler.ClientFighter
	end
	local v48 = p46.CurrentDuelSubject.LocalDueler:Get("TeamID")
	if not v48 then
		return true
	end
	if p46.CurrentDuelSubject:Get("IsCurrentArcadeDuel") then
		return true
	end
	local v49 = false
	for _, v50 in pairs(p46.CurrentDuelSubject.Duelers) do
		if v50:Get("TeamID") == v48 and v50:IsAlive() then
			v49 = true
			break
		end
	end
	return (not p46.CurrentDuelSubject:Get("StaggeredSpawns") or p46.CurrentDuelSubject:Get("Status") == "RoundFinished") and not v49 and true or p47:Get("TeamID") == v48
end
function v_u_13._RawSetCurrentSubject(p51, p52) -- name: _RawSetCurrentSubject
	if p52 ~= p51.CurrentSubject then
		for _, v53 in pairs(p51._subject_connections) do
			v53:Disconnect()
		end
		p51._subject_connections = {}
		if p51.CurrentSubject then
			p51.CurrentSubject:SetReplicate("IsSpectating", false)
			if p51.CurrentDuelSubject and p51.CurrentSubject.Player then
				p51._duel_just_spectated[p51.CurrentSubject.Player] = tick()
			end
		end
		p51.CurrentSubject = p52
		p51.SubjectChanged:FireDeferred()
		if p51.CurrentSubject then
			p51.CurrentSubject:SetReplicate("IsSpectating", true)
		end
	end
end
function v_u_13._VerifySubject(p_u_54, p55) -- name: _VerifySubject
	local v56 = p_u_54.CurrentSubject and (table.find(p_u_54.Subjects, p_u_54.CurrentSubject) or 1) or 1
	local v57 = p55 and -1 or 1
	local v58 = nil
	for v59 = 1, #p_u_54.Subjects do
		local v60 = (v56 + (v59 - 1) * v57 - 1) % #p_u_54.Subjects + 1
		local v61 = p_u_54.Subjects[v60]
		if p_u_54:_IsValidSubject(v61) then
			v58 = v61
			break
		end
	end
	if v58 == p_u_54.CurrentSubject then
		return
	else
		p_u_54:_RawSetCurrentSubject(v58)
		if p_u_54.CurrentSubject then
			local function v62() -- name: verify_subject
				-- upvalues: (copy) p_u_54
				p_u_54:_VerifySubject()
			end
			local v63 = p_u_54._subject_connections
			local v64 = p_u_54.CurrentSubject.EntityRemoved
			table.insert(v63, v64:Connect(v62))
			local v65 = p_u_54._subject_connections
			local v66 = p_u_54.CurrentSubject.EntityAdded
			table.insert(v65, v66:Connect(v62))
			local v67 = p_u_54._subject_connections
			local v68 = p_u_54.CurrentSubject.Died
			table.insert(v67, v68:Connect(v62))
			local v69 = p_u_54._subject_connections
			local v70 = p_u_54.CurrentSubject.EntityAdded
			table.insert(v69, v70:Connect(function(p71) -- name: entity_added
				-- upvalues: (copy) p_u_54
				local v72 = p_u_54._subject_connections
				local v73 = p71.EmoteStatusChanged
				local function v74()
					-- upvalues: (ref) p_u_54
					p_u_54.SubjectEmoteStatusChanged:Fire()
				end
				table.insert(v72, v73:Connect(v74))
			end))
			if p_u_54.CurrentSubject.Entity then
				local v75 = p_u_54.CurrentSubject.Entity
				local v76 = p_u_54._subject_connections
				local v77 = v75.EmoteStatusChanged
				table.insert(v76, v77:Connect(function()
					-- upvalues: (copy) p_u_54
					p_u_54.SubjectEmoteStatusChanged:Fire()
				end))
			end
		end
	end
end
function v_u_13._CleanupCurrentDuelSubject(p78, p79) -- name: _CleanupCurrentDuelSubject
	for _, v80 in pairs(p78._duel_connections) do
		v80:Disconnect()
	end
	p78._duel_connections = {}
	p78._duel_just_spectated = {}
	for v81 = #p78.Subjects, 1, -1 do
		p78:_RemoveSubject(p78.Subjects[v81], true)
	end
	p78:_VerifySubject()
	if p78.CurrentDuelSubject and p78.CurrentDuelSubject ~= p79 then
		p78.CurrentDuelSubject:SetReplicate("IsSpectating", false)
		for _, v82 in pairs(p78.CurrentDuelSubject.Duelers) do
			if v82.ClientFighter then
				v82.ClientFighter:ClearInterface()
				v82.ClientFighter:ClearSounds(true)
			end
		end
	end
end
function v_u_13._SpectateDuel(p_u_83, p84) -- name: _SpectateDuel
	-- upvalues: (copy) v_u_10, (copy) v_u_4
	local v85 = v_u_10:GetDuel(v_u_4.LocalPlayer)
	if v85 and p84 ~= v85 then
		return
	else
		p_u_83:_CleanupCurrentDuelSubject(p84)
		p_u_83.CurrentDuelSubject = p84
		p_u_83.DuelSubjectChanged:Fire()
		if p_u_83.CurrentDuelSubject then
			p_u_83.CurrentDuelSubject:SetReplicate("IsSpectating", true)
			local v86 = p_u_83._duel_connections
			local v87 = p_u_83.CurrentDuelSubject:GetDataChangedSignal("EnvironmentID")
			table.insert(v86, v87:Connect(function()
				-- upvalues: (copy) p_u_83
				p_u_83.DuelSubjectEnvironmentIDChanged:Fire()
			end))
			local v88 = p_u_83._duel_connections
			local v89 = p_u_83.CurrentDuelSubject:GetDataChangedSignal("Status")
			table.insert(v88, v89:Connect(function()
				-- upvalues: (copy) p_u_83
				p_u_83.DuelSubjectStatusChanged:Fire()
			end))
			local function v_u_90() -- name: verify_subject
				-- upvalues: (copy) p_u_83
				p_u_83:_VerifySubject()
			end
			local v91 = p_u_83._duel_connections
			local v92 = p_u_83.CurrentDuelSubject:GetDataChangedSignal("IsCurrentArcadeDuel")
			table.insert(v91, v92:Connect(v_u_90))
			local v93 = p_u_83._duel_connections
			local v94 = p_u_83.CurrentDuelSubject:GetDataChangedSignal("Status")
			table.insert(v93, v94:Connect(v_u_90))
			task.defer(v_u_90)
			local v95 = p_u_83._duel_connections
			local v96 = p_u_83.CurrentDuelSubject.DuelerRemoved
			table.insert(v95, v96:Connect(function(p97) -- name: dueler_removed
				-- upvalues: (copy) p_u_83
				if p97.IsLocalPlayer then
					p_u_83:SpectateDuelRequest(nil)
				else
					p_u_83:_RemoveSubject(p97.ClientFighter)
				end
			end))
			local function v112(p98, p99) -- name: dueler_added
				-- upvalues: (copy) p_u_83, (copy) v_u_90
				local v100 = p_u_83._duel_connections
				local v101 = p98:GetDataChangedSignal("TeamID")
				local v102 = v_u_90
				table.insert(v100, v101:Connect(v102))
				local v103 = p_u_83._duel_connections
				local v104 = p98.EntityAdded
				local v105 = v_u_90
				table.insert(v103, v104:Connect(v105))
				local v106 = p_u_83._duel_connections
				local v107 = p98.Eliminated
				local v108 = v_u_90
				table.insert(v106, v107:Connect(v108))
				local v109 = p_u_83._duel_connections
				local v110 = p98.Died
				local v111 = v_u_90
				table.insert(v109, v110:Connect(v111))
				p_u_83:_AddSubject(p98.ClientFighter, p99)
			end
			local v113 = p_u_83._duel_connections
			local v114 = p_u_83.CurrentDuelSubject.DuelerAdded
			table.insert(v113, v114:Connect(v112))
			for _, v115 in pairs(p_u_83.CurrentDuelSubject.Duelers) do
				task.spawn(v112, v115, true)
			end
			local v116 = p_u_83._duel_connections
			local v117 = p_u_83.CurrentDuelSubject.SpectateThisPlayer
			table.insert(v116, v117:Connect(function(p118, p119)
				-- upvalues: (copy) p_u_83
				if tick() > (p_u_83._duel_just_spectated[p118] or 0) + 0.3 then
					return
				end
				local v120 = nil
				for _, v121 in pairs(p_u_83.Subjects) do
					if v121.Player == p119 then
						v120 = v121
						break
					end
				end
				p_u_83:_RawSetCurrentSubject(v120)
				p_u_83:_VerifySubject()
			end))
		end
	end
end
function v_u_13._AddSubject(p122, p123, p124) -- name: _AddSubject
	if not table.find(p122.Subjects, p123) then
		local v125 = p122.Subjects
		table.insert(v125, p123)
		if not p124 then
			p122:_VerifySubject()
		end
	end
end
function v_u_13._RemoveSubject(p126, p127, p128) -- name: _RemoveSubject
	if p127.IsLocalPlayer then
		return
	else
		local v129 = table.find(p126.Subjects, p127)
		if v129 then
			if p127 == p126.CurrentSubject then
				p126:Increment(-1)
			end
			table.remove(p126.Subjects, v129)
			if not p128 then
				p126:_VerifySubject()
			end
		end
	end
end
function v_u_13._SpectatingReplicationLoop(p130) -- name: _SpectatingReplicationLoop
	-- upvalues: (copy) v_u_1
	while true do
		wait(1)
		local v131 = p130.CurrentSubject
		if v131 then
			v131 = p130.CurrentSubject.Player.UserId
		end
		if v131 ~= p130._last_spectating_user_id then
			p130._last_spectating_user_id = v131
			v_u_1.Remotes.Replication.Fighter.Spectating:FireServer(p130._last_spectating_user_id)
		end
	end
end
function v_u_13._ProcessInput(p132, p133) -- name: _ProcessInput
	-- upvalues: (copy) v_u_9, (copy) v_u_6
	local v134 = v_u_9:GetPublicState() == v_u_9.CameraState.States.CustomFreecam
	if v_u_6:InputIs(p133, "SpectateNext") and not v134 then
		p132:Next()
		return
	elseif v_u_6:InputIs(p133, "SpectateLast") and not v134 then
		p132:Last()
	elseif v_u_6:InputIs(p133, "SpectateExit") then
		p132:Exit()
	end
end
function v_u_13._HookLocalFighter(p_u_135) -- name: _HookLocalFighter
	-- upvalues: (copy) v_u_8, (copy) v_u_10
	local v_u_136 = v_u_8:WaitForLocalFighter()
	local function v138() -- name: update_duel_subject
		-- upvalues: (copy) v_u_136, (ref) v_u_10, (copy) p_u_135
		local v137 = v_u_136:Get("SpectatingDuelObjectID")
		p_u_135:_SpectateDuel(v137 and v_u_10:GetDuelByID(v137) or nil)
	end
	v_u_136:GetDataChangedSignal("SpectatingDuelObjectID"):Connect(v138)
	local v139 = v_u_136:Get("SpectatingDuelObjectID")
	p_u_135:_SpectateDuel(v139 and v_u_10:GetDuelByID(v139) or nil)
end
function v_u_13._Init(p_u_140) -- name: _Init
	-- upvalues: (copy) v_u_9, (copy) v_u_3, (copy) v_u_2, (copy) v_u_8, (copy) v_u_10, (copy) v_u_11, (copy) v_u_12
	p_u_140.SubjectChanged:Connect(function()
		-- upvalues: (copy) p_u_140, (ref) v_u_9
		p_u_140.SubjectEmoteStatusChanged:Fire()
		v_u_9:SetSubject(p_u_140.CurrentSubject)
	end)
	p_u_140.DuelSubjectChanged:Connect(function()
		-- upvalues: (copy) p_u_140, (ref) v_u_9
		p_u_140:_VerifySubject()
		v_u_9.CameraState:SetCustomFreecamEnabled(false)
		v_u_9:SetDuelSubject(p_u_140.CurrentDuelSubject)
	end)
	v_u_3:BindToRenderStep("SpectateController", Enum.RenderPriority.Camera.Value + 1, function(p141)
		-- upvalues: (copy) p_u_140
		p_u_140:Update(p141)
	end)
	v_u_2.InputBegan:Connect(function(p142, p143)
		-- upvalues: (ref) v_u_9, (copy) p_u_140
		if p143 then
			return
		elseif v_u_9:GetPublicState() == v_u_9.CameraState.States.ThirdPersonUnlockedMouse and p142.UserInputType == Enum.UserInputType.MouseButton2 then
			p_u_140._process_mb2_on_input_ended_delta = 0
		else
			p_u_140:_ProcessInput(p142)
		end
	end)
	v_u_2.InputChanged:Connect(function(p144, _)
		-- upvalues: (copy) p_u_140
		if p_u_140._process_mb2_on_input_ended_delta and p144.UserInputType == Enum.UserInputType.MouseMovement then
			local v145 = p_u_140
			v145._process_mb2_on_input_ended_delta = v145._process_mb2_on_input_ended_delta + Vector2.new(p144.Delta.X, p144.Delta.Y).Magnitude
		end
	end)
	v_u_2.InputEnded:Connect(function(p146, _)
		-- upvalues: (copy) p_u_140
		local v147 = p_u_140._process_mb2_on_input_ended_delta
		if v147 and p146.UserInputType == Enum.UserInputType.MouseButton2 then
			p_u_140._process_mb2_on_input_ended_delta = nil
			if v147 <= 5 then
				p_u_140:_ProcessInput(p146)
			end
		else
			return
		end
	end)
	v_u_8.ObjectAdded:Connect(function(p148)
		-- upvalues: (copy) p_u_140
		if p148.IsLocalPlayer then
			p148.EntityAdded:Connect(function()
				-- upvalues: (ref) p_u_140
				p_u_140:_VerifySubject()
			end)
			p148.EntityRemoved:Connect(function()
				-- upvalues: (ref) p_u_140
				p_u_140:_VerifySubject()
			end)
			p148.Died:Connect(function()
				-- upvalues: (ref) p_u_140
				p_u_140:_VerifySubject()
			end)
			p_u_140:_AddSubject(p148)
		end
	end)
	v_u_8.ObjectRemoved:Connect(function(p149)
		-- upvalues: (copy) p_u_140
		p_u_140:_RemoveSubject(p149)
	end)
	v_u_10.LocalPlayerJoinedDuel:Connect(function(p150, p151)
		-- upvalues: (copy) p_u_140
		p_u_140:SpectateDuelRequest(p150, p151)
	end)
	v_u_10.LocalPlayerLeftDuel:Connect(function(_, _)
		-- upvalues: (copy) p_u_140
		p_u_140:SpectateDuelRequest(nil)
	end)
	v_u_10.ObjectRemoved:Connect(function(p152)
		-- upvalues: (copy) p_u_140
		if p_u_140.CurrentDuelSubject == p152 then
			p_u_140:SpectateDuelRequest(nil)
		end
	end)
	v_u_9.CustomFreecamStateChanged:Connect(function()
		-- upvalues: (copy) p_u_140
		p_u_140:_VerifySubject()
	end)
	v_u_11.EnabledChanged:Connect(function()
		-- upvalues: (ref) v_u_11, (copy) p_u_140
		if v_u_11.Enabled then
			p_u_140:SpectateDuelRequest(nil)
		end
	end)
	v_u_12.VisibilityChanged:Connect(function()
		-- upvalues: (ref) v_u_12, (copy) p_u_140
		if v_u_12:IsVisible() then
			p_u_140:SpectateDuelRequest(nil)
		end
	end)
	p_u_140:_VerifySubject()
	task.spawn(p_u_140._HookLocalFighter, p_u_140)
	task.spawn(p_u_140._SpectatingReplicationLoop, p_u_140)
end
return v_u_13._new()