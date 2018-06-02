local M = {}

local _private = setmetatable({}, {__mode = "k"})

function M:add(entity)
	table.insert(_private[self].entities, entity)
end

function M:remove(entity)
	for i, value in ipairs(_private[self].entities) do
		if value == entity then
			table.remove(_private[self].entities, i)
			return
		end
	end
end

function M:get(id)
	for i, value in ipairs(_private[self].entities) do
		if value.id == id then
			return value
		end
	end
	return nil
end

function M:start()
	for i = 1, #_private[self].entities do
		_private[self].entities[i]:start()
	end
end

function M:on_input(action_id, action)
	for i = 1, #_private[self].entities do
		_private[self].entities[i]:on_input(action_id, action)
	end
end

function M.new()
	local instance = {
		add = M.add,
		remove = M.remove,
		get = M.get,
		start = M.start,
		on_input = M.on_input,
	}
	_private[instance] = {
		entities = {},
	}
	return instance
end

--[[
function M.create_entity_manager()
	local instance = {}
	instance._entities = {}
	instance.add = function(self, entity)
		table.insert(self._entities, entity)
	end
	instance.remove = function(self, entity)
		for i, value in ipairs(self._entities) do
			if value == entity then
				table.remove(self._entities, i)
				return
			end
		end
	end
	instance.get = function(self, id)
		for i, value in ipairs(self._entities) do
			if value.id == id then
				return value
			end
		end
		return nil
	end
	instance.start = function(self)
		for i = 1, #self._entities do
			self._entities[i]:start()
		end
	end
	instance.on_input = function(self, action_id, action)
		for i = 1, #self._entities do
			self._entities[i]:on_input(action_id, action)
		end
	end
	return instance
end
--]]

return M