local api = require('user.api_common')
local light = require('user.api_light')
local trigger = require('user.api_trigger')

local M = {}

function M.handle()
  local action = api.q('action', '')

  if action == 'info' then
    return api.info()
  elseif action == 'light_set' then
    return light.set()
  elseif action == 'light_on' then
    return light.on()
  elseif action == 'light_off' then
    return light.off()
  elseif action == 'light_toggle' then
    return light.toggle()
  elseif action == 'light_get' then
    return light.get()
  elseif action == 'group_tag' then
    return light.tag()
  elseif action == 'trigger_set' then
    return trigger.set()
  elseif action == 'trigger_get' then
    return trigger.get()
  elseif action == 'trigger_pulse' then
    return trigger.pulse()
  end

  if not api.authorize() then return end

  api.respond(false, 'unknown or missing action',
    '"valid_actions":"info,light_set,light_on,light_off,light_toggle,light_get,group_tag,trigger_set,trigger_get,trigger_pulse"'
  )
end

return M
