Standerd Method of OTPs
- HOTP (RFC 4226): Counter-based OTP, changes only when a counter is manually increased.
- TOTP (RFC 6238): Time-based OTP (built on HOTP), changes automatically every `n` seconds.

🧠 HOTP vs TOTP

| Feature       | HOTP                           | TOTP                           |
| ------------- | ------------------------------ | ------------------------------ |
| Type          | Counter-based                  | Time-based                     |
| RFC           | 4226                           | 6238                           |
| Input         | Secret + Counter               | Secret + (Time / Interval)     |
| Sync Required | Yes (server & client counters) | Yes (clock sync)               |
| Typical Use   | Hardware tokens, banking OTPs  | Google Authenticator, MFA apps |



---

## 🧩 Step 1 — Inputs

Let’s assume:

```
Secret = "JBSWY3DPEHPK3PXP"
Time   = 1730000000 (Unix seconds / 30-sec interval)
Algorithm = SHA1
```

We compute:

```dart
digest = HMAC(secret, time)
```

and we get a **20-byte hash** (shown in hex):

```
Digest:
0x12 0x8F 0xE9 0x7A  0xD3 0x55 0xBC 0x91
0x0A 0x66 0xE4 0x44  0x45 0xA3 0xF2 0x10
0xBE 0x27 0x8C 0xAB
```

*(Each pair is one byte; total 20 bytes = 160 bits)*

---

## 🧮 Step 2 — Compute the Offset

```dart
final offset = digest[digest.length - 1] & 0x0f;
```

* The **last byte** is `0xAB`
* `0xAB & 0x0F = 0x0B (11 decimal)`

✅ So the offset = **11**

That means the algorithm will start reading **4 bytes from index 11** of the digest.

---

## 🧱 Step 3 — Extract 4 Bytes

We start from index 11 (zero-based):

```
Index:  11   12   13   14   15
Bytes:  0x44 0x45 0xA3 0xF2 0x10
```

We only take **4 bytes starting at offset (11 → 14)**:

```
Selected bytes:  0x44  0x45  0xA3  0xF2
```

Then apply:

```dart
((digest[offset] & 0x7f) << 24) |
((digest[offset+1] & 0xff) << 16) |
((digest[offset+2] & 0xff) << 8) |
(digest[offset+3] & 0xff);
```

---

## 🧩 Step 4 — Combine to 32-bit Integer

| Byte | Mask   | Shift   | Result       |
| ---- | ------ | ------- | ------------ |
| 0x44 | `0x7f` | `<< 24` | `0x44000000` |
| 0x45 | `0xff` | `<< 16` | `0x00450000` |
| 0xA3 | `0xff` | `<< 8`  | `0x0000A300` |
| 0xF2 | `0xff` | none    | `0x000000F2` |

Add them up:

```
0x44000000 +
0x00450000 +
0x0000A300 +
0x000000F2
= 0x4445A3F2
```

Convert to decimal:

```
binary = 1,144,836,082
```

---

## 🔢 Step 5 — Reduce to 6 Digits

We need only 6 digits, so:

```dart
otp = binary % 10^6
otp = 1,144,836,082 % 1,000,000
otp = 836082
```

✅ **Final OTP = 836082**

---

## 🧠 Step 6 — Visual Summary

```
HMAC(secret, time) → 12 8F E9 7A D3 55 BC 91 0A 66 E4 44 45 A3 F2 10 BE 27 8C AB
                                                ↑
                                                |
                                          offset = 11
Extract 4 bytes:          44 45 A3 F2
Combine into integer:     0x4445A3F2 = 1,144,836,082
Modulo 10^6 → OTP =       836082
```

---

## 🔀 Why It’s Always Different

Let’s change **time** slightly → new digest completely changes:

| Time           | Digest (last bytes) | Offset | 4 bytes selected | Resulting OTP |
| -------------- | ------------------- | ------ | ---------------- | ------------- |
| t = 1730000000 | ... `BE 27 8C AB`   | 11     | 44 45 A3 F2      | 836082        |
| t = 1730000030 | ... `39 12 9F 6D`   | 13     | F2 10 BE 27      | 912547        |
| t = 1730000060 | ... `7A 9C 31 E4`   | 4      | 55 BC 91 0A      | 384501        |

Even though the secret stays constant, the **HMAC output bytes change drastically** because:

* HMAC is **cryptographically random** for different inputs.
* The **offset** changes (derived from last byte).
* The **4 bytes picked** change.
* Hence → completely different OTP every time.

---

## 🧠 Analogy

Think of:

* The secret = your **personal recipe** 🍲
* The time = a **changing spice** 🌶️
* The HMAC = a blender mixing both into a unique flavor.
* The offset = picks a random spoonful of the blend.
* The final OTP = only the taste (numeric digest) you serve.

So even though the base recipe (secret) is same, each second gives a different “flavor” (OTP) — and no one can guess the next one without knowing your secret.

---

# Instance-Based (OOP) Design

