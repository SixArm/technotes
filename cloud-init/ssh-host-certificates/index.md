# SSH host certificates

SSH host certificates are the best modern solution for cloud-init VPS creation.

When a Certificate Authority (CA) signs each host's public key, then clients
trust the CA instead of memorising per-host fingerprints, and the only sensitive
material that ever needs to move is the host private key — which, as discussed,
ideally never leaves the box that generated it.

## How to do it

You do three things:

1. Create a Certificate Authority once.

2. Sign each new host's public key.

3. Tell clients to trust the Certificate Authority.

## Algorithm

Everything below assumes Ed25519, but the same flow works for RSA — just sign
the RSA pubkey with the same CA.

## 1. Create the CA (once)

The CA is just an SSH key pair you reserve for signing.

Generate it somewhere safe — ideally an offline machine, a Hardware Security Module (HSM), or a Vault transit key:

```
ssh-keygen -t ed25519 -f ~/ssh-ca/host_ca -C 'host CA'
```

The public key is `host_ca.pub` and you'll hand it to every client.

The private key is `host_ca` so guard it as a root credential.

<details>
    <summary>🛈</summary>

**"The CA is just an SSH key pair."**

In the X.509 / TLS world, "Certificate Authority" sounds like a thing —
software, a database of issued certs, configuration, OIDs, basic constraints,
lifecycle tooling. SSH has none of that ceremony. An SSH CA is, literally, a
regular SSH key pair. The moment you use a private key to sign somebody else's
public key with `ssh-keygen -s`, that key has _become_ a CA. There's no flag at
generation time that marks a key as "CA-capable," no certificate chain, no
intermediate authorities by default. Any Ed25519 or RSA key you generate today
could be used as a CA tomorrow.

This is why the generation command looks identical to generating a regular host
or user key — because it _is_ generating a regular key. The CA-ness is just how
you choose to use it.

**"Reserve for signing"**

Even though _technically_ any key can sign certs, you give the CA a dedicated
key pair and don't reuse it for anything else.

Two reasons:

1. The signing power of the CA private key is enormous — anyone who possesses it
   can mint a host certificate claiming to be any server in your fleet, or (for
   a user CA) a user certificate granting login as anyone. You want exactly one
   job associated with that key so you can lock it down hard. If the same key
   were _also_ your personal SSH login key, every laptop you've ever pulled it
   onto would now be in scope for "places the CA might leak from."

2. It also makes auditing tractable. "When was the CA used?" should have a
   small, verifiable answer — every signing event ideally logged, every cert
   issued accounted for. That's only possible if the key isn't doing other
   unrelated work.

**"Somewhere safe — offline, HSM, or Vault"**

Three concrete patterns, in roughly increasing operational sophistication:

_Offline machine_ is the simplest: a laptop or small computer that lives in a
drawer, isn't on the network most of the time, and gets booted only when you
need to sign new certs. You generate the CA on it, the private key never leaves
it, and signing happens by carrying public keys to it on a USB stick (or over a
temporarily-enabled network connection) and carrying signed certs back. Crude
but extremely effective for small fleets — the attack surface is "physical
access to the drawer."

_HSM_ (Hardware Security Module) is a tamper-resistant chip or appliance that
holds keys in hardware and exposes only signing operations through a defined
interface. Private keys are generated inside the HSM and provably can't be
exported. Options range from a $50 YubiHSM you plug into a USB port, to AWS
CloudHSM / Azure Managed HSM / GCP Cloud HSM as a cloud service, to dedicated
rack-mount appliances. OpenSSH's `ssh-keygen -s` can drive a PKCS#11 HSM via the
`-D /path/to/pkcs11.so` flag, so the workflow looks the same — you just can't
`cat` the private key.

_Vault transit/SSH key_ refers to HashiCorp Vault: its SSH secrets engine
specifically supports holding the CA private key and performing signing through
a REST API. Clients (or your bootstrapping VMs, per the previous discussion)
authenticate to Vault, post their public key, and get a signed cert back. The CA
private key is generated inside Vault and never exposed; access policies decide
which clients can request which principals. This is what most "sign on boot"
deployments end up using because it scales and audits cleanly.

