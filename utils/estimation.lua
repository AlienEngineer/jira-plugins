function Filter(array, filterIterator)
	if filterIterator == nil then
		return array
	end
	local result = {}
	for key, value in pairs(array) do
		if filterIterator(value, key) then
			table.insert(result, value)
		end
	end
	return result
end

function Calculate_mean(values)
	if #values == 0 then
		return "N/A"
	end
	local sum = 0
	for _, v in ipairs(values) do
		sum = sum + v
	end
	return sum / #values
end

function Round(value, n)
	local mult = 10 ^ (n or 0)
	return math.floor(value * mult + 0.5) / mult
end

function Calculate_stdev(values)
	local mean = Calculate_mean(values)
	if mean == "N/A" then
		return "N/A"
	end

	local sum_of_squares = 0
	local count = #values

	for _, value in ipairs(values) do
		sum_of_squares = sum_of_squares + (value - mean) ^ 2
	end

	return count > 1 and Round(math.sqrt(sum_of_squares / (count - 1)), 2) or 0
end

function Get_story_points(pbi)
	-- dumb way do mimic the jira object
	if jira == nil then
		return pbi["customfield_10006"]
	end
	return jira.json.get(pbi.raw, "customfield_10006") or "N/A"
end

function Get_pbis_by_story_points(pbis, pbi)
	local points = Get_story_points(pbi)
	return Filter(pbis, function(pbi_iter, key, index)
		return pbi.key ~= pbi_iter.key and Get_story_points(pbi_iter) == points
	end)
end

function Calculate_average_days(pbis)
	local total_points = 0
	local count = 0
	for _, pbi in ipairs(pbis) do
		local days = pbi.elapsed_minutes / 24.0 / 60
		if type(days) == "number" then
			total_points = total_points + days
			count = count + 1
		end
	end
	return count > 0 and math.ceil(total_points / count) or "N/A"
end

function Find_story_points(pbis)
	local points_count = {}
	for _, pbi in ipairs(pbis) do
		local points = Get_story_points(pbi)
		if points ~= "N/A" then
			points_count[points] = (points_count[points] or 0) + 1
		end
	end
	return points_count
end

function Get_days_per_story_point(pbis)
	local results = {}
	local story_points = Find_story_points(pbis)

	for points, count in pairs(story_points) do
		results[points] = {}
		local filtered_pbis = Filter(pbis, function(pbi)
			return Get_story_points(pbi) == points
		end)

		for _, pbi in ipairs(filtered_pbis) do
			if pbi.elapsed_minutes ~= nil then
				local days = math.ceil(pbi.elapsed_minutes / 24.0 / 60)
				if type(days) == "number" and days < 14 then
					table.insert(results[points], days)
				end
			end
		end
	end

	return results
end

function Calculate_average_days_per_story_point(pbis)
	local days_per_point = Get_days_per_story_point(pbis)
	local averages = {}

	for sp, days in pairs(days_per_point) do
		averages[sp] = Calculate_mean(days)
	end

	return averages
end

function Calculate_duration_diff_per_story_point(pbi, pbis)
	local avg_days = Calculate_average_days_per_story_point(pbis)
	local pbi_days = math.ceil(pbi.elapsed_minutes / 24.0 / 60)

	local diffs = {}

	for sp, days in pairs(avg_days) do
		table.insert(diffs, { sp = sp, days = math.abs(days - pbi_days) })
	end

	return diffs
end

function Find_closest_story_point(duration, days_per_sps)
	if #days_per_sps == 0 then
		return "N/A"
	end
	duration = duration / 24 / 60
	local min = days_per_sps[1]
	local min_diff = duration - min.days
	for i = 2, #days_per_sps, 1 do
		local current = days_per_sps[i]
		local diff = min.days - duration
		if math.min(min_diff, diff) == diff then
			min = current
			min_diff = diff
		end
	end

	return min
end

function Find_best_story_points(pbi, pbis)
	return Find_min_diff(Calculate_duration_diff_per_story_point(pbi, pbis)).sp
end

function Find_min_diff(pbis)
	local min = pbis[1]
	for i = 2, #pbis, 1 do
		local current = pbis[i]
		if math.min(min.days, current.days) == current.days then
			min = current
		end
	end
	return min
end

function Calculate_accuracy(pbi, pbis)
	if pbi.elapsed_minutes == nil then
		return "N/A"
	end
	local sp = Get_story_points(pbi)
	if pbi.elapsed_minutes / 24 / 60 >= 14 then
		return "Failure"
	end
	local best_sp = Find_best_story_points(pbi, pbis)

	if best_sp > sp then
		return "Possible Under"
	elseif best_sp < sp then
		return "Possible Over"
	else
		return "Good"
	end
end
