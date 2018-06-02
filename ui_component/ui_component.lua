local event = require "ui_component.util.event"
local property = require "ui_component.util.property"
local component = require "ui_component.ecs.component"
local entity = require "ui_component.ecs.entity"

local M = {}

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

function M.create_toggle_group()
	local instance = component.new("toggle_group")
	local _allow_switch_off = false
	property.define(instance, "allow_switch_off", {
		get = function() return _allow_switch_off end,
		set = function(v) _allow_switch_off = v end
	})
	local _toggles = {}
	local _is_executed = false
	local function on_value_changed(toggle)
		if _is_executed then
			return
		end
		_is_executed = true
		for i, value in ipairs(_toggles) do
			if value.is_on then
				if value ~= toggle then
					value.is_on = false
				end
			end
		end
		_is_executed = false
	end
	instance.register_toggle = function(self, toggle)
		table.insert(_toggles, toggle)
		toggle.on_value_changed:add(on_value_changed)
		toggle.can_change = function(toggle)
			if _is_executed then
				return true
			end
			if toggle.is_on then
				return false
			end
			return true
		end
	end
	instance.unregister_toggle = function(self, toggle)
		for i, value in ipairs(_toggles) do
			if value == toggle then
				toggle.on_value_changed:remove(on_value_changed)
				toggle.can_change = nil
				table.remove(_toggles, i)
				return
			end
		end
	end
	instance.active_toggles = function(self)
		local result = {}
		for i, value in ipairs(_toggles) do
			if value.is_on then
				table.insert(result, value)
			end
		end
		return result
	end
	instance.set_all_toggles_off = function(self)
		for i, value in ipairs(_toggles) do
			value.is_on = false
		end
	end
	instance.start = function(self)
		if not self.allow_switch_off then
			if #_toggles > 0 then
				_toggles[1].is_on = true
			end
		end
	end
	instance.on_input = function(self, action_id, action)
	end
	return instance
end

function M.create_slider()
end

function M.create_scroll()
end

return M