The thread connecting all three: _the CA private key never lives in a location
where a single compromise gives an attacker the ability to mint arbitrary
certificates._ Offline machines achieve that physically; HSMs and Vault achieve
it cryptographically and via access control.

**The command itself**

```
ssh-keygen -t ed25519 -f ~/ssh-ca/host_ca -C 'host CA'
```

There's no `-N ''`. That means `ssh-keygen` will prompt you interactively for a
passphrase, and you should give it one. This is the opposite trade-off from a
host key — the CA key isn't read by an unattended daemon at boot, it's used by a
human (or controlled service) at signing time, so you can afford the extra
protection of an at-rest passphrase. If somebody steals the file, they still
need the passphrase to use it.

You'll also want `mkdir -p ~/ssh-ca && chmod 700 ~/ssh-ca` first, since
`ssh-keygen` will write the private key with `0600` permissions but won't
tighten the directory itself.

After it runs, you have two files:

- `~/ssh-ca/host_ca` — the private key, passphrase-encrypted, mode `0600`. This
  is the crown jewel.

- `~/ssh-ca/host_ca.pub` — the public key, one line of text, mode `0644`. This
  is what every client needs in order to verify certificates the CA signs. It's
  not sensitive; you can email it, commit it to a config repo, paste it into
  wikis. Distribution is via `@cert-authority` lines in `known_hosts`, or
  `TrustedUserCAKeys` in `sshd_config` for user CAs.

**"Guard it as a root credential"**

Possession of `host_ca` means: anyone who has it can issue a certificate that
makes any machine on the planet appear, to any client trusting your CA, to be a
legitimate member of your fleet. They can stand up a server, issue themselves a
cert with `web01.example.com` as a principal, and your engineers' SSH clients
will connect to it without warning and hand over agent forwarding, port
forwards, whatever. For a _user_ CA the equivalent is "issue a cert that logs in
as root anywhere." So the security posture isn't "an important key" — it's
"compromising this is equivalent to root on the entire fleet at once."

Practical consequences of that framing: passphrase-encrypted at rest, never on
shared filesystems, never in version control (not even private repos — those get
cloned to laptops), never in backups that aren't themselves encrypted with a
separately-managed key, and ideally not on disk in cleartext form at all (hence
HSM/Vault). When somebody leaves the team, rotate it the way you'd rotate a root
password they knew. When you suspect compromise, the recovery is "issue a new
CA, push the new public key to all clients, re-sign all hosts, declare the old
CA dead" — which is painful enough that it's worth designing the storage to make
compromise unlikely in the first place.

</details>

## 2a. The simple, embed-everything approach

Suppose a host `web01.example.com` and IP `203.0.113.10`.

Generate the host keys:

```bash
ssh-keygen \
  -t ed25519 \
  -N '' \
  -C 'web01' \
  -f web01_ed25519
```

<details>
<summary>🛈</summary>

The command generates a fresh SSH key pair in the current directory, tailored
for use as a server host key. Walking through it piece by piece:

`ssh-keygen` is the OpenSSH key-management tool — it generates, converts, signs,
and inspects keys.

`-t ed25519` picks the key algorithm. Ed25519 is an elliptic-curve scheme (EdDSA
over Curve25519) that's been the default recommendation for ~a decade now:
256-bit keys, fast signature operations, short public keys (about 68 ASCII
characters), and no historical baggage around parameter choice the way RSA and
ECDSA have. The other values you'd see are `rsa` (still fine at `-b 4096`,
slower, longer keys), `ecdsa` (smaller than RSA but uses NIST curves some people
avoid), and `ed25519-sk` / `ecdsa-sk` (hardware-backed via a FIDO2 token).

`-N ''` sets the _new_ passphrase to the empty string. Without this flag,
`ssh-keygen` prompts you interactively for a passphrase to encrypt the private
key on disk. The two single quotes enclose nothing — that's how you pass an
empty string from the shell. For a _host_ key this is mandatory: `sshd` starts
at boot and has no human around to type a passphrase, so the key has to be
unencrypted at rest. The protection comes from filesystem permissions (`0600`,
owned by root) instead. For a _user_ key you'd usually omit `-N` and pick a real
passphrase, or use `ssh-agent` to cache the unlocked key in memory.

