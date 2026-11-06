-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("UserInputService")
game:GetService("ContentProvider")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.InputLibrary)
local v_u_5 = require(v1.Modules.Signal)
local v_u_6 = require(v_u_3.LocalPlayer.PlayerScripts.Modules.ReplicatedController)
local v_u_7 = setmetatable({}, v_u_6)
v_u_7.__index = v_u_7
function v_u_7._new() -- name: _new
	-- upvalues: (copy) v_u_6, (copy) v_u_7, (copy) v_u_5
	local v8 = v_u_6.new("Duel")
	local v9 = v_u_7
	local v10 = setmetatable(v8, v9)
	v10.LocalPlayerJoinedOrLeftDuel = v_u_5.new()
	v10.LocalPlayerJoinedDuel = v_u_5.new()
	v10.LocalPlayerLeftDuel = v_u_5.new()
	v10:_Init()
	return v10
end
function v_u_7.GetDuelByID(p11, p12) -- name: GetDuelByID
	for v13, v14 in pairs(p11.Objects) do
		if v14:Get("ObjectID") == p12 then
			return v14, v13
		end
	end
end
function v_u_7.GetDuel(p15, p16) -- name: GetDuel
	for v17, v18 in pairs(p15.Objects) do
		if v18:GetDueler(p16) then
			return v18, v17
		end
	end
end
function v_u_7._SetupInputs(p_u_19) -- name: _SetupInputs
	-- upvalues: (copy) v_u_3, (copy) v_u_2, (copy) v_u_4
	local v_u_20 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.ShootingRangeController)
	local v_u_21 = require(v_u_3.LocalPlayer.PlayerScripts.Controllers.FighterController)
	v_u_2.InputBegan:Connect(function(p22, p23)
		-- upvalues: (copy) p_u_19, (ref) v_u_3, (ref) v_u_4, (copy) v_u_21, (copy) v_u_20
		if p23 then
			return
		else
			local v24 = p_u_19:GetDuel(v_u_3.LocalPlayer)
			if v24 and (v24.DuelInterface.Buttons:IsSwitchItemsVisible() and v_u_4:InputIs(p22, "SwitchItems")) then
				v24.DuelInterface.Buttons:SwitchItemsRequest()
				return
			elseif v24 and (v24.DuelInterface.Buttons:IsRespawnNowVisible() and v_u_4:InputIs(p22, "Jump")) then
				v24.DuelInterface.Buttons:RespawnNowRequest()
			elseif v_u_4:InputIs(p22, "LeaveDuel") then
				if v24 then
					v24:LeaveDuelRequest()
					return
				end
				if v_u_21.LocalFighter and v_u_21.LocalFighter:Get("IsInShootingRange") then
					v_u_20:Leave()
				end
			end
		end
	end)
end
function v_u_7._Init(p_u_25) -- name: _Init
	-- upvalues: (copy) v_u_3
	p_u_25.ObjectAdded:Connect(function(p_u_26)
		-- upvalues: (copy) p_u_25, (ref) v_u_3
		local function v29(p_u_27) -- name: check_local_dueler
			-- upvalues: (copy) p_u_26, (ref) p_u_25
			if p_u_27 and p_u_27.IsLocalPlayer then
				p_u_26.DuelerRemoved:Connect(function(p28)
					-- upvalues: (copy) p_u_27, (ref) p_u_25, (ref) p_u_26
					if p28 == p_u_27 then
						p_u_25.LocalPlayerLeftDuel:Fire(p_u_26, p28)
						p_u_25.LocalPlayerJoinedOrLeftDuel:Fire(p_u_26, p28)
					end
				end)
				p_u_25.LocalPlayerJoinedDuel:Fire(p_u_26, p_u_27)
				p_u_25.LocalPlayerJoinedOrLeftDuel:Fire(p_u_26, p_u_27)
			end
		end
		p_u_26.DuelerAdded:Connect(v29)
		v29(p_u_26:GetDueler(v_u_3.LocalPlayer))
	end)
	p_u_25.ObjectRemoved:Connect(function(p30)
		-- upvalues: (ref) v_u_3, (copy) p_u_25
		local v31 = p30:GetDueler(v_u_3.LocalPlayer)
		if v31 then
			p_u_25.LocalPlayerLeftDuel:Fire(p30, v31)
			p_u_25.LocalPlayerJoinedOrLeftDuel:Fire(p30, v31)
		end
	end)
	task.defer(p_u_25._SetupInputs, p_u_25)
end
return v_u_7._new()