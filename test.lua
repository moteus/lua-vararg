require "vararg"

local _G = require "_G"
local assert = _G.assert
local pcall = _G.pcall
local print = _G.print
local unpack = _G.unpack
local select = _G.select

local math = require "math"
local huge = math.huge
local ceil = math.ceil
local min = math.min

module "vararg"

local values = {}
local maxstack
for i = 1, huge do
	if not pcall(unpack, values, 1, 2^i) then
		local min, max = 2^(i-1), 2^i
		while min < max do
			local mid = ceil((min+max)/2)
			if pcall(unpack, values, 1, mid) then
				min = mid
			else
				max = mid-1
			end
		end
		maxstack = max
		break
	end
end
for i = 1, maxstack, 2 do
	values[i] = i
end

local function tpack(...)
	return {..., n=select("#", ...)}
end

local function assertsame(v, i, j, ...)
	local count = select("#", ...)
	assert(count == j-i+1, count..","..i..","..j)
	for pos = 1, count do
		assert(v[i+pos-1] == select(pos, ...))
	end
end

local function testpack(...)
	local v = {...}
	local n = select("#", ...)
	local p = pack(...)
	assertsame(v, 1, n, p())
	assert(n == p("#"))
	for i,pv in p do assert(v[i] == pv) end
	for i = 1, n do
		assert(v[i] == p(i))
		if n > 0 then
			assert(v[i] == p(i-n-1))
		end
	end
	for i = 1, n, 10 do
		local j = i+9
		assertsame(v, i, j, p(i, j))
		if n > j then
			assertsame(v, i, j, p(i-n-1, j-n-1))
		end
	end
end

testpack()
testpack({},{},{})
testpack(nil)
testpack(nil, nil)
testpack(nil, 1, nil)
testpack(unpack(values, 1, 254))

local ok, err = pcall(pack, unpack(values, 1, 255))
assert(ok == false and err == "too many values to pack")

local function testargs(n, ...)
	local v = {...}
	for c = 1, 3 do
		for i = 1, n, c do
			local j = min(i+c-1, n)
			assertsame(v, i, j, range(i, j, ...))
			local n = select("#", ...)
			if n > 0 then
				assertsame(v, i, j, range(i-n-1, j-n-1, ...))
			end
		end
	end
end

local ok, err = pcall(range, 0, 0, ...)
assert(ok == false and err == "bad argument #1 to '?' (index out of bounds)")

testargs(10)
testargs(10, 1,2,3,4,5,6,7,8,9,0)
testargs(maxstack, unpack(values, 1, maxstack))


assertsame({1,2,3,4,5}, 1, 5, insert(3, 3, 1,2,4,5))
assertsame({1,2,3,4,5}, 1, 5, insert(4,-1, 1,2,3,5))
assertsame({1,2,nil,4}, 1, 4, insert(4, 4, 1,2))
assertsame({nil,nil,3}, 1, 3, insert(3, 3))

assertsame({1,2,3,4,5}, 1, 5, replace(3, 3, 1,2,0,4,5))
assertsame({1,2,3,4,5}, 1, 5, replace(5,-1, 1,2,3,4,0))
assertsame({1,2,nil,4}, 1, 4, replace(4, 4, 1,2))
assertsame({nil,nil,3}, 1, 3, replace(3, 3))

assertsame({1,2,3,4,5}, 1, 5, remove(3,  1,2,0,3,4,5))
assertsame({1,2,3,4,5}, 1, 5, remove(-1, 1,2,3,4,5,0))
assertsame({1,2,nil,4}, 1, 4, remove(4,  1,2,nil,0,4))
assertsame({nil,nil,3}, 1, 3, remove(3,  nil,nil,0,3))
assertsame({1,2,3,4,5}, 1, 5, remove(10, 1,2,3,4,5))

assertsame({1,2,3,4,5}, 1, 5, append(5, 1,2,3,4))
assertsame({1,2,3,4,5}, 1, 5, append(5, 1,2,3,4))
assertsame({1,2,nil,4}, 1, 4, append(4, 1,2,nil))
assertsame({nil,nil,3}, 1, 3, append(3, nil,nil))

assertsame({1,2,3,4,5,6,7,8,9}, 1, 9, concat(pack(1,2,3),
                                             pack(4,5,6),
                                             pack(7,8,9)))
