-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v_u_1.Modules.Signal)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Controllers.FighterController)
local v_u_5 = {}
v_u_5.__index = v_u_5
function v_u_5._new() -- name: _new
	-- upvalues: (copy) v_u_5, (copy) v_u_3
	local v6 = v_u_5
	local v7 = setmetatable({}, v6)
	v7.Refreshed = v_u_3.new()
	v7.LeaderboardSerials = {}
	v7._leaderboard_refreshed_signals = {}
	v7._leaderboard_refresh_requests = {}
	v7._local_fighter = nil
	v7._next_request = 0
	v7:_Init()
	return v7
end
function v_u_5.GetLeaderboardRefreshedSignal(p8, p9) -- name: GetLeaderboardRefreshedSignal
	-- upvalues: (copy) v_u_3
	if not p8._leaderboard_refreshed_signals[p9] then
		p8._leaderboard_refreshed_signals[p9] = v_u_3.new()
	end
	return p8._leaderboard_refreshed_signals[p9]
end
function v_u_5.GetRankingByUserID(p10, p11, p12) -- name: GetRankingByUserID
	local v13 = p10.LeaderboardSerials[p11]
	if v13 then
		local v14 = tostring(p12)
		for v15, v16 in pairs(v13.Players) do
			if v14 == v16.key then
				return v15
			end
		end
	end
end
function v_u_5.GetRankingByValue(p17, p18, p19) -- name: GetRankingByValue
	local v20 = p17.LeaderboardSerials[p18]
	if v20 then
		for v21, v22 in pairs(v20.Players) do
			if v22.value <= p19 then
				return v21
			end
		end
	end
end
function v_u_5._FetchLeaderboards(p23) -- name: _FetchLeaderboards
	-- upvalues: (copy) v_u_1
	if #p23._leaderboard_refresh_requests == 0 then
		return
	elseif p23._local_fighter and (p23._local_fighter:Get("IsInDuel") or p23._local_fighter:Get("IsInShootingRange")) then
		return
	elseif tick() < p23._next_request then
		task.delay(p23._next_request - tick(), p23._FetchLeaderboards, p23)
	else
		p23._next_request = tick() + 2
		v_u_1.Remotes.Misc.RequestLeaderboards:FireServer(p23._leaderboard_refresh_requests)
		p23._leaderboard_refresh_requests = {}
	end
end
function v_u_5._HookFighter(p_u_24) -- name: _HookFighter
	-- upvalues: (copy) v_u_4
	p_u_24._local_fighter = v_u_4:WaitForLocalFighter()
	p_u_24._local_fighter:GetDataChangedSignal("IsInDuel"):Connect(function()
		-- upvalues: (copy) p_u_24
		p_u_24:_FetchLeaderboards()
	end)
	p_u_24._local_fighter:GetDataChangedSignal("IsInShootingRange"):Connect(function()
		-- upvalues: (copy) p_u_24
		p_u_24:_FetchLeaderboards()
	end)
	p_u_24:_FetchLeaderboards()
end
function v_u_5._Setup(_) -- name: _Setup
	-- upvalues: (copy) v_u_1
	v_u_1.Remotes.Misc.RequestLeaderboards:FireServer()
end
function v_u_5._Init(p_u_25) -- name: _Init
	-- upvalues: (copy) v_u_1
	p_u_25.Refreshed:Connect(function(p26)
		-- upvalues: (copy) p_u_25
		if p_u_25._leaderboard_refreshed_signals[p26] then
			p_u_25._leaderboard_refreshed_signals[p26]:Fire()
		end
	end)
	v_u_1.Remotes.Misc.LeaderboardRefreshed.OnClientEvent:Connect(function(p27)
		-- upvalues: (copy) p_u_25
		if not table.find(p_u_25._leaderboard_refresh_requests, p27) then
			local v28 = p_u_25._leaderboard_refresh_requests
			table.insert(v28, p27)
		end
		p_u_25:_FetchLeaderboards()
	end)
	v_u_1.Remotes.Misc.UpdateLeaderboard.OnClientEvent:Connect(function(p29)
		-- upvalues: (copy) p_u_25
		p_u_25.LeaderboardSerials[p29.Name] = p29
		p_u_25.Refreshed:Fire(p29.Name)
	end)
	p_u_25:_Setup()
	task.defer(p_u_25._HookFighter, p_u_25)
end
return v_u_5._new()