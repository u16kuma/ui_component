local property = require "ui_component.util.property"
local component = require "ui_component.ecs.component"

local M = {}

local _private = setmetatable({}, {__mode = "k"})

function M:start()
	if not self.allow_switch_off then
		if #_private[self].toggles > 0 then
			_private[self].toggles[1].is_on = true
		end
	end
end

function M:on_input(action_id, action)
end

function on_value_changed(toggle)
	local self = toggle.group
	if _private[self].is_executed then
		return
	end
	_private[self].is_executed = true
	for i, value in ipairs(_private[self].toggles) do
		if value.is_on then
			if value ~= toggle then
				value.is_on = false
			end
		end
	end
	_private[self].is_executed = false
end

function M:register_toggle(toggle)
	table.insert(_private[self].toggles, toggle)
	toggle.on_value_changed:add(on_value_changed)
	toggle:set_group_info(self, function(toggle)
		if _private[self].is_executed then
			return true
		end
		if toggle.is_on then
			return false
		end
		return true
	end)
end

function M:unregister_toggle(toggle)
	for i, value in ipairs(_private[self].toggles) do
		if value == toggle then
			toggle.on_value_changed:remove(on_value_changed)
			toggle.can_change = nil
			table.remove(_private[self].toggles, i)
			return
		end
	end
end

function M:active_toggles(toggle)
	local result = {}
	for i, value in ipairs(_private[self].toggles) do
		if value.is_on then
			table.insert(result, value)
		end
	end
	return result
end

function M:set_all_toggles_off()
	for i, value in ipairs(_private[self].toggles) do
		value.is_on = false
	end
end
	
function M.new()
	local instance = component.new("toggle_group")
	instance.start = M.start
	instance.on_input = M.on_input
	instance.register_toggle = M.register_toggle
	instance.unregister_toggle = M.unregister_toggle
	instance.active_toggles = M.active_toggles
	instance.set_all_toggles_off = M.set_all_toggles_off

	_private[instance] = {
		allow_switch_off = false,
		toggles = {},
		is_executed = false,
	}

	property.define(instance, "allow_switch_off", {
		get = function() return _private[instance].allow_switch_off end,
		set = function(v) _private[instance].allow_switch_off = v end
	})
	
	return instance
end

return M