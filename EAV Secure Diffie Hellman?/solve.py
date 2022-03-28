#https://www.alpertron.com.ar/DILOG.HTM
# Base = 3
# Power = 236498462734017891143727364481546318401
# Modulus = 320907854534300658334827579113595683489
#
# After a few mins, it computes:
# Find exp such that 3exp ≡ 236 498462 734017 891143 727364 481546 318401 (39 digits) (mod 320 907854 534300 658334 827579 113595 683489 (39 digits))
#
# exp = 67 514057 458967 447420 279566 091192 598301 (38 digits) + 320 907854 534300 658334 827579 113595 683488 (39 digits)k
#
# We can then brute-force k
#
#factoring 320907854534300658334827579113595683488 we get 2^5×7×2963×16736263×50931347×567227167089660509 (10 prime factors, 6 distinct)
from Crypto.Util.number import long_to_bytes
p = 320907854534300658334827579113595683489

def exploit():
    #Thanks to log-jam we know that DHE done with less than 512 bits is vulnerable to a discrete log attack
    a = 0
    k = 0
    while k < 100000000:
        a = 67514057458967447420279566091192598301 + 320907854534300658334827579113595683488 * k
        k += 1
        flag = long_to_bytes(a)
        if flag.startswith(b"wsc"):
            print(k, flag.decode())
            break

if __name__ == "__main__":
    exploit()