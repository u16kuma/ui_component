local event = require "ui_component.util.event"
local property = require "ui_component.util.property"
local component = require "ui_component.ecs.component"

local M = {}

local _private = setmetatable({}, {__mode = "k"})

function M:start()
	self:update_view()
end

-- ゲージの見た目を変える
function M:update_view()
	local gauge_fill_node = _private[self].gauge_fill_node
	local gauge_fill_area_node = _private[self].gauge_fill_area_node
	local max_size = gui.get_size(gauge_fill_area_node)
	local size = gui.get_size(gauge_fill_node)
	size.x = (max_size.x*self.value)/self.max_value
	gui.set_size(gauge_fill_node, size)
end

function M.new(gauge_fill_id, gauge_fill_area_id, value, max_value)
	local instance = component.new("gauge")
	instance.start = M.start
	instance.update_view = M.update_view
	
	_private[instance] = {
		gauge_fill_id = gauge_fill_id,
		gauge_fill_node = gui.get_node(gauge_fill_id),
		gauge_fill_area_id = gauge_fill_area_id,
		gauge_fill_area_node = gui.get_node(gauge_fill_area_id),
		value = value,
		max_value = max_value,
		on_value_changed = event.new(),
	}
	
	property.define(instance, "value", {
		get = function() return _private[instance].value end,
		set = function(v)
			if _private[instance].value ~= v then
				_private[instance].on_value_changed:invoke(v)
				_private[instance].value = v
				instance:update_view()
			end
		end
	})
	property.define(instance, "max_value", {
		get = function() return _private[instance].max_value end,
		set = function(v) _private[instance].max_value = v end
	})
	property.define(instance, "on_value_changed", {
		get = function() return _private[instance].on_value_changed end,
	})
	return instance
end

return M