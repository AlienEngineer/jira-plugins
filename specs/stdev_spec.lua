dofile("utils/estimation.lua")

describe("calculate standard deviation", function()
	it("of an empty array returns N/A", function()
		local array = {}
		local result = Calculate_stdev(array)
		assert.are.equal(result, "N/A")
	end)
	it("{1,1} array returns 0", function()
		local array = { 1, 1 }
		local result = Calculate_stdev(array)
		assert.are.equal(result, 0)
	end)
	it("{1,3.5} array returns 1.77", function()
		local array = { 1, 3.5 }
		local result = Calculate_stdev(array)
		assert.are.equal(result, 1.77)
	end)
	it("{1,8.33} array returns 5.19", function()
		local array = { 1, 8.33333 }
		local result = Calculate_stdev(array)
		assert.are.equal(result, 5.19)
	end)
end)

describe("pbi days stdev", function()
	local pbis = {
		{ customfield_10006 = 1, elapsed_minutes = 24 * 60 * 1 },
		{ customfield_10006 = 1, elapsed_minutes = 24 * 60 * 14 },
		{ customfield_10006 = 2, elapsed_minutes = 24 * 60 * 2 },
		{ customfield_10006 = 2, elapsed_minutes = 24 * 60 * 5 },
		{ customfield_10006 = 3, elapsed_minutes = 24 * 60 * 5 },
		{ customfield_10006 = 3, elapsed_minutes = 24 * 60 * 9 },
		{ customfield_10006 = 3, elapsed_minutes = 24 * 60 * 11 },
		{ customfield_10006 = 3, elapsed_minutes = 24 * 60 * 20 },
	}

	it("find the best fit for pbi 1", function()
		local best_sp = Find_best_story_points(pbis[1], pbis)

		assert.are.equal(best_sp, 1)
	end)
	it("find the best fit for pbi 2", function()
		local best_sp = Find_best_story_points(pbis[2], pbis)

		assert.are.equal(best_sp, 3)
	end)

	local estimation_accuracy = {
		[1] = "Good", -- 1 sp in 1 day
		[2] = "Failure", -- 1 sp in 14 days
		[3] = "Possible Over", -- 2 sp in 2 days
		[4] = "Good", -- 2 sp in 5 days
		[5] = "Possible Over", -- 3 sp in 5 days
		[6] = "Good", -- 3 sp in 9 days
		[7] = "Good", -- 3 sp in 11 days
		[8] = "Failure", -- 3 sp in 20 days
	}
	for key, value in pairs(estimation_accuracy) do
		it("estimation for pbi " .. key .. " is " .. value, function()
			local accuracy = Calculate_accuracy(pbis[key], pbis)
			assert.are.equal(value, accuracy)
		end)
	end
end)

describe("get closest story point", function()
	it("getting the closest value when array is empty returns N/A", function()
		local values = {}
		local days = 0
		local closest = Find_closest_story_point(days, values)

		assert.are.equal("N/A", closest)
	end)
	it("getting the closest value when array is { 1|1 } returns 1", function()
		local values = { { sp = 1, days = 1 } }
		local days = 0
		local closest = Find_closest_story_point(days, values)

		assert.are.equal(1, closest.sp)
		assert.are.equal(1, closest.days)
	end)
	it("getting the closest value when array is { 2|1 } returns 2", function()
		local values = { { sp = 2, days = 1 } }
		local days = 0
		local closest = Find_closest_story_point(days, values)

		assert.are.equal(2, closest.sp)
		assert.are.equal(1, closest.days)
	end)
	it("getting the closest value when array is { 2|1, 3|4 } and duration is 1 returns 2", function()
		local values = {
			{ sp = 2, days = 1 },
			{ sp = 3, days = 4 },
		}
		local days = 0
		local closest = Find_closest_story_point(days, values)

		assert.are.equal(2, closest.sp)
		assert.are.equal(1, closest.days)
	end)
end)
