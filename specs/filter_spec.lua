dofile("utils/estimation.lua")

describe("filtering", function()
	it("filtering an empty list returns empty", function()
		local array = {}
		local result = Filter(array, function() end)
		assert.are.same({}, result)
	end)
	it("filtering a list with a nil predicate returns input without filtering", function()
		local array = { 1, 2, 3 }
		local result = Filter(array)
		assert.are.same({ 1, 2, 3 }, result)
	end)
	it("filtering a list of numbers by even numbers returns only odd numbers", function()
		local array = { 1, 2, 3 }
		local result = Filter(array, function(value)
			return value % 2 == 0
		end)
		assert.are.same({ 2 }, result)
	end)
	it("filtering a list of numbers by odd numbers returns only odd numbers", function()
		local array = { 1, 2, 3 }
		local result = Filter(array, function(value)
			return value % 2 ~= 0
		end)
		assert.are.same({ 1, 3 }, result)
	end)
end)
