require('cbuslogic')

local api = require('user.api_common')
local M = {}

function M.read_trigger(group)
  local level = GetTriggerLevel(group)
  if level == nil or level == -1 then level = 0 end
  return level
end

function M.set()
  if not api.authorize() then return end

  local group = api.num('group', nil)
  local action = api.num('trigger_action', api.num('action_selector', api.num('level', api.num('value', nil))))

  if group == nil or action == nil then
    api.respond(false, 'missing parameters', '"required":"token,group,trigger_action"')
    return
  end

  group = api.clamp(group, 0, 255)
  action = api.clamp(action, 0, 255)

  SetTriggerLevel(group, action)

  api.respond(true, 'trigger set',
    '"group":' .. group ..
    ',"trigger_action":' .. action
  )
end

function M.get()
  if not api.authorize() then return end

  local group = api.num('group', nil)

  if group == nil then
    api.respond(false, 'missing group')
    return
  end

  group = api.clamp(group, 0, 255)

  api.respond(true, 'trigger value read',
    '"group":' .. group ..
    ',"trigger_action":' .. M.read_trigger(group)
  )
end

function M.pulse()
  if not api.authorize() then return end

  local group = api.num('group', nil)
  local action = api.num('trigger_action', api.num('action_selector', api.num('level', api.num('value', nil))))
  local reset = api.num('reset', 0)
  local delay = api.num('delay', 1)

  if group == nil or action == nil then
    api.respond(false, 'missing parameters', '"required":"token,group,trigger_action","optional":"reset,delay"')
    return
  end

  group = api.clamp(group, 0, 255)
  action = api.clamp(action, 0, 255)
  reset = api.clamp(reset, 0, 255)

  if delay < 0 then delay = 0 end

  SetTriggerLevel(group, action)

  if delay > 0 then
    os.sleep(delay)
  end

  SetTriggerLevel(group, reset)

  api.respond(true, 'trigger pulsed',
    '"group":' .. group ..
    ',"trigger_action":' .. action ..
    ',"reset":' .. reset ..
    ',"delay":' .. delay
  )
end

return M
