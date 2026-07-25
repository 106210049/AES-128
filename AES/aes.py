from Crypto.Cipher import AES
from binascii import unhexlify, hexlify

def aes128_encrypt(data_in_hex, key_hex):
    data_in = unhexlify(data_in_hex)
    key = unhexlify(key_hex)
    cipher = AES.new(key, AES.MODE_ECB)
    encrypted = cipher.encrypt(data_in)
    return hexlify(encrypted).decode()

def aes128_decrypt(data_in_hex, key_hex):
    data_in = unhexlify(data_in_hex)
    key = unhexlify(key_hex)
    cipher = AES.new(key, AES.MODE_ECB)
    decrypted = cipher.decrypt(data_in)
    return hexlify(decrypted).decode()

pairs_group1 = [
    ("f955b1b5e6f2c07b8cf133f3660447e9", "1008bf076f5df11fd5586142e6a96849"),
    ("5bceedff58d15ce55d74e9bbb5767a85", "5711dac49f3df60fbb4b04c237812c03"),
    ("5d70c1e866ea1135aae3cb25b0a16e46", "5056b845f9cba8cfd321be39e7687a46"),
    ("1e6051cec5f341ad4b6c3e7c03356ac4", "9b51e84517db09716a4a953ed224645e"),
    ("9c61667939aa8b51c2129dae29f9f42b", "85d88232318618f12beb41f5da761e22"),
    ("7c3be769dd770f79ff7291566d3d7002", "adb1654b191627cb6529eb01b649376f"),
    ("4c469012d7a9165b555bc6f587886104", "c84a88f829f4a609fd0745fa317077d2"),
    ("a6e21e8d39fa7935364d6692f6a23c2a", "a404c6e111a895d6e6d591e9451a657e"),
    ("bfe42802f2ac66574b9cb625105005fb", "a978b2f87ed4108c3806bed6b357777b"),
    ("7690c80e31b41a3d2f4560d82201a462", "9fe50bf49e3ae23cdaf5d65f4ebcf573"),
]

pairs_group2 = [
    ("f955b1b5e6f2c07b8cf133f3660447e9", "67864cb04d80d7aa304d4dc5e64603f4"),
    ("69C4E0D86A7B0430D8CDB78070B4C55A", "000102030405060708090A0B0C0D0E0F"),
]

print("=== ENCRYPTION ===")
for data_in, key in pairs_group1:
    data_out = aes128_encrypt(data_in, key)
    # decrypted = aes128_decrypt(data_out, key)
    print(f"data_in: {data_in}, key: {key}, data_out: {data_out}")

print("=== DECRYPTION ===")
for data_in, key in pairs_group2:
    # data_out = aes128_encrypt(data_in, key)
    decrypted = aes128_decrypt(data_in, key)
    print(f"data_in: {data_in}, key: {key},  decrypted: {decrypted}")
