local Addition = {}

local Constants = require("../Constants")

local abs: (number) -> number = math.abs

local tclone: ({number}) -> {number} = table.clone
local tinsert: ({number}, number) -> () = table.insert

local BASE: number = Constants.BASE
local MIN_MINADD_OFFSET: number = Constants.MIN_MINADD_OFFSET

local function MinAdd(term: {number}, result: AptInt): {number}
	--> since result has self's limbs, we can just iterate over y
	--> carry is 99.99% of times very small, so the while loop doesnt run much
	--> overall faster
	
	--> from right to left
	local carry: number = 0
	for i: number, yLimb: number in term do
		local sum: number = result[i] + yLimb + carry

		if sum >= BASE then
			carry = 1
			result[i] = sum - BASE
			continue
		end

		carry = 0
		result[i] = sum
	end

	if carry == 0 then return result end

	--> carry loop
	local resultIndex: number = #term
	while true do
		resultIndex += 1
		local sum: number = (result[resultIndex] or 0) + 1

		if sum >= BASE then
			result[resultIndex] = sum - BASE
			continue
		end

		result[resultIndex] = sum
		break
	end

	return result
end

function Addition.AddLimbs(self: {number}, term: {number}, inPlace: boolean?)
	local selfLen: number, termLen: number = #self, #term

	--> choose the longer number to avoid extra "or 0" with selfDigit
	local result: {number}
	if selfLen < termLen then
		result = tclone(term)
		self, term = term, self
	else
		result = (inPlace and self or tclone(self))
	end

	if abs(termLen - selfLen) > MIN_MINADD_OFFSET then
		return MinAdd(term, result)
	end
	
	--> from right to left
	local carry: number = 0
	for i: number, selfLimb: number in self do
		local sum: number = selfLimb + (term[i] or 0) + carry

		if sum >= BASE then
			carry = 1
			result[i] = sum - BASE
			continue
		end

		carry = 0
		result[i] = sum
	end

	if carry > 0 then tinsert(result, carry) end
	return result
end

return Addition