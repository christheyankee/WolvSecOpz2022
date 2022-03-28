import random
import hashlib
import hmac
import requests
from Crypto.Util.number import bytes_to_long, long_to_bytes

key = {
    '0' : 0 , '1' : 1 , '2' : 2 , '3' : 3 , '4' : 4 , '5' : 5 , '6' : 6 ,
    'a' : 70, 'b' : 71, 'c' : 72, 'd' : 73, 'e' : 74, 'f' : 75, 'g' : 76, 'h' : 77, 'i' : 78, 'j' : 79, 
    'k' : 80, 'l' : 81, 'm' : 82, 'n' : 83, 'o' : 84, 'p' : 85, 'q' : 86, 'r' : 87, 's' : 88, 't' : 89, 
    'u' : 90, 'v' : 91, 'w' : 92, 'x' : 93, 'y' : 94, 'z' : 95, '_' : 96, '#' : 97, '$' : 98, '!' : 99, 
}

def long_to_bytes_flag(long_in):
    new_map = {v: k for k, v in key.items()}
    list_long_in = [int(x) for x in str(long_in)]
    str_out = ''
    i = 0
    while i < len(list_long_in):
        if list_long_in[i] < 7:
            str_out += new_map[list_long_in[i]]
        else:
            str_out += new_map[int(str(list_long_in[i]) + str(list_long_in[i + 1]))]
            i += 1
        i += 1
    return str_out.encode("utf_8")

p = 6864797660130609714981900799081393217269435300143305409394463459185543183397656052122559640661454554977296311391480858037121987999716643812574028291115057151
g = 5016207480195436608185086499540165384974370357935113494710347988666301733433042648065896850128295520758870894508726377746919372737683286439372142539002903041
q = 0
p_factors = factor(p - 1)
#2 * 3 * 5^2 * 11 * 17 * 31 * 41 * 53 * 131 * 157 * 521 * 1613 * 2731 * 8191 * 42641 * 51481 * 61681 * 409891 * 858001 * 5746001 * 7623851 * 34110701 * 308761441 * 2400573761 * 65427463921 * 108140989558681 * 145295143558111 * 173308343918874810521923841
for (candidate, _) in p_factors:
    if pow(g, candidate, p) == 1:
        q = candidate
        break
j = (p-1) / q
r_list = factor(j)
r_i = []
b_i = []
total = 1
for (r, r_p) in r_list:
    if r_p != 1 or r < 10 or r == 521:
        continue
    print("r: ", r)
    A = 1
    while A == 1:
        ra = random.randint(1, p)
        o = int((p-1)/r)
        A = pow(ra, o, p)
    query = {'A':A}
    resp = requests.get(url = 'https://dhe-medium-bvel4oasra-uc.a.run.app/', params = query)
    target = int(resp.text)
    print(target)
    message = b'My totally secure message to Alice'
    i = int(1)
    first_guess = long_to_bytes(int(pow(A, i, p)))
    guess = 0
    my_hmac = hmac.new(message, first_guess, hashlib.sha256)
    while int(target) != bytes_to_long(my_hmac.digest()) and first_guess != guess:
        i += int(1)
        guess = pow(A, i, p)
        my_hmac = hmac.new(msg=message, key=long_to_bytes(int(guess)), digestmod=hashlib.sha256)
    r_i.append(Integer(r))
    b_i.append(Integer(i))
    total *= r
    candidate_a = CRT_list(b_i, r_i)
    if total > q:
        break
    print("r_i: ", r_i)
    print("b_i: ", b_i)
    print("total", total)
    print("q:", q)
    print("cadidate a:", candidate_a)
a = CRT_list(b_i, r_i)
print(a)
print(long_to_bytes_flag(a))