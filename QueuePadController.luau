-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

game:GetService("CollectionService")
local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.CONSTANTS)
local v_u_4 = require(v_u_1.Modules.Signal)
local v_u_5 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.MatchmakingController)
local v_u_6 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_7 = require(v_u_2.LocalPlayer.PlayerScripts.Controllers.DuelController)
local v_u_8 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.UserInterface.MatchmakingCountdown)
local v_u_9 = require(v_u_2.LocalPlayer.PlayerScripts.Modules.ReplicatedController)
local v_u_10 = setmetatable({}, v_u_9)
v_u_10.__index = v_u_10
function v_u_10._new() -- name: _new
	-- upvalues: (copy) v_u_9, (copy) v_u_10, (copy) v_u_4
	local v11 = v_u_9.new("QueuePad")
	local v12 = v_u_10
	local v13 = setmetatable(v11, v12)
	v13.LocalPlayerActivity = v_u_4.new()
	v13.ChallengeRequestCooldownChanged = v_u_4.new()
	v13._local_fighter = nil
	v13._update_loop_active = false
	v13._challenge_cooldowns = {}
	v13._actively_on_queue_pad = false
	v13:_Init()
	return v13
end
function v_u_10.IsChallengeRequestOnCooldown(p14, p15) -- name: IsChallengeRequestOnCooldown
	return tick() < (p14._challenge_cooldowns[p15] or 0)
end
function v_u_10.GetQueuePad(p16, p17) -- name: GetQueuePad
	for _, v18 in pairs(p16.Objects) do
		local v19 = v18:IsInQueue(p17)
		if v19 then
			return v18, v19
		end
	end
end
function v_u_10.CanChallenge(_, p20) -- name: CanChallenge
	-- upvalues: (copy) v_u_2, (copy) v_u_3, (copy) v_u_7
	local v21 = p20 and ((p20 ~= v_u_2.LocalPlayer or v_u_3.IS_STUDIO) and v_u_3.QUEUES_ACTIVE)
	if v21 then
		v21 = not v_u_7:GetDuel(p20)
	end
	return v21
end
function v_u_10.SendChallengeRequest(p22, p23) -- name: SendChallengeRequest
	-- upvalues: (copy) v_u_1
	if p22:CanChallenge(p23) and not p22:IsChallengeRequestOnCooldown(p23) then
		p22._challenge_cooldowns[p23] = tick() + 15
		p22.ChallengeRequestCooldownChanged:Fire()
		task.delay(15, p22.ChallengeRequestCooldownChanged.Fire, p22.ChallengeRequestCooldownChanged)
		v_u_1.Remotes.Misc.SendChallengeRequest:FireServer(p23)
	end
end
function v_u_10._QueueLeave(p24) -- name: _QueueLeave
	-- upvalues: (copy) v_u_1
	v_u_1.Remotes.Misc.QueueLeave:InvokeServer()
	p24._actively_on_queue_pad = false
end
function v_u_10._QueueJoin(p25, p26, p27) -- name: _QueueJoin
	-- upvalues: (copy) v_u_1
	p25._actively_on_queue_pad = true
	v_u_1.Remotes.Misc.QueueJoin:InvokeServer(p26:Get("ObjectID"), p27)
end
function v_u_10._CheckQueueStatus(p28) -- name: _CheckQueueStatus
	-- upvalues: (copy) v_u_2, (copy) v_u_8, (copy) v_u_5
	local v29 = p28._local_fighter:IsAlive()
	if v29 then
		v29 = p28._local_fighter.Player
	end
	local v30, v31 = p28:GetQueuePad(v_u_2.LocalPlayer)
	local v32 = v_u_8:IsVisible()
	if v30 then
		if not v29 or (p28._local_fighter:Get("IsInDuel") or (p28._local_fighter:Get("IsInShootingRange") or (not v30:IsWithin(v29, v31) or v32))) then
			p28:_QueueLeave()
			return
		end
	elseif v29 then
		for _, v33 in pairs(p28.Objects) do
			local v34 = v33:IsWithin(v29)
			if v34 then
				if v32 then
					v_u_5:TryLeaveQueue()
				else
					p28:_QueueJoin(v33, v34)
				end
			end
		end
	end
end
function v_u_10._UpdateLoop(p35) -- name: _UpdateLoop
	-- upvalues: (copy) v_u_3
	if p35._update_loop_active then
		return
	end
	p35._update_loop_active = true
	while true do
		wait(0.1)
		if v_u_3.IS_STUDIO then
			p35:_CheckQueueStatus()
		else
			local v36, v37 = pcall(p35._CheckQueueStatus, p35)
			if not v36 then
				warn("Failed to check queue status, error:", v37)
			end
		end
		if not p35._actively_on_queue_pad and (p35._local_fighter:Get("IsInDuel") or p35._local_fighter:Get("IsInShootingRange")) then
			p35:_QueueLeave()
			p35._update_loop_active = false
			return
		end
	end
end
function v_u_10._HookLocalFighter(p_u_38) -- name: _HookLocalFighter
	-- upvalues: (copy) v_u_6
	p_u_38._local_fighter = v_u_6:WaitForLocalFighter()
	p_u_38._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function()
		-- upvalues: (copy) p_u_38
		p_u_38:_UpdateLoop()
	end)
	p_u_38._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
		-- upvalues: (copy) p_u_38
		p_u_38:_UpdateLoop()
	end)
	p_u_38:_UpdateLoop()
end
function v_u_10._Init(p_u_39) -- name: _Init
	p_u_39.ObjectAdded:Connect(function(p40)
		-- upvalues: (copy) p_u_39
		p40.LocalPlayerActivity:Connect(function()
			-- upvalues: (ref) p_u_39
			p_u_39.LocalPlayerActivity:Fire()
		end)
	end)
	task.defer(p_u_39._HookLocalFighter, p_u_39)
end
return v_u_10._new()