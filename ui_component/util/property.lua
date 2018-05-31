local M = {}

local _private = setmetatable({}, {__mode = "k"})

local function define__index(table, key)
	if _private[table][key] then
		if _private[table][key].get then
			return _private[table][key].get()
		else
			error("cannot get property : "..key)
		end
	end
	return nil
end

local function define__newindex(table, key, value)
	if _private[table][key] then
		if _private[table][key].set then
			return _private[table][key].set(value)
		else
			error("cannot set property : "..key)
		end
	else
		rawset(table, key, value)
	end
end

-- プロパティを定義する
-- @param instance table
-- @param key string
-- @param accessor table
function M.define(instance, key, accessor)
	if _private[instance] == nil then
		_private[instance] = {}
		setmetatable(instance, {
			__index = define__index,
			__newindex = define__newindex
		})
	end
	_private[instance][key] = accessor
end

return M