`-C 'web01'` sets the comment field — a free-form string that gets tacked onto
the end of the public-key line. It's purely cosmetic and shows up when you `cat
web01_ed25519.pub`:

```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI…oQk web01
```

The default if you don't pass `-C` is `user@hostname` of whatever machine you
ran the command on, which is rarely what you want for a key destined for a
_different_ host. Setting it to `web01` (or `root@web01`, or
`web01.example.com`) just makes keys easier to identify in logs and
`authorized_keys` files later. It has no effect on cryptography or
authentication.

`-f web01_ed25519` is the output path. `ssh-keygen` writes _two_ files based on this:

- `web01_ed25519` — the private key, mode `0600`, contains the actual secret material.

- `web01_ed25519.pub` — the public key, mode `0644`, one line of text safe to share.

Without `-f` the tool defaults to `~/.ssh/id_<type>` (here `~/.ssh/id_ed25519`)
and prompts before overwriting. Specifying `-f` with a relative name like this
drops the files in your current working directory, which is what you want when
you're staging keys for a new host before pasting them into user-data or
shipping them somewhere.

So the net effect: two files in the current directory, an unencrypted Ed25519
private key and its matching public key labeled "web01", produced
non-interactively (no prompts), ready to be deployed as
`/etc/ssh/ssh_host_ed25519_key{,.pub}` on the target server.

</details>

Sign the host keys locally:

```sh
ssh-keygen \
  -s ~/ssh-ca/host_ca \
  -I web01.example.com \
  -h \
  -n web01.example.com,web01,203.0.113.10 \
  -V +5w \
  web01_ed25519.pub
```

<deetails>
    <summary>🛈</summary>

That's the signing command — same `ssh-keygen` binary as before, but in a completely different mode. The presence of `-s` flips it: instead of generating a new key pair, the tool reads an existing public key, signs it with the CA's private key, and writes out a certificate. Walking through each flag:

**`-s ~/ssh-ca/host_ca`** — the CA private key to sign with. This is the file you generated in the "create the CA" step. Its public counterpart (`host_ca.pub`) plays no role here; that's what you'll later distribute to clients so they can verify certificates this command produces. Note this is the _only_ place in the whole workflow that the CA private key gets touched — which is why people put it on an offline machine, in a hardware token, or behind a signing service that exposes only "sign this pubkey, don't give me the CA key."

**`-I web01.example.com`** — the _key identity_, a free-form label baked into the certificate. It has no semantic meaning to SSH itself, but `sshd` writes it to the auth log on every connection that uses the cert:

```
Accepted publickey for root from 1.2.3.4 … ID web01.example.com (serial 0) CA ssh-ed25519 SHA256:…
```

Make it unique and meaningful per certificate — typically the FQDN of the host, sometimes with a serial or timestamp suffix. When something goes wrong months later, this is how you trace which signed cert was actually being used.

**`-h`** — make this a _host_ certificate, not a user certificate. This single flag flips which side of the SSH handshake the cert authenticates: with `-h`, the cert proves "this is server X" to clients; without it, you'd be making a user cert that proves "this is user Y" to servers. Same tool, same flags, completely different role. Forgetting `-h` is the single most common signing mistake — you'll cheerfully sign a host's pubkey, deploy it, and watch sshd refuse to load it because it's the wrong cert type.

**`-n web01.example.com,web01,203.0.113.10`** — the _principals_ list. For host certs, this is the set of hostnames and IPs the certificate is valid for. When a client connects, OpenSSH checks the name the user typed (`ssh web01.example.com`, or `ssh 203.0.113.10`) against this list — if it doesn't match any principal, the cert is rejected even though the signature is perfectly valid. So include every name a client might reasonably use: the FQDN, the short hostname, the public IP, any internal IPs, CNAMEs, load-balancer names. Comma-separated, no spaces. (For _user_ certs the same flag means something different — there it lists the Unix usernames the cert is allowed to log in as. The flag name is shared, the semantics depend on `-h`.)

**`-V +5w`** — validity window. `+5w` is shorthand for "valid from now until five weeks from now." The format is flexible:

- `+52w` — from now to 52 weeks out
- `-1h:+5w` — from one hour ago to five weeks from now (the negative offset gives a small grace window for clock skew between CA and host)
- `20260601:20260801` — absolute dates (`YYYYMMDD`)
- `always:forever` — no validity bounds; don't do this, expiry _is_ your revocation mechanism

Short windows are the whole point. A week or two for auto-renewing fleets is typical; anything over a few months and you've reinvented the long-lived key problem the CA was supposed to solve.

**`web01_ed25519.pub`** — the public key to sign. Critical detail: _only_ the public key. The private key never leaves the host that owns it, the CA never sees it, the signing operation only needs the public half. This is what makes "sign on boot" safe — the new VPS generates its own keypair, sends only the `.pub` over the network, and gets back a cert that binds that pubkey to a set of principals and a validity window. The secret material stays put.

**The output**

`ssh-keygen` writes the certificate next to the input as `web01_ed25519-cert.pub` — same directory, same base name, `-cert` inserted before `.pub`. That's the filename `sshd` expects when you point a `HostCertificate` directive at it.

You can inspect what you just produced:

```
ssh-keygen -L -f web01_ed25519-cert.pub
```

…which prints something like:

```
web01_ed25519-cert.pub:
        Type: ssh-ed25519-cert-v01@openssh.com host certificate
        Public key: ED25519-CERT SHA256:7H…
        Signing CA: ED25519 SHA256:Kp… (using ssh-ed25519)
        Key ID: "web01.example.com"
        Serial: 0
        Valid: from 2026-05-06T12:00:00 to 2026-06-10T12:00:00
        Principals:
                web01.example.com
                web01
                203.0.113.10
        Critical Options: (none)
        Extensions: (none)
