--!native
--!strict
--!optimize 2

local Mul = {}

local Utils = require("./Utils")
local Constants = require("../Constants")
local Add = require("./Add")
local Sub = require("./Sub")

-- ================================
--> OPTIMIAZTION FUNCTION CONSTANTS
-- ================================

local GetUpper: ({number}, number) -> {number} = Utils.GetUpper
local GetLower: ({number}, number) -> {number} = Utils.GetLower
local GetSlice: ({number}, number, number) -> {number} = Utils.GetSlice
local LeftShift: ({number}, number) -> {number} = Utils.LeftShift

local AddLimbs: ({number}, {number}, boolean?) -> {number} = Add.AddLimbs
local SubLimbs: ({number}, {number}, boolean?) -> {number} = Sub.SubLimbs

local max: (number, number) -> number = math.max
local min: (number, number) -> number = math.min

local tclone: ({number}) -> {number} = table.clone
local tcreate: (number, number) -> {number} = table.create
local tinsert: ({number}, number) -> () = table.insert

-- =================
--> NORMAL CONSTANTS
-- =================

local KARATSUBA_THRESHOLD: number = Constants.KARATSUBA_THRESHOLD
local TOOM3_THRESHOLD: number = Constants.TOOM3_THRESHOLD

local BASE: number = Constants.BASE

-- ==========
--> FUNCTIONS
-- ==========

function Mul.MulByInt(self: {number}, num: number): {number}
	local result: {number} = tclone(self)
	
	local carry: number = 0
	for i: number, limb: number in result do
		local product: number = limb * num + carry

		carry = product // BASE
		result[i] = product % BASE
	end

	if carry > 0 then
		tinsert(result, carry)
	end

	return result
end

-- Normal O(n^2) algorithm
function Mul.MulLimbsBasecase(self: {number}, factor: {number}): {number}
	local selfLen: number, factorLen: number = #self, #factor
	local len: number = selfLen + factorLen
	local result: {number} = tcreate(len, 0)

	factorLen -= 1
	local carry: number = 0
	for i: number = 1, len do
		local p: number = carry
		local iplus: number = i + 1

		for j: number = max(i - factorLen, 1), min(i, selfLen) do
			p += self[j] * factor[iplus - j]
		end

		-- apply carry to current limb 
		if p >= BASE then 
			carry = p // BASE 
			result[i] = p % BASE
			continue
		end 

		carry = 0
		result[i] = p
	end

	Utils.StripLeadingZeros(result)
	return result
end

function Mul.MulKaratsuba(x: {number}, y: {number}): {number}
	local m2: number = (max(#x, #y) + 1)//2

	local low1: {number}, low2: {number} = GetLower(x, m2), GetLower(y, m2)
	local high1: {number}, high2: {number} = GetUpper(x, m2), GetUpper(y, m2)

	local z0: {number} = Mul.MulLimbs(low1, low2)
	local z1: {number} = Mul.MulLimbs(AddLimbs(low1, high1, true), AddLimbs(low2, high2, true))
	local z2: {number} = Mul.MulLimbs(high1, high2)

	-- result = z0 + ((z1 - z2 - z0) << m2) + (z2 << 2*m2)
	local result: {number} = LeftShift(z2, m2)
	SubLimbs(z1, AddLimbs(z2, z0, true), true)
	AddLimbs(result, z1, true)
	result = LeftShift(result, m2)
	AddLimbs(result, z0, true)
	
	return result
end

function Mul.MulLimbs(self: {number}, factor: {number}): {number}
	local factorLen: number = #factor
	local selfLen: number = #self
	
	if selfLen < KARATSUBA_THRESHOLD or factorLen < KARATSUBA_THRESHOLD then
		return Mul.MulLimbsBasecase(self, factor)
	end
	--[[elseif selfLen < TOOM3_THRESHOLD or factorLen < TOOM3_THRESHOLD then
		return Mul.MulKaratsuba(self, factor)
	end]]
	
	local result: {number} = Mul.MulKaratsuba(self, factor)
	Utils.StripLeadingZeros(result)
	return result
end

return Mul