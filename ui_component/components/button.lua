local event = require "ui_component.util.event"
local property = require "ui_component.util.property"
local component = require "ui_component.ecs.component"

local M = {}

local _private = setmetatable({}, {__mode = "k"})

function M:start()
	local trigger = self.entity:get_component("event_trigger")
	trigger.pointer_click:add(function(data)
		if _private[self].interactive then
			_private[self].on_click:invoke()
		end
	end)
end

function M:on_input(action_id, action)
end

function M.new()
	local instance = component.new("button")
	instance.start = M.start
	instance.on_input = M.on_input

	_private[instance] = {
		on_click = event.new(),
		interactive = true,
	}

	property.define(instance, "interactive", {
		get = function() return _private[instance].interactive end,
		set = function(v) _private[instance].interactive = v end
	})
	property.define(instance, "on_click", {
		get = function() return _private[instance].on_click end
	})

	return instance
end

--[[
function M.create_button()
	local instance = component.new("button")
	local _interactive = true
	property.define(instance, "interactive", {
		get = function()
			return _interactive
		end,
		set = function(v)
			_interactive = v
		end
	})
	instance.on_clicked = event.new()
	instance.start = function(self)
		local trigger = self.entity:get_component("event_trigger")
		trigger.pointer_click:add(function(data)
			if self.interactive then
				self.on_clicked:invoke()
			end
		end)
	end
	return instance
end
--]]

return M