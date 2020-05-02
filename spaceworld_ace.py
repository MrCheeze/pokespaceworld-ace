data = open('Pokémon Gold - Spaceworld 1997 Demo (NonDebug) (Header Fixed).sgb','rb').read()

maps = [(0x2F,0x5655,"ShizukanaOka"),
(0x34,0x40A6,"PlayerHouse1F"),
(0x34,0x4195,"PlayerHouse2F"),
(0x34,0x468C,"SilentHillPokecenter"),
(0x34,0x4843,"SilentHillHouse"),
(0x34,0x4BC6,"SilentHillLabFront"),
(0x34,0x5C73,"SilentHillLabBack"),
(0x34,0x767E,"SilentHill"),
(0x36,0x7BA2,"Route1P1"),
(0x36,0x7C72,"Route1P2")]

maps = [(0x36,0x7BA2,"Route1P1")]

a=[]
for rombank,romaddr,mapname in maps:
    addr = rombank*0x4000+romaddr-0x4000
    for i in range(0x40):
        high = data[addr+4*i+1]
        if high >= 0xE0 and high < 0xFE:
            high -= 0x20
        a.append('%02X%02X: %02X %s'%(high,data[addr+4*i],i,mapname))

for b in sorted(a):
    print(b)
