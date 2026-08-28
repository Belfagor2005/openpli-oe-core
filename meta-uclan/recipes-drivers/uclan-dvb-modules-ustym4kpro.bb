KV = "4.4.35"
SRCDATE = "20230804"

require uclan-dvb-modules-hisi.inc

SRC_URI[md5sum] = "f0b68baa9fc0f7296efd99b58fff3cd7"
SRC_URI[sha256sum] = "8a5b52280934dd307b9c097468128894a85470a08e5ecd1cf916c30262af0e82"

do_install:append() {
    python3 - <<'PY'
from pathlib import Path

p = Path("${D}${base_libdir}/modules/${KV}/extra/hisi-ir.ko")

if not p.exists():
    print("USTYM4KPRO RC patch: hisi-ir.ko not found, skipping")
else:
    data = p.read_bytes()

    old = bytes.fromhex("a2 5d fa 05 79 01 00 00")
    new = bytes.fromhex("a2 5d fa 05 7a 01 00 00")

    if data.count(old) == 1:
        data = data.replace(old, new)
        p.write_bytes(data)
        print("USTYM4KPRO RC patch: KEY_TV -> KEY_TV2 applied")
    elif data.count(new) == 1:
        print("USTYM4KPRO RC patch: already applied")
    else:
        print("USTYM4KPRO RC patch: pattern not found, skipping")
PY
}
