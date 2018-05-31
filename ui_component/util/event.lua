local M = {}

local _private = setmetatable({}, {__mode = "k"})

-- イベントの生成
-- @return イベントのインスタンス
function M.new()
	local instance = {}
	_private[instance] = {
		list = {}
	}
	return setmetatable(instance, { __index = M })
end

-- 購読者を追加
-- @param func 購読者
function M:add(func)
	local _list = _private[self].list
	table.insert(_list, func)
end

-- 購読者を除外
-- @param func 購読者
function M:remove(func)
	local _list = _private[self].list
	for i, value in ipairs(_list) do
		if value == func then
			table.remove(_list, i)
			return
		end
	end
end

-- イベントの発火
function M:invoke(...)
	local _list = _private[self].list
	for i = 1, #_list do
		_list[i](...)
	end
end

return M