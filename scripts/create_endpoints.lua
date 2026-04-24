-- SHAC C-Bus REST API endpoint creation script
-- Run once after creating these user libraries:
--   api_common
--   api_light
--   api_trigger
--   api_router

io.writefile('/www/user/cbus_api.lp', [[<?
local router = require('user.api_router')
router.handle()
?>]])

io.writefile('/www/user/api_info.lp', [[<?
local api = require('user.api_common')
api.info()
?>]])

io.writefile('/www/user/light_set.lp', [[<?
local light = require('user.api_light')
light.set()
?>]])

io.writefile('/www/user/light_get.lp', [[<?
local light = require('user.api_light')
light.get()
?>]])

io.writefile('/www/user/light_on.lp', [[<?
local light = require('user.api_light')
light.on()
?>]])

io.writefile('/www/user/light_off.lp', [[<?
local light = require('user.api_light')
light.off()
?>]])

io.writefile('/www/user/light_toggle.lp', [[<?
local light = require('user.api_light')
light.toggle()
?>]])

io.writefile('/www/user/group_tag.lp', [[<?
local light = require('user.api_light')
light.tag()
?>]])

io.writefile('/www/user/trigger_set.lp', [[<?
local trigger = require('user.api_trigger')
trigger.set()
?>]])

io.writefile('/www/user/trigger_get.lp', [[<?
local trigger = require('user.api_trigger')
trigger.get()
?>]])

io.writefile('/www/user/trigger_pulse.lp', [[<?
local trigger = require('user.api_trigger')
trigger.pulse()
?>]])

script.disable(_SCRIPTNAME)
