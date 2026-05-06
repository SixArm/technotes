# cloud-init host keys

In cloud-init user data, you provide host keys through the `ssh_keys` key in a `#cloud-config` document. The `cc_ssh` module picks them up early in boot and writes them to `/etc/ssh/ssh_host_*_key{,.pub}` instead of generating fresh ones.

```yaml
#cloud-config
ssh_keys:
  ed25519_private: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAA...
    -----END OPENSSH PRIVATE KEY-----
  ed25519_public: ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... root@host
  rsa_private: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAA...
    -----END OPENSSH PRIVATE KEY-----
  rsa_public: ssh-rsa AAAAB3NzaC1yc2EAAAADAQAB... root@host
```

A few things worth knowing:

The supported key-type prefixes are `rsa`, `dsa`, `ecdsa`, and `ed25519` (and on newer cloud-init, `ecdsa_sk` / `ed25519_sk`). For each you can supply `_private`, `_public`, and optionally `_certificate` (for signed host certs).

The private key must be a YAML literal block (`|`) so the newlines survive intact — OpenSSH will reject the key otherwise. The public-key line is a single line and doesn't need the block scalar.

Generate the pair beforehand with something like `ssh-keygen -t ed25519 -N '' -f ./host_ed25519 -C root@host`, then paste the contents of `host_ed25519` into `_private` and `host_ed25519.pub` into `_public`.

Two related options you may also want in the same cloud-config:

```yaml
ssh_deletekeys: true       # default; deletes any pre-baked keys from the image first
ssh_genkeytypes: []        # prevent cloud-init from generating extra types you didn't supply
```

Be aware user data is readable to anything that can hit the instance metadata service (e.g. `http://169.254.169.254/...`) from inside the VM, so embedding host *private* keys there means any process on the box can read them. On clouds that support it, prefer vendor data, an encrypted datasource, or fetching the keys from a secret store in a `bootcmd`/`runcmd` step instead — and lock down metadata access (IMDSv2 on AWS, etc.).