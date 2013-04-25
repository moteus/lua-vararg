local _G = require "_G"
local error = _G.error
local select = _G.select

local math = require "math"
local max = math.max

local table = require "table"
local tinsert = table.insert
local tremove = table.remove
local unpack = table.unpack or _G.unpack

local function idx(i, n, d)
	if i == nil then
		return d
	elseif i < 0 then
		i = n+i+1
	end
	return i
end

local function pack(...)
	local n = select("#", ...)
	local v = {...}
	return function(...)
		if (...) == "#" then
			return n
		else
			local argc = select("#", ...)
			if argc == 0 then
				return unpack(v, 1, n)
			else
				local i, j = ...
				if i == nil then
					if j == nil then j = 0 end
					i = j+1
					if i > 0 and i <= n then
						return i, v[i]
					end
				else
					i = idx(i, n, 1)
					j = idx(j, n, i)
					return unpack(v, i, j)
				end
			end
		end
	end
end

local function range(i, j, ...)
	local n = select("#", ...)
	return unpack({...}, idx(i,n), idx(j,n))
end

local function remove(i, ...)
	local n = select("#", ...)
	local t = {...}
	i = idx(i, n)
	if i>0 and i<=n then
		tremove(t, i)
		n = n-1
	end
	return unpack(t, 1, n)
end

local function insert(v, i, ...)
	local n = select("#", ...)
	local t = {...}
	i = idx(i, n)
	if i>0 then
		tinsert(t, i, v)
		n = max(n+1, i)
	end
	return unpack(t, 1, n)
end

local function replace(v, i, ...)
	local n = select("#", ...)
	local t = {...}
	i = idx(i, n)
	if i>0 then
		t[i] = v
		n = max(n, i)
	end
	return unpack(t, 1, n)
end

local function append(v, ...)
	local n = select("#",...)+1
	return unpack({[n]=v, ...}, 1, n)
end

local function map(f, ...)
	local n = select("#", ...)
	local t = {}
	for i = 1, n do
		t[i] = f((select(i, ...)))
	end
	return unpack(t, 1, n)
end

local function packinto(n, t, ...)
	local c = select("#", ...)
	for i = 1, c do
		t[n+i] = select(i, ...)
	end
	return n+c
end
local function concat(...)
	local n = 0
	local t = {}
	for i = 1, select("#", ...) do
		local f = select(i, ...)
		n = packinto(n, t, f())
	end
	return unpack(t, 1, n)
end

return {
	pack = pack,
	range = range,
	insert = insert,
	remove = remove,
	replace = replace,
	append = append,
	map = map,
	concat = concat,
}