```

The fields map 1-to-1 to the flags you passed: `Key ID` = `-I`, `Principals` = `-n`, `Valid` = `-V`, `Signing CA` = the public counterpart of `-s`, "host certificate" = `-h`. Always run `-L` once before deploying, just to confirm you got `-h` right.

**A few things that aren't obvious from the flag list**

The certificate and its underlying public key are independent files. The cert is meaningless without the matching private key on the host, but the private key still works as an ordinary SSH key whether or not a cert is ever issued for it. The cert just _adds_ CA-signed identity on top.

There's a `-z <serial>` flag you didn't pass, defaulting to 0. Serial numbers are how key revocation lists (KRLs) identify certs to revoke, so if you ever need to revoke before expiry, you'll wish you'd been numbering them. A monotonic counter or unix timestamp at signing time both work fine.

If your CA is RSA rather than Ed25519, add `-t rsa-sha2-512` to the signing command. Otherwise `ssh-keygen` defaults to producing an `ssh-rsa` (SHA-1) signature, which modern OpenSSH versions refuse to verify — your perfectly-signed certs will silently fail on recent clients. Doesn't apply here because the CA is Ed25519, but it bites people who set up an RSA CA years ago.

So in plain English, the whole command reads as: _"Using my CA private key at `~/ssh-ca/host_ca`, sign the host public key in `web01_ed25519.pub`, label the resulting certificate `web01.example.com`, mark it as a host certificate, declare it valid for connections to those three names/IPs, and let it expire in five weeks."_

</details>

That produces `web01_ed25519-cert.pub`.

Now drop the lot into user-data:

```yaml
#cloud-config
ssh_keys:
  ed25519_private: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    …contents of web01_ed25519…
    -----END OPENSSH PRIVATE KEY-----
  ed25519_public: ssh-ed25519 AAAA… web01
  ed25519_certificate: ssh-ed25519-cert-v01@openssh.com AAAA…
