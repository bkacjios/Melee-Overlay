function table.merge(first, second)
	for k,v in pairs(second) do
		first[k] = v
	end
end

function table.hasValue(tbl, val)
	for key, value in pairs(tbl) do
		if (value == val) then return true, key end
	end
	return false
end

function table.val_to_str(v)
	if "string" == type(v) then
		v = string.gsub(v, "\n", "\\n" )
		if string.match(string.gsub(v,"[^'\"]",""), '^"+$') then
			return "'" .. v .. "'"
		end
		return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
	else
		return "table" == type(v) and table.tostring(v) or tostring( v )
	end
end

function table.key_to_str(k)
	if "string" == type(k) and string.match(k, "^[_%a][_%a%d]*$") then
		return k
	else
		return "[" .. table.val_to_str(k) .. "]"
	end
end

function table.print(tbl, indent, done)
	done = done or {[tbl] = true}
	indent = indent or 1

	for k, v in pairs(tbl) do
		local tabs = string.rep("\t", indent)
		if (type(v) == "table" and not done[v]) then
			print(tabs .. table.key_to_str(k) .. " = {")
			done[v] = true
			table.print(v, indent + 1, done)
			print(tabs .. "}")
		else
			print(tabs .. table.key_to_str(k) .. " = " .. table.val_to_str(v))
		end
	end
end

function table.copy(object)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	end
	return _copy(object)
end

function table.concatList(table, oxford)
	local str = ""
	local num = #table
	for i=1,num do
		if i < num then
			str = str .. table[i] .. ((oxford or i < num - 1) and ", " or " ")
		elseif i > 1 then
			str = str .. "and " .. table[i]
		else
			str = str .. table[i]
		end
	end
	return str
end