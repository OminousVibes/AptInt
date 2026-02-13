local Subtraction = {}

local Utils = require("./Utils")
local Constants = require("../Constants")

local StripLeadingZeros: ({number}) -> () = Utils.StripLeadingZeros

local abs: (number) -> number = math.abs

local tclone: ({number}) -> {number} = table.clone
local tinsert: ({number}, number) -> () = table.insert

local BASE: number = Constants.BASE

function Subtraction.SubLimbs(self: {number}, term: {number}, inPlace: boolean?)
	local selfSign: number, termSign: number = self.signum, term.signum

	local result: {number} = (inPlace and self or tclone(self))
	
	local borrow: number = 0
	for i: number, digit: number in result do
		local diff: number = digit - (term[i] or 0) - borrow
		
		if diff < 0 then
			borrow = 1
			result[i] = diff + BASE
			continue
		end

		borrow = 0
		result[i] = diff
	end

	StripLeadingZeros(result)
	return result
end

return Subtraction