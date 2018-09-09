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
while true do
	bank = f:read(1)
	if bank == nil then
		break
	end
	local addr = bank:byte()*0x10000 + f:read(1):byte()*0x100 + f:read(1):byte()
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

memory.usememorydomain("SGB WRAM")
local f = io.open("C:/Users/Matt/Documents/git/pokespaceworld-ace/payload.gb", "rb")
for addr,block_len in pairs(memory_areas) do
	if addr == 0xD9D9 then
		print(string.format("0x%X: 0x%X", addr, block_len))
		f:seek("set", addr)
		local data = f:read(block_len)
		f:close()
		if memory.readbyte(0x1FCD) ~= 3 then
			print("started on wrong frame")
		else
			for i=0,block_len-1 do
				local val = data:byte(i+1)
				
				inputs = {}
				if bit.band(val,0x01) ~= 0 then inputs["P1 A"] = "True" end
				if bit.band(val,0x04) ~= 0 then inputs["P1 Select"] = "True" end
				if bit.band(val,0x10) ~= 0 then inputs["P1 Right"] = "True" end
				if bit.band(val,0x40) ~= 0 then inputs["P1 Up"] = "True" end
				
				if memory.readbyte(0x1FCD) == 2 then
					print("skipped frame A")
				else
					joypad.set(inputs)
					emu.frameadvance()
				end
				if memory.readbyte(0x1FCD) == 1 then
					print("skipped frame B")
				else
					joypad.set(inputs)
					emu.frameadvance()
				end
				
				inputs = {}
				if bit.band(val,0x02) ~= 0 then inputs["P1 B"] = "True" end
				if bit.band(val,0x08) ~= 0 then inputs["P1 Start"] = "True" end
				if bit.band(val,0x20) ~= 0 then inputs["P1 Left"] = "True" end
				if bit.band(val,0x80) ~= 0 then inputs["P1 Down"] = "True" end
				
				if memory.readbyte(0x1FCD) == 2 then
					print("skipped frame C")
				else
					joypad.set(inputs)
					emu.frameadvance()
				end
				if memory.readbyte(0x1FCD) == 1 then
					print("skipped frame D")
				else
					joypad.set(inputs)
					emu.frameadvance()
				end
				
			end
			joypad.set({["P1 Down"]="True"})
			emu.frameadvance()
			joypad.set({["P1 Down"]="True"})
			emu.frameadvance()
			joypad.set({["P1 Down"]="True"})
			emu.frameadvance()
			joypad.set({["P1 Down"]="True"})
			emu.frameadvance()
		end
	end
end
print("done")