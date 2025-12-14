--!native
--!optimize 2

local bigint = require(game.ReplicatedStorage.BigInteger)

local random = math.random

local function testRandomSubtraction()
	--> init vars
	local int1: string = math.random(1, 2) == 1 and "-" or ""
	local int2: string = math.random(1, 2) == 1 and "-" or ""
	
	for i = 1, math.random(1, 12) do
		int1 ..= tostring(random(1, 9))
		int2 ..= tostring(random(1, 9))
	end
	
	local bint1: bigint.BigInteger = bigint.new(int1)
	local bint2: bigint.BigInteger = bigint.new(int2)
	local b: bigint.BigInteger = bint1:SubtractRaw(bint2)
	assert(
		tonumber(int1) - tonumber(int2) == tonumber(b:ToStringRaw()),
		`addition test failed: term1: {int1}, term2: {int2}, expected: {tonumber(int1) - tonumber(int2)}, got {b:ToStringRaw()}`
	)
end

for i = 1, 1000 do
	testRandomSubtraction()
end
