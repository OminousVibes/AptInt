--!native
--!strict
--!optimize 2

local Utils = {}

local tinsert: ({number}, number) -> () = table.insert
local tcreate: (number, number) -> {number} = table.create
local tmove: ({number}, number, number, number, {number}) -> {number} = table.move

function Utils.StripLeadingZeros(limbs: {number}): ()
	while true do
		local limbLen: number = #limbs
		if limbLen == 0 or limbs[limbLen] ~= 0 then break end

		limbs[limbLen] = nil
	end
end

function Utils.GetLower(limbs: {number}, n: number): {number}
	return tmove(limbs, 1, n, 1, {})
end

--> get upper n limbs
function Utils.GetUpper(limbs: {number}, n: number): {number}
	return tmove(limbs, n+1, #limbs, 1, {})
end

--> get limbs from startIdx to endIdx
function Utils.GetSlice(limbs: {number}, startIdx: number, endIdx: number): {number}
	return tmove(limbs, startIdx, endIdx, 1, {})
end

function Utils.LeftShift(limbs: {number}, amount: number)
	-- this is the fastest way to leftshift
	return tmove(limbs, 1, #limbs, amount+1, tcreate(amount, 0))
end

return Utils