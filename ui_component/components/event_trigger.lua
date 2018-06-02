local event = require "ui_component.util.event"
local property = require "ui_component.util.property"
local component = require "ui_component.ecs.component"

local M = {}

local _private = setmetatable({}, {__mode = "k"})

function M:start()
end

function M:on_input(action_id, action)
	local n = gui.get_node(self.id)
	local x = action.x
	local y = action.y
	if (not self.is_entered) and gui.pick_node(n, x, y) then
		self.is_entered = true
		self.pointer_enter:invoke(self)
	end
	if self.is_entered and action.pressed then
		self.is_clicked = true
		self.pointer_down:invoke(self)
	end
	if self.is_clicked and action.released then
		if gui.pick_node(n, x, y) then
			self.pointer_click:invoke(self)
		else
			self.pointer_up:invoke(self)
		end
		self.is_clicked = false
	end
	if self.is_entered and (not gui.pick_node(n, x, y)) then
		self.is_entered = false
		self.pointer_exit:invoke(self)
	end
end

function M:set_click_hash(click_hash)
	_private[instance].click_hash = click_hash
end

function M.new()
	local instance = component.new("event_trigger")
	instance.start = M.start
	instance.on_input = M.on_input
	instance.set_click_hash = M.set_click_hash

	_private[instance] = {
		pointer_enter = event.new(),
		pointer_exit = event.new(),
		pointer_down = event.new(),
		pointer_up = event.new(),
		pointer_click = event.new(),
		is_clicked = false,
		is_entered = false,
		click_hash = hash("touch")
	}

	property.define(instance, "pointer_enter", {
		get = function() return _private[instance].pointer_enter end
	})
	property.define(instance, "pointer_exit", {
		get = function() return _private[instance].pointer_exit end
	})
	property.define(instance, "pointer_down", {
		get = function() return _private[instance].pointer_down end
	})
	property.define(instance, "pointer_up", {
		get = function() return _private[instance].pointer_up end
	})
	property.define(instance, "pointer_click", {
		get = function() return _private[instance].pointer_click end
	})
	
	return instance
end

return M