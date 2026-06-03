local function Frames()
  print("Starting FPS monitor")

  local f = CreateFrame("Frame")
  local drop = false
  local times = {}
  local lastTime = 0
  f:SetScript("OnUpdate", function(_, elapsed)
    local time = debugprofilestop()
    if not drop then
      table.insert(times, (time - lastTime))
    end
    lastTime = time
    drop = false
  end)

  times = table.create(300*30)
  drop = true

  C_Timer.NewTicker(30, function()
    drop = true
    table.sort(times)

    local sum = 0
    for _, i in ipairs(times) do
      sum = sum + i
    end

    print("FPS: ", #times * 1000 / sum)
    print("1% low: ", 1000 / times[math.ceil(#times * 0.99)], times[math.ceil(#times * 0.99)])
    print("5% low: ", 1000 / times[math.ceil(#times * 0.95)], times[math.ceil(#times * 0.95)])
    print("10% low: ", 1000 / times[math.ceil(#times * 0.90)], times[math.ceil(#times * 0.90)])
    print("20% low: ", 1000 / times[math.ceil(#times * 0.80)], times[math.ceil(#times * 0.80)])
    print("50% median: ", 1000 / times[math.ceil(#times / 2)])
    print("20% high: ", 1000 / times[math.ceil(#times * 0.20)], times[math.ceil(#times * 0.20)])
    print("10% high: ", 1000 / times[math.ceil(#times * 0.10)], times[math.ceil(#times * 0.10)])
    print("5% high: ", 1000 / times[math.ceil(#times * 0.05)], times[math.ceil(#times * 0.05)])
    print("1% high: ", 1000 / times[math.ceil(#times * 0.01)], times[math.ceil(#times * 0.01)])
    print("total elapsed", sum / 1000)

    table.wipe(times)
  end)
end

local function DeepEvents(addon)
  print("Starting events monitoring for \"" .. addon .. "\"")
  local events = {}
  local f = CreateFrame("Frame")
  f:RegisterAllEvents()
  f:SetScript("OnEvent", function(_, e)
    events[e] = (events[e] or 0) + 1
  end)
  local skip = false
  f:SetScript("OnUpdate", function()
    if C_AddOnProfiler.GetAddOnMetric(addon, 3) > 0.2 then
      DevTools_Dump(events)
      print("metric", C_AddOnProfiler.GetAddOnMetric(addon, 3))
      events = {}
      skip = true
    else
      events = {}
      skip = false
    end
  end)
end

-- increment the index for each slash command
SLASH_FRAMERATES1 = "/framerates"
SLASH_DEEPEVENTS1 = "/deepevents"

-- define the corresponding slash command handler
SlashCmdList.FRAMERATES = Frames
SlashCmdList.DEEPEVENTS = DeepEvents
