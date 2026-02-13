local Utils = {}

local tinsert: ({number}, number) -> () = table.insert

function Utils. StripLeadingZeros(limbs: {number})
	while true do
		local limbLen: number = #limbs
		if limbLen == 0 or limbs[limbLen] ~= 0 then break end

		limbs[limbLen] = nil
	end
end

return Utils