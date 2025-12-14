--!native
--!optimize 2

local bigint= require(game.ReplicatedStorage.BigInteger)

local random = math.random

local function testRandomAddition()
	--> init vars
	local int1: string = math.random(1, 2) == 1 and "-" or ""
	local int2: string = math.random(1, 2) == 1 and "-" or ""
	
	for i = 1, 6 do
		int1 ..= tostring(random(1, 9))
		int2 ..= tostring(random(1, 9))
	end
	
	local bint1: bigint.BigInteger = bigint.new(int1)
	local bint2: bigint.BigInteger = bigint.new(int2)
	local b: bigint.BigInteger = bint1:AddRaw(bint2)
	assert(
		tonumber(int1) + tonumber(int2) == tonumber(b:ToStringRaw()),
		`addition test failed: term1: {int1}, term2: {int2}, expected: {tonumber(int1) + tonumber(int2)}, got {b:ToStringRaw()}`
	)
end

local tests = {
	{
		"-12345781345871457851478945978457894587914591457857891445814590781450789145782345789012457891245897145789014589457145",
		"1234578912458914589712457891457890124578914514578914590781245780134578145781457890",
		"-12345781345871457851478945978457893353335678998943301733356699323560664566867831210097867110000117011210868807999255"
	},
	
	{
		"901834589451945817890134515789047890123458903451714515678456189056904678906745789345667812345567123456712356234178914528903456890",
		"-890123458901345789356789356089512490123490812348901234897134578913456789135678",
		"901834589451945817890134515789047890123458903451713625554997287711115322117389699833177688854754774555477459099600001072114321212"
	},
	
	{
		"9999999999999999999999999999999999999999999999999999999999999999999999999999",
		"-99999999999999999999999999999999999999999999999999999999999999999999999999999",
		"-90000000000000000000000000000000000000000000000000000000000000000000000000000"
	},
	
	{
		"-999999999999994512134512341234123412349999999999999",
		"-17845814579145789",
		"-999999999999994512134512341234123430195814579145788"
	}
}

local function testBigIntAddition(n1: string, n2: string, expected: n3)
	local bint1: bigint.BigInteger = bigint.new(n1)
	local bint2: bigint.BigInteger = bigint.new(n2)
	local b: bigint.BigInteger = bint1:AddRaw(bint2)
	assert(
		b:ToStringRaw() == expected,
		`addition test failed: term1: {n1}, term2: {n2}, expected: {expected}, got {b:ToStringRaw()}`
	)
end

for i = 1, 1000 do
	testRandomAddition()
end

for _, tbl in tests do
	testBigIntAddition(tbl[1], tbl[2], tbl[3])
end
