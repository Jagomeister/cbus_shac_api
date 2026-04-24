require('socket.url')

local M = {}

M.DEFAULT_NET = 0
M.DEFAULT_APP = 56
M.API_TOKEN = 'changeme'
M.VERSION = '1.0.0'

function M.q(name, default)
  local v = getvar(name)
  if v == nil or v == '' then return default end
  return socket.url.unescape(v)
end

function M.num(name, default)
  local v = M.q(name, nil)
  if v == nil then return default end
  return tonumber(v)
end

function M.clamp(v, minv, maxv)
  if v == nil then return nil end
  if v < minv then v = minv end
  if v > maxv then v = maxv end
  return v
end

function M.bool_to_json(v)
  if v then return 'true' end
  return 'false'
end

function M.level_to_percent(level)
  level = tonumber(level) or 0
  return math.floor((level / 255) * 100 + 0.5)
end

function M.json_escape(s)
  s = tostring(s or '')
  s = s:gsub('\\', '\\\\')
  s = s:gsub('"', '\\"')
  s = s:gsub('\r', '\\r')
  s = s:gsub('\n', '\\n')
  return s
end

function M.respond(ok, message, extra_json)
  print('Content-Type: application/json')
  print('')

  local body = '{"ok":' .. M.bool_to_json(ok) ..
    ',"message":"' .. M.json_escape(message) .. '"'

  if extra_json and extra_json ~= '' then
    body = body .. ',' .. extra_json
  end

  print(body .. '}')
end

function M.authorize()
  local token = M.q('token', '')
  if token ~= M.API_TOKEN then
    M.respond(false, 'unauthorized')
    return false
  end
  return true
end

function M.info()
  if not M.authorize() then return end

  M.respond(true, 'SHAC C-Bus API',
    '"version":"' .. M.json_escape(M.VERSION) .. '",' ..
    '"defaults":{"net":' .. M.DEFAULT_NET .. ',"app":' .. M.DEFAULT_APP .. '},' ..
    '"actions":[' ..
      '"info",' ..
      '"light_set",' ..
      '"light_on",' ..
      '"light_off",' ..
      '"light_toggle",' ..
      '"light_get",' ..
      '"group_tag",' ..
      '"trigger_set",' ..
      '"trigger_get",' ..
      '"trigger_pulse"' ..
    '],' ..
    '"endpoints":[' ..
      '"/user/cbus_api.lp?action=info",' ..
      '"/user/api_info.lp",' ..
      '"/user/light_set.lp",' ..
      '"/user/light_get.lp",' ..
      '"/user/light_on.lp",' ..
      '"/user/light_off.lp",' ..
      '"/user/light_toggle.lp",' ..
      '"/user/group_tag.lp",' ..
      '"/user/trigger_set.lp",' ..
      '"/user/trigger_get.lp",' ..
      '"/user/trigger_pulse.lp"' ..
    ']'
  )
end

return M
