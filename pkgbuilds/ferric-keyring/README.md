```text
┌────────────────────────────────────────────────────┐
│  ferric-keyring            ░░ NO KEY LOADED ░░     │
│  trust root for the [ferric] pacman repo           │
│  status: SCAFFOLD — waiting on key material        │
└────────────────────────────────────────────────────┘
```

> [!WARNING]
> This package is a **scaffold** — it does not build yet. The key slot is empty.
> Once the three files below exist here, it builds and publishes like any other `ferric-*` package.

## <samp>// key material needed</samp>

The three files follow the standard Arch keyring layout:

```bash
# 1. the public key (binary export, NOT armored)
gpg --export YOUR_KEY_ID > ferric.gpg

# 2. the trust file: fingerprint + trust level 4 (marginal owner-trust)
echo "YOUR_40_CHAR_FINGERPRINT:4:" > ferric-trusted

# 3. revoked-keys file (empty for now)
touch ferric-revoked
```

| file | contents | format |
|---|---|---|
| `ferric.gpg` | the public key | binary export, **not** armored |
| `ferric-trusted` | `FINGERPRINT:4:` | 40-char fingerprint, owner-trust 4 (marginal) |
| `ferric-revoked` | revoked key IDs | empty for now |

## <samp>// arming sequence</samp>

Order matters — flipping SigLevel before the keyring lands bricks `[ferric]` installs.

- [ ] **1 · Build + publish** like any other ferric package.
- [ ] **2 · Install first, then trust** — on the ISO and installed systems, install `ferric-keyring` **before** flipping `[ferric]` SigLevel to `Required DatabaseOptional` in `profile/pacman.conf` **and** `profile/airootfs/etc/pacman.conf`.
- [ ] **3 · Start signing** — `makepkg --sign`, `repo-add --sign`, and add the key-import step to `.github/workflows/build-packages.yml` (GPG private key + passphrase as repo secrets `FERRIC_GPG_KEY` / `FERRIC_GPG_PASSPHRASE`).

---

<div align="center">
<sub><samp>REC ● &nbsp;·&nbsp; unsigned tape plays, but you can't trust the label &nbsp;·&nbsp; Fe₂O₃</samp></sub>
</div>
