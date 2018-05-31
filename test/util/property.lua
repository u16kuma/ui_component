local property = require "ui_component.util.property"

return function()
	describe("property", function()
		before(function()
		end)

		after(function()
		end)

		test("it should be able to get value", function()
			local instance = {}
			local _value = 100
			property.define(instance, "value", {
				get = function()
					return _value
				end
			})
			assert(instance.value == 100)
		end)
		test("it should be able to set value", function()
			local instance = {}
			local _value = 100
			property.define(instance, "value", {
				get = function()
					return _value
				end,
				set = function(v)
					_value = v
				end
			})
			instance.value = instance.value + 1
			assert(instance.value == 101)
		end)
	end)
end