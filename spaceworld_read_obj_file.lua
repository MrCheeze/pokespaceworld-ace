local ret = os.execute("sh C:/Users/Matt/Documents/git/pokespaceworld-ace/make.sh")
if ret ~= 0 then
	print("Error " .. ret)
end
local f = io.open("C:/Users/Matt/Documents/git/pokespaceworld-ace/payload.o", "rb")
f:read(0x1D)
while f:read(1):byte() ~= 0 do end
f:read(8)
local symbol_count = f:read(1):byte()
local i
for i=1,symbol_count do
	while f:read(1):byte() ~= 0 do end
	f:read(0x12)
end
f:read(3)
symbol_count = f:read(1):byte()
for i=1,symbol_count do
	while f:read(1):byte() ~= 0 do end
	f:read(0x13)
end
f:read(0x3)
symbol_count = f:read(1):byte()
for i=1,symbol_count do
	f:read(0xA)
	local stack_count = f:read(1):byte()
	f:read(0xE)
	for j=1,stack_count do
		local itemtype=f:read(1):byte()
		f:read(1)
		if itemtype == 2 then
			while f:read(1):byte() ~= 0 do end
		else
			f:read(8)
		end
	end
end
f:read(0x10)






local memory_areas = {}
while f:read(1) do
	local addr = f:read(1):byte()*0x100 + f:read(1):byte()
	f:read(2)
	local block_len = f:read(1):byte()*0x100 + f:read(1):byte()
	f:read(block_len)
	f:read(2)
	memory_areas[addr] = block_len
end
f:close()

local cartram = ""
local memorydomains = memory.getmemorydomainlist()
for i=0,#memorydomains do
	if string.match(memorydomains[i], "CartRAM") then
		cartram = memorydomains[i]
		break
	end
end

local f = io.open("C:/Users/Matt/Documents/git/pokespaceworld-ace/payload.gb", "rb")
for addr,block_len in pairs(memory_areas) do
	print(string.format("0x%X: 0x%X", addr, block_len))
	f:seek("set", addr)
	local data = f:read(block_len)
	for i=0,block_len-1 do
		local val = data:byte(i+1)
		
		if 0xC000 <= addr and addr < 0xE000 then
			mainmemory.writebyte(addr+i-0xC000, val)
		end
		if 0xE000 <= addr and addr < 0xFE00 then
			mainmemory.writebyte(addr+i-0xE000, val)
		end
		if 0xA000 <= addr and addr < 0xC000 then
			memory.usememorydomain(cartram)
			memory.writebyte(addr+i-0xA000, val)
		end
	end
end
f:close()
print()