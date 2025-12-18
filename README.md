### BigInteger.luau: Luau implementation of BigInteger with added typechecking
It can go up to <b>b*2^53 digits</b> before it starts losing precision. Currently, b is equal to 10^7. (that's 90 sextillion digits!)

# Extensions
Extending the module is very easy. Just call `BigInteger.Extend(func: typeof(BigInteger) -> ())`. For example,
```luau
BigInteger.Extend(function(tbl: typeof(BigInteger) | any)
	function tbl:IsEven(): boolean
		return (self :: BigInteger).digits[1] % 2 == 0
	end
end)
```
