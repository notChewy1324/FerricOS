# ferric-keyring — key material needed

This package is a scaffold. It builds once these three files exist here
(they are the standard Arch keyring layout):

```bash
# 1. the public key (binary export, NOT armored)
gpg --export YOUR_KEY_ID > ferric.gpg

# 2. the trust file: fingerprint + trust level 4 (marginal owner-trust)
echo "YOUR_40_CHAR_FINGERPRINT:4:" > ferric-trusted

# 3. revoked-keys file (empty for now)
touch ferric-revoked
```

Then:
1. Build + publish like any other ferric package.
2. On the ISO/installed systems, install `ferric-keyring` BEFORE flipping
   `[ferric]` SigLevel to `Required DatabaseOptional` in
   `profile/pacman.conf` AND `profile/airootfs/etc/pacman.conf`.
3. Start signing: `makepkg --sign`, `repo-add --sign`, and add the key
   import step to `.github/workflows/build-packages.yml` (GPG private key
   + passphrase as repo secrets `FERRIC_GPG_KEY` / `FERRIC_GPG_PASSPHRASE`).
