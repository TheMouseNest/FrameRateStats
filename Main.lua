local f = CreateFrame("Frame")
local drop = false
local times = {}
f:SetScript("OnUpdate", function(_, elapsed)
  if not drop then
    table.insert(times, elapsed)
  end
  drop = false
end)

C_Timer.NewTimer(5, function()
  times = table.create(300*30)
  print("startup")
  drop = true

  C_Timer.NewTicker(30, function()
    drop = true
    table.sort(times)

    local sum = 0
    for _, i in ipairs(times) do
      sum = sum + i
    end

    print("FPS: ", #times / sum)
    print("1% low: ", 1 / times[math.ceil(#times * 0.99)], times[math.ceil(#times * 0.99)])
    print("5% low: ", 1 / times[math.ceil(#times * 0.95)], times[math.ceil(#times * 0.95)])
    print("10% low: ", 1 / times[math.ceil(#times * 0.90)], times[math.ceil(#times * 0.90)])
    print("20% low: ", 1 / times[math.ceil(#times * 0.80)], times[math.ceil(#times * 0.80)])
    print("50% median: ", 1 / times[math.ceil(#times / 2)])
    print("20% high: ", 1 / times[math.ceil(#times * 0.20)], times[math.ceil(#times * 0.20)])
    print("10% high: ", 1 / times[math.ceil(#times * 0.10)], times[math.ceil(#times * 0.10)])
    print("5% high: ", 1 / times[math.ceil(#times * 0.05)], times[math.ceil(#times * 0.05)])
    print("1% high: ", 1 / times[math.ceil(#times * 0.01)], times[math.ceil(#times * 0.01)])
    print("total elapsed", sum)

    table.wipe(times)
  end)
end)
