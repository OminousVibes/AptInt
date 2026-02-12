export type AptIntMetatable = {
	__index: AptInt,
	__unm: (num: AptInt) -> AptInt,
	__add: (a: ValidMetamethodArgument, b: ValidMetamethodArgument) -> AptInt,
	__sub: (a: ValidMetamethodArgument, b: ValidMetamethodArgument) -> AptInt,
	__mul: (a: ValidMetamethodArgument, b: ValidMetamethodArgument) -> AptInt,
	__div: (a: ValidMetamethodArgument, b: ValidMetamethodArgument) -> AptInt,
	__mod: (a: ValidMetamethodArgument, b: ValidMetamethodArgument) -> AptInt,
	__pow: (a: ValidMetamethodArgument, b: ValidMetamethodArgument) -> AptInt,
	__eq: (a: ValidMetamethodArgument, b: ValidMetamethodArgument) -> boolean,
	__lt: (a: ValidMetamethodArgument, b: ValidMetamethodArgument) -> boolean,
	__le: (a: ValidMetamethodArgument, b: ValidMetamethodArgument) -> boolean,
	__tostring: (n: AptInt) -> string,
	__len: (n: AptInt) -> number,
}

export type AptInt = setmetatable<{
	limbs: {number},
	signum: number,
	
	read clone: (n: AptInt) -> AptInt,
	read Negate: (n: AptInt, inPlace: boolean?) -> AptInt,

	read AddRaw: (self: AptInt, term: AptInt, inPlace: boolean?) -> AptInt,
	read SubtractRaw: (self: AptInt, term: AptInt, inPlace: boolean?) -> AptInt,
	read MultiplyRaw: (self: AptInt, factor: AptInt) -> AptInt,
	read DivideRaw: (self: AptInt, divisor: AptInt) -> (AptInt, AptInt),
	read ModRaw: (self: AptInt, div: AptInt) -> AptInt,
	read PowRaw: (self: AptInt, pow: AptInt) -> AptInt,
	read sqrt: (self: AptInt) -> AptInt,

	read EqualsRaw: (self: AptInt, num: AptInt) -> boolean,
	read LowerThanRaw: (self: AptInt, num: AptInt) -> boolean,
	read LowerOrEqualToRaw: (self: AptInt, num: AptInt) -> boolean,

	read LeftShift: (self: AptInt, n: number) -> AptInt,
	read RightShift: (self: AptInt, n: number) -> AptInt,

	read ToString: (self: AptInt) -> string,
	read ToNumber: (self: AptInt) -> number,
}, AptIntMetatable>

export type ValidConstructor = string | number | {number} | nil
export type ValidMetamethodArgument = string | number | AptInt

return {}
