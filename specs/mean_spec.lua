dofile("utils/estimation.lua")

describe("calculate mean", function()
	it("an empty array returns mean N/A", function()
		local array = {}
		local result = Calculate_mean(array)
		assert.are.equals(result, "N/A")
	end)
	it("with {1,2,3} array returns 2", function()
		local array = { 1, 2, 3 }
		local result = Calculate_mean(array)
		assert.are.equals(result, 2)
	end)
end)
