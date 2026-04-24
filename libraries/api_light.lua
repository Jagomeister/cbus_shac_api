require('cbuslogic')

local api = require('user.api_common')
local M = {}

function M.group_tag(net, app, group)
  return GetCBusGroupTag(net, app, group) or ''
end

function M.read_level(net, app, group)
  local level = GetCBusLevel(net, app, group)
  if level == nil or level == -1 then level = 0 end
  return level
end

function M.read_state(net, app, group)
  return GetCBusState(net, app, group) and true or false
end

function M.set()
  if not api.authorize() then return end

  local net = api.num('net', api.DEFAULT_NET)
  local app = api.num('app', api.DEFAULT_APP)
  local group = api.num('group', nil)
  local level = api.num('level', nil)
  local ramp = api.num('ramp', 0)

  if group == nil or level == nil then
    api.respond(false, 'missing parameters', '"required":"token,group,level","optional":"net,app,ramp"')
    return
  end

  level = api.clamp(level, 0, 255)
  if ramp < 0 then ramp = 0 end

  SetCBusLevel(net, app, group, level, ramp)

  api.respond(true, 'light level set',
    '"net":' .. net ..
    ',"app":' .. app ..
    ',"group":' .. group ..
    ',"level":' .. level ..
    ',"percent":' .. api.level_to_percent(level) ..
    ',"ramp":' .. ramp ..
    ',"state":' .. api.bool_to_json(level > 0) ..
    ',"tag":"' .. api.json_escape(M.group_tag(net, app, group)) .. '"'
  )
end

function M.on()
  if not api.authorize() then return end

  local net = api.num('net', api.DEFAULT_NET)
  local app = api.num('app', api.DEFAULT_APP)
  local group = api.num('group', nil)
  local level = api.num('level', 255)
  local ramp = api.num('ramp', 0)

  if group == nil then
    api.respond(false, 'missing group')
    return
  end

  level = api.clamp(level, 1, 255)
  if ramp < 0 then ramp = 0 end

  SetCBusLevel(net, app, group, level, ramp)

  api.respond(true, 'light on',
    '"net":' .. net ..
    ',"app":' .. app ..
    ',"group":' .. group ..
    ',"level":' .. level ..
    ',"percent":' .. api.level_to_percent(level) ..
    ',"ramp":' .. ramp ..
    ',"state":true' ..
    ',"tag":"' .. api.json_escape(M.group_tag(net, app, group)) .. '"'
  )
end

function M.off()
  if not api.authorize() then return end

  local net = api.num('net', api.DEFAULT_NET)
  local app = api.num('app', api.DEFAULT_APP)
  local group = api.num('group', nil)
  local ramp = api.num('ramp', 0)

  if group == nil then
    api.respond(false, 'missing group')
    return
  end

  if ramp < 0 then ramp = 0 end

  SetCBusLevel(net, app, group, 0, ramp)

  api.respond(true, 'light off',
    '"net":' .. net ..
    ',"app":' .. app ..
    ',"group":' .. group ..
    ',"level":0' ..
    ',"percent":0' ..
    ',"ramp":' .. ramp ..
    ',"state":false' ..
    ',"tag":"' .. api.json_escape(M.group_tag(net, app, group)) .. '"'
  )
end

function M.toggle()
  if not api.authorize() then return end

  local net = api.num('net', api.DEFAULT_NET)
  local app = api.num('app', api.DEFAULT_APP)
  local group = api.num('group', nil)
  local onlevel = api.num('onlevel', 255)
  local ramp = api.num('ramp', 0)

  if group == nil then
    api.respond(false, 'missing group')
    return
  end

  onlevel = api.clamp(onlevel, 1, 255)
  if ramp < 0 then ramp = 0 end

  local current = M.read_level(net, app, group)
  local target = 0

  if current <= 0 then
    target = onlevel
  end

  SetCBusLevel(net, app, group, target, ramp)

  api.respond(true, 'light toggled',
    '"net":' .. net ..
    ',"app":' .. app ..
    ',"group":' .. group ..
    ',"previous_level":' .. current ..
    ',"level":' .. target ..
    ',"percent":' .. api.level_to_percent(target) ..
    ',"ramp":' .. ramp ..
    ',"state":' .. api.bool_to_json(target > 0) ..
    ',"tag":"' .. api.json_escape(M.group_tag(net, app, group)) .. '"'
  )
end

function M.get()
  if not api.authorize() then return end

  local net = api.num('net', api.DEFAULT_NET)
  local app = api.num('app', api.DEFAULT_APP)
  local group = api.num('group', nil)

  if group == nil then
    api.respond(false, 'missing group')
    return
  end

  local level = M.read_level(net, app, group)
  local state = M.read_state(net, app, group)

  api.respond(true, 'light value read',
    '"net":' .. net ..
    ',"app":' .. app ..
    ',"group":' .. group ..
    ',"level":' .. level ..
    ',"percent":' .. api.level_to_percent(level) ..
    ',"state":' .. api.bool_to_json(state) ..
    ',"tag":"' .. api.json_escape(M.group_tag(net, app, group)) .. '"'
  )
end

function M.tag()
  if not api.authorize() then return end

  local net = api.num('net', api.DEFAULT_NET)
  local app = api.num('app', api.DEFAULT_APP)
  local group = api.num('group', nil)

  if group == nil then
    api.respond(false, 'missing group')
    return
  end

  api.respond(true, 'group tag read',
    '"net":' .. net ..
    ',"app":' .. app ..
    ',"group":' .. group ..
    ',"tag":"' .. api.json_escape(M.group_tag(net, app, group)) .. '"'
  )
end

return M
