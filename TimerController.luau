-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

local v_u_1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v_u_1.Modules.Utility)
local v_u_3 = require(v_u_1.Modules.Signal)
local v_u_4 = {}
v_u_4.__index = v_u_4
function v_u_4._new() -- name: _new
	-- upvalues: (copy) v_u_4, (copy) v_u_3
	local v5 = v_u_4
	local v6 = setmetatable({}, v5)
	v6.TimerUpdated = v_u_3.new()
	v6._finish_times = {}
	v6._step_callbacks = {}
	v6:_Init()
	return v6
end
function v_u_4.GetTimeRemaining(p7, p8) -- name: GetTimeRemaining
	if not p7._finish_times[p8] then
		return -1
	end
	local v9 = p7._finish_times[p8] - tick()
	local v10 = math.ceil(v9)
	return math.max(0, v10)
end
function v_u_4.GetTimeRemainingFormatted(p11, p12) -- name: GetTimeRemainingFormatted
	-- upvalues: (copy) v_u_2
	local v13 = p11:GetTimeRemaining(p12)
	return v13 == -1 and "\226\128\162 \226\128\162 \226\128\162" or v_u_2:TimeFormat2(v13)
end
function v_u_4.SetTimeRemaining(p14, p15, p16) -- name: SetTimeRemaining
	p14._finish_times[p15] = tick() + p16
	p14.TimerUpdated:Fire(p15)
end
function v_u_4.OnStep(p17, p18, p19, p20) -- name: OnStep
	p17._step_callbacks[p18] = p19 and p20 and { p19, p20 } or nil
	p17:_Step(p18)
end
function v_u_4._Step(p21, p22) -- name: _Step
	local v23 = p21._step_callbacks[p22]
	if v23 then
		local v24, v25 = pcall(v23[2], p21:GetTimeRemaining(v23[1]), p21:GetTimeRemainingFormatted(v23[1]))
		if not v24 then
			warn("ON STEP CALLBACK ERRORED:", v25)
		end
	end
end
function v_u_4._StepLoop(p26) -- name: _StepLoop
	while true do
		for v27 in pairs(p26._step_callbacks) do
			p26:_Step(v27)
		end
		wait(1)
	end
end
function v_u_4._FetchTimers(p28) -- name: _FetchTimers
	-- upvalues: (copy) v_u_1
	p28:SetTimeRemaining("TaskRefresh", v_u_1.Remotes.Misc.RequestTaskRefreshTimeRemaining:InvokeServer())
	p28:SetTimeRemaining("AdventCalendar", v_u_1.Remotes.Misc.RequestAdventCalendarTimeRemaining:InvokeServer())
end
function v_u_4._Init(p_u_29) -- name: _Init
	-- upvalues: (copy) v_u_1
	v_u_1.Remotes.Misc.UpdateTaskRefreshTimeRemaining.OnClientEvent:Connect(function(p30)
		-- upvalues: (copy) p_u_29
		p_u_29:SetTimeRemaining("TaskRefresh", p30)
	end)
	v_u_1.Remotes.Misc.UpdateAdventCalendarTimeRemaining.OnClientEvent:Connect(function(p31)
		-- upvalues: (copy) p_u_29
		p_u_29:SetTimeRemaining("AdventCalendar", p31)
	end)
	task.spawn(p_u_29._StepLoop, p_u_29)
	task.spawn(p_u_29._FetchTimers, p_u_29)
end
return v_u_4._new()