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

return M