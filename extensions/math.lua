function math.gcd(m, n)
	-- greatest common divisor
	while m ~= 0 do
		m, n = n % m, m
	end
	return n
end

function math.round(num, palces)
	local mult = math.pow(10, (palces or 0))
	return math.floor(num * mult + 0.5) / mult
end

function math.randomFloat(min, max)
	return min + math.random() * (max - min)
end