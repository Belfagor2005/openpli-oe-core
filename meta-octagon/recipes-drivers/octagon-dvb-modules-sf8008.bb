KV = "4.4.35"
SRCDATE = "20240104"

require octagon-dvb-modules-hisi.inc

SRC_URI[md5sum] = "cc5b10fbbf2dbdcbf2a432abbae80260"
SRC_URI[sha256sum] = "093612d15170ebd3c1b8930d37027521e25778aeb578dc3502b339dc607be5c1"

do_install:append() {
    python3 - <<'PY'
from pathlib import Path

p = Path("${D}${base_libdir}/modules/${KV}/extra/hisi-ir.ko")

if not p.exists():
    print("SF8008 RC patch: hisi-ir.ko not found, skipping")
else:
    data = p.read_bytes()

    old = bytes.fromhex("a2 5d fa 05 79 01 00 00")
    new = bytes.fromhex("a2 5d fa 05 7a 01 00 00")

    if data.count(old) == 1:
        data = data.replace(old, new)
        p.write_bytes(data)
        print("SF8008 RC patch: KEY_TV -> KEY_TV2 applied")
    elif data.count(new) == 1:
        print("SF8008 RC patch: already applied")
    else:
        print("SF8008 RC patch: pattern not found, skipping")
PY
}
