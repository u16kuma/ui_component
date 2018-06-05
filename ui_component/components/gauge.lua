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
	size.x = (max_size.x*(self.value-self.min_value))/(self.max_value-self.min_value)
	gui.set_size(gauge_fill_node, size)
end

function M.new(gauge_fill_id, gauge_fill_area_id, value, min_value, max_value)
	local instance = component.new("gauge")
	instance.start = M.start
	instance.update_view = M.update_view
	
	_private[instance] = {
		gauge_fill_id = gauge_fill_id,
		gauge_fill_node = gui.get_node(gauge_fill_id),
		gauge_fill_area_id = gauge_fill_area_id,
		gauge_fill_area_node = gui.get_node(gauge_fill_area_id),
		value = value,
		min_value = min_value,
		max_value = max_value,
		on_value_changed = event.new(),
	}
	
	property.define(instance, "value", {
		get = function() return _private[instance].value end,
		set = function(v)
			v = math.min(_private[instance].max_value, v)
			v = math.max(_private[instance].min_value, v)
			if _private[instance].value ~= v then
				_private[instance].on_value_changed:invoke(v)
				_private[instance].value = v
				instance:update_view()
			end
		end
	})
	property.define(instance, "max_value", {
		get = function() return _private[instance].max_value end,
		set = function(v)
			_private[instance].max_value = v
			--valueが最大値を超えてしまわないように
			_private[instance].value = math.min(_private[instance].value, _private[instance].max_value)
			instance:update_view()
		end
	})
	property.define(instance, "min_value", {
		get = function() return _private[instance].min_value end,
		set = function(v)
			_private[instance].min_value = v
			--valueが最低値以下にならないように
			_private[instance].value = math.max(_private[instance].value, _private[instance].min_value)
			instance:update_view()
		end
	})
	property.define(instance, "on_value_changed", {
		get = function() return _private[instance].on_value_changed end,
	})
	return instance
end

return M