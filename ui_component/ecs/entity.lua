local property = require "ui_component.util.property"

local M = {}

local _private = setmetatable({}, {__mode = "k"})

function M:start()
	for i = 1, #_private[self].components do
		_private[self].components[i]:start()
	end
end

function M:on_input(action_id, action)
	for i = 1, #_private[self].components do
		_private[self].components[i]:on_input(action_id, action)
	end
end

function M:get_component(component_id)
	for i, value in ipairs(_private[self].components) do
		if value.component_id == component_id then
			return value
		end
	end
	return nil
end

function M.new(id, components)
	local instance = {
		start = M.start,
		on_input = M.on_input,
		get_component = M.get_component,
	}
	_private[instance] = {
		id = id,
		components = components,
	}
	property.define(instance, "id", {
		get = function() return _private[instance].id end
	})
	for i = 1, #_private[instance].components do
		_private[instance].components[i]:init(id, instance)
	end
	return instance
end

return M