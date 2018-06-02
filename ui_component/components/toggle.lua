local event = require "ui_component.util.event"
local property = require "ui_component.util.property"
local component = require "ui_component.ecs.component"

local M = {}

local _private = setmetatable({}, {__mode = "k"})

function M:start()
	local trigger = self.entity:get_component("event_trigger")
	local button = self.entity:get_component("button")
	trigger.pointer_click:add(function(data)
		if button.interactive then
			self.is_on = not self.is_on
		end
	end)
end

function M:on_input(action_id, action)
end

function M:set_group_info(group, can_change_func)
	_private[self].can_change = can_change_func
	_private[self].group = group
end

function M.new()
	local instance = component.new("toggle")
	instance.start = M.start
	instance.on_input = M.on_input
	instance.set_group_info = M.set_group_info

	instance.can_change = nil
	instance.on_value_changed = event.new()
	instance.group = nil
	
	_private[instance] = {
		is_on = false,
		can_change = nil,
		on_value_changed = event.new(),
	}

	property.define(instance, "is_on", {
		get = function() return _private[instance].is_on end,
		set = function(v)
			if v ~= _private[instance].is_on then
				local can_change = _private[instance].can_change
				if (can_change and can_change(instance)) or (not can_change) then
					_private[instance].is_on = v
					instance.on_value_changed:invoke(instance)
				end
			end
		end
	})
	property.define(instance, "on_value_changed", {
		get = function() return _private[instance].on_value_changed end
	})

	return instance
end

--[[

function M.create_toggle()
	local instance = component.new("toggle")
	local _is_on = false
	property.define(instance, "is_on", {
		get = function()
			return _is_on
		end,
		set = function(v)
			if v ~= _is_on then
				if (instance.can_change and instance.can_change(instance)) or (not instance.can_change) then
					_is_on = v
					instance.on_value_changed:invoke(instance)
				end
			end
		end
	})
	instance.can_change = nil
	instance.on_value_changed = event.new()
	instance.group = nil
	instance.start = function(self)
		local trigger = self.entity:get_component("event_trigger")
		local button = self.entity:get_component("button")
		trigger.pointer_click:add(function(data)
			if button.interactive then
				self.is_on = not self.is_on
			end
		end)
	end
	instance.on_input = function(self, action_id, action)
	end
	return instance
end
--]]

return M