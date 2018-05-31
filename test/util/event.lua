local event = require "ui_component.util.event"

return function()
	describe("event", function()
		before(function()
		end)

		after(function()
		end)

		test("it should be able to invoke", function()
			local is_called = false
			local func = function()
				is_called = true
			end
			local ev = event.new()
			ev:add(func)
			ev:invoke()
			assert(is_called)
		end)
		test("it should be able to remove", function()
			local is_called = false
			local func = function()
				is_called = true
			end
			local ev = event.new()
			ev:add(func)
			ev:remove(func)
			ev:invoke()
			assert(not is_called)
		end)
		test("it should be able to give value", function()
			local is_set = false
			local func = function(flg)
				is_set = flg
			end
			local ev = event.new()
			ev:add(func)
			ev:invoke(true)
			assert(is_set)
		end)
	end)
end