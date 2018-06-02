local property = require "ui_component.util.property"

local M = {}

local _private = setmetatable({}, {__mode = "k"})

function M:init(id, entity)
	_private[self].id = id
	_private[self].entity = entity
end

function M:start()
end

function M:on_input(action_id, action)
end

function M.new(component_id)
	local instance = {
		init = M.init,
		start = M.start,
		on_input = M.on_input,
	}
	_private[instance] = {
		component_id = component_id,
	}
	property.define(instance, "component_id", {
		get = function() return _private[instance].component_id end
	})
	property.define(instance, "id", {
		get = function() return _private[instance].id end 
	})
	property.define(instance, "entity", {
		get = function() return _private[instance].entity end
	})
	return instance
end

return M