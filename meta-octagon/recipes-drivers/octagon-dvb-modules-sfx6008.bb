KV = "4.4.176"
SRCDATE = "20221128"

require octagon-dvb-modules-hisi.inc

SRC_URI[md5sum] = "5110b11ce25dc57cd2e65a35f952dbf3"
SRC_URI[sha256sum] = "a97efe6d71de0544222d93b51568f65ab9746cf903c41253aa338f46556c9cb7"

do_install:append() {
    python3 - <<'PY'
from pathlib import Path

p = Path("${D}${base_libdir}/modules/${KV}/extra/hisi-ir.ko")

if not p.exists():
    print("SFX6008 RC patch: hisi-ir.ko not found, skipping")
else:
    data = p.read_bytes()

    patches = (
        (
            bytes.fromhex("a8 57 fa 05 3c 00 00 00"),
            bytes.fromhex("de 21 f8 07 3e 00 00 00"),
            "SERIES -> KEY_F4",
        ),
        (
            bytes.fromhex("b0 4f fa 05 3b 00 00 00"),
            bytes.fromhex("b6 49 f8 07 3d 00 00 00"),
            "IPTV -> KEY_F3",
        ),
    )

    changed = False

    for old, new, name in patches:
        if data.count(old) == 1:
            data = data.replace(old, new)
            print("SFX6008 RC patch: applied:", name)
            changed = True
        elif data.count(new) == 1:
            print("SFX6008 RC patch: already applied:", name)
        else:
            print("SFX6008 RC patch: pattern not found, skipping:", name)

    if changed:
        p.write_bytes(data)
PY
}
