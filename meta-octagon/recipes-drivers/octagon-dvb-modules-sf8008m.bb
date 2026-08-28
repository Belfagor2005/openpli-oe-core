KV = "4.4.35"
SRCDATE = "20221108"

require octagon-dvb-modules-hisi.inc

SRC_URI[md5sum] = "a770b5018c65121da3b29ec326b3ab16"
SRC_URI[sha256sum] = "21a14a5783d68fea047f5dacd6a612a0a960e5089368a3e2f665d317436704d0"

do_install:append() {
    python3 - <<'PY'
from pathlib import Path

p = Path("${D}${base_libdir}/modules/${KV}/extra/hisi-ir.ko")

if not p.exists():
    print("SF8008M RC patch: hisi-ir.ko not found, skipping")
else:
    data = p.read_bytes()

    old = bytes.fromhex("a2 5d fa 05 79 01 00 00")
    new = bytes.fromhex("a2 5d fa 05 7a 01 00 00")

    if data.count(old) == 1:
        data = data.replace(old, new)
        p.write_bytes(data)
        print("SF8008M RC patch: KEY_TV -> KEY_TV2 applied")
    elif data.count(new) == 1:
        print("SF8008M RC patch: already applied")
    else:
        print("SF8008M RC patch: pattern not found, skipping")
PY
}
