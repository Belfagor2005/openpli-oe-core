KV = "4.4.35"
SRCDATE = "20250507"

require gigablue-dvb-modules-hisi.inc

SRC_URI[md5sum] = "e9ab5e965834d18bcbd2adfac5cf2491"
SRC_URI[sha256sum] = "9f206e0c01dfe701d28e4027a5837613fdfa41daf2d9f65bfcdc3c5703fb74ad"

do_install:append() {
    python3 - <<'PY'
from pathlib import Path

p = Path("${D}${base_libdir}/modules/${KV}/extra/hisi-ir.ko")

if not p.exists():
    print("GBTRIO4K RC patch: hisi-ir.ko not found, skipping")
else:
    data = p.read_bytes()

    patches = (
        (
            bytes.fromhex("a1 5e af 50 3d 00 00 00"),
            bytes.fromhex("5c a3 af 50 3d 00 00 00"),
            "CONTEXT -> KEY_F3",
        ),
        (
            bytes.fromhex("de 21 af 50 3e 00 00 00"),
            bytes.fromhex("5e a1 af 50 3e 00 00 00"),
            "SUBT -> KEY_F4",
        ),
    )

    changed = False

    for old, new, name in patches:
        if data.count(old) == 1:
            data = data.replace(old, new)
            print("GBTRIO4K RC patch: applied:", name)
            changed = True
        elif data.count(new) == 1:
            print("GBTRIO4K RC patch: already applied:", name)
        else:
            print("GBTRIO4K RC patch: pattern not found, skipping:", name)

    if changed:
        p.write_bytes(data)
PY
}