```

Cloud-init writes the three files to `/etc/ssh/ssh_host_ed25519_key{,.pub,-cert.pub}` and adds `HostCertificate /etc/ssh/ssh_host_ed25519_key-cert.pub` to `sshd_config` automatically. Easy, but inherits the user-data exposure problem from before — the private key is sitting in the metadata service.

**2b. The better approach: sign on boot**

Let cloud-init do its default thing and _generate_ fresh host keys on the new VPS. The public key isn't sensitive, so the instance can hand it to a signing service and get a cert back. The CA private key never leaves the signer; the host private key never leaves the host.

```yaml
#cloud-config
runcmd:
  - |
    set -eu
    HOST=$(hostname -f)
    for t in ed25519 rsa; do
      pub=/etc/ssh/ssh_host_${t}_key.pub
      [ -f "$pub" ] || continue
      curl -sS --fail \
        -H "Authorization: Bearer $(curl -sS -H 'Metadata-Flavor: Google' \
             http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/identity?audience=ssh-ca)" \
        --data-binary @"$pub" \
        "https://ca.example.com/sign?host=${HOST}" \
        -o /etc/ssh/ssh_host_${t}_key-cert.pub
      chmod 644 /etc/ssh/ssh_host_${t}_key-cert.pub
      echo "HostCertificate /etc/ssh/ssh_host_${t}_key-cert.pub" \
        >> /etc/ssh/sshd_config
    done
    systemctl reload sshd
```

(Replace the GCP metadata bit with whatever your platform offers — AWS instance identity document, Azure managed identity token, an OIDC provider, mTLS with a bootstrap cert, etc. The point is the signing service authenticates the _instance_, validates the requested principals against what it actually knows about that instance, and only then signs.)

For the signing service itself, three sensible options rather than rolling your own:

- **Smallstep `step-ca`** has first-class SSH host cert support and built-in provisioners for OIDC, AWS/GCP/Azure instance identity, X5C, and JWK. This is what most people should use.
- **HashiCorp Vault**'s SSH secrets engine: configure a host-signing role, then the instance does `vault write ssh-host-signer/sign/host public_key=@/etc/ssh/ssh_host_ed25519_key.pub` after authenticating with the cloud-auth method.
- A 50-line homegrown service that wraps `ssh-keygen -s` is fine if your needs are simple — but you have to think carefully about who's allowed to request a cert for which principals.

**3. Client trust**

None of this matters until clients trust the CA. Drop one line into `~/.ssh/known_hosts` (or `/etc/ssh/ssh_known_hosts` system-wide):

```
@cert-authority *.example.com ssh-ed25519 AAAA…contents of host_ca.pub…
```

The `@cert-authority` marker means "any host presenting a certificate signed by this key, whose principals match the pattern, is trusted." From now on, `ssh web01.example.com`, `ssh web47.example.com`, anything new your CA signs — no prompts, no fingerprint emails to the team, no stale entries when you rebuild a box.

Inspect a cert any time with:

```
ssh-keygen -L -f web01_ed25519-cert.pub
```

…which prints principals, validity window, key ID, critical options, and the signing CA's fingerprint.

**Operational notes that bite people**

Short lifetimes are the point. Issue certs valid for days or a few weeks and have hosts re-sign on a timer (`systemd` timer running the same `runcmd` snippet). Expiry is your revocation mechanism — if a host is compromised, its cert dies on its own and you don't need to push KRLs. If you do need explicit revocation, `ssh-keygen -k` builds a key revocation list and `RevokedKeys /etc/ssh/krl` in `sshd_config`/client config consumes it.

Match algorithms: sign an Ed25519 host key with… anything, but if your CA is RSA and you're signing RSA host keys, pass `-t rsa-sha2-512` to `ssh-keygen -s` so you don't end up with an `ssh-rsa` (SHA-1) signature that modern OpenSSH refuses.

Principals are checked against what the _client typed_, not what the server is actually called. If users connect by IP sometimes, include the IP in `-n`. If you're behind a load balancer, sign every backend with the LB's hostname as a principal and clients won't care which one they hit.

Finally, this composes cleanly with user certificates — same CA setup, drop `-h`, sign user public keys, and put `TrustedUserCAKeys /etc/ssh/user_ca.pub` in `sshd_config`. At that point you've replaced both `known_hosts` churn and `authorized_keys` distribution with a single signing flow, which is the real prize.
