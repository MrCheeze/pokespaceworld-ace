
for i in range(0x77):
    addr1 = (0xd6b2+0x30*i)%0x10000
    addr2 = (0xd6b2+0x30*i+0x2F)%0x10000
    if addr1 >= 0xE000 and addr1 < 0xFE00:
        addr1 -= 0x2000
    if addr2 >= 0xE000 and addr2 < 0xFE00:
        addr2 -= 0x2000
    print('%02X: %04X-%04X'%(i, addr1, addr2))
    
print()

for i in range(0x77):
    addr1 = (0xba68+0x28*i)%0x10000
    addr2 = (0xba68+0x28*i+0x27)%0x10000
    if addr1 >= 0xE000 and addr1 < 0xFE00:
        addr1 -= 0x2000
    if addr2 >= 0xE000 and addr2 < 0xFE00:
        addr2 -= 0x2000
    print('%02X: %04X-%04X'%(i, addr1, addr2))

