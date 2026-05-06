# cloud-init metadata service

When a cloud VM boots, cloud-init doesn't get user-data magically — it fetches
it over HTTP from a link-local address the hypervisor exposes inside the guest.

On AWS, Azure, GCP, OpenStack, and most others that's `169.254.169.254`; on AWS
specifically, your user-data sits at `http://169.254.169.254/latest/user-data`.
That endpoint stays reachable for the entire lifetime of the instance, not just
at boot. So at any point later, anyone (or anything) running on the box can do:

```
curl http://169.254.169.254/latest/user-data
```

…and get back the exact YAML you supplied. If that YAML contains an
`ed25519_private` block, you've effectively put your host's private key in a
file readable by every process on the machine. Compromise a web app running as
`www-data`? It can read user-data. A container escape, a curl'd RCE, a
misbehaving cron job running as `nobody` — any of them can grab the host keys
and impersonate the server to clients trusting that fingerprint, or sit in the
middle of SSH sessions. The host private key is something only `root` should
ever be able to read (`/etc/ssh/ssh_host_*_key` is mode `0600`), and putting it
in user-data violates that.

## IMDSv2 helps, partially

AWS's IMDSv2 changes the metadata service from a plain GET to a two-step flow:
you first `PUT` to `/latest/api/token` to get a short-lived session token, then
send it as a header on subsequent GETs. Concretely:

```
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 60")
curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/user-data
```

What this stops is _blind SSRF_ — an attacker who tricks your app into making a
GET request to an arbitrary URL can no longer fetch metadata, because they can't
make the prerequisite `PUT`. What it does _not_ stop is a process actually
executing on the instance: that process can complete both steps just as easily
as the snippet above. So IMDSv2 closes one specific class of attack but doesn't
make user-data a safe place for secrets. Pair it with
`--http-put-response-hop-limit 1` so containers on the host can't reach it (the
TTL of 1 means the packet dies before crossing the docker bridge), and you can
also use iptables/nftables to restrict which UIDs are allowed to talk to
`169.254.169.254` — typically you'd allow only root and the cloud-init user.

GCP and Azure require specific headers (`Metadata-Flavor: Google`, `Metadata:
true`) which gives a small amount of similar SSRF protection, but again, doesn't
help against on-box readers.

## Vendor data

Cloud-init distinguishes user-data (set by you) from vendor-data (set by the
cloud provider or image builder). They're functionally similar but separate
channels, and on some platforms vendor-data is delivered through a path that's
harder for unprivileged processes to reach, or can be marked as consumed. It's
not a strong boundary on most clouds — treat it as "slightly more obscure"
rather than "secret" — but it can be a reasonable place for things like
vendor-specific bootstrap if your platform supports it well.

## The pattern that's actually safe: fetch at boot

Instead of embedding the keys, give the instance an identity (IAM role, managed
identity, service account) and have a tiny bootstrap script pull the keys from a
secret store on first boot. The user-data then contains only the _instructions_
to fetch, not the secret itself:

```yaml
#cloud-config
bootcmd:
  - |
    set -eu
    aws ssm get-parameter --name /hosts/web01/ssh_host_ed25519_key \
      --with-decryption --query Parameter.Value --output text \
      > /etc/ssh/ssh_host_ed25519_key
    aws ssm get-parameter --name /hosts/web01/ssh_host_ed25519_key.pub \
      --query Parameter.Value --output text \
      > /etc/ssh/ssh_host_ed25519_key.pub
    chmod 600 /etc/ssh/ssh_host_ed25519_key
    chmod 644 /etc/ssh/ssh_host_ed25519_key.pub
ssh_deletekeys: false
ssh_genkeytypes: []
```

`bootcmd` runs early enough that sshd hasn't started yet, so the keys are in
place before the first connection. Equivalents: GCP Secret Manager + the
instance's service account, Azure Key Vault + managed identity, or HashiCorp
Vault with cloud-auth. The benefits are that the secret never sits in user-data,
access is logged and revocable, you can rotate without rebuilding the AMI, and
IAM controls who can read it independently of who can SSH in.

## If you must embed them anyway

Sometimes (air-gapped images, no IAM available, simple single-host setup) the
secret-store pattern is overkill. In that case, at least:

- Use IMDSv2 with hop limit 1.

- Block `169.254.169.254` for non-root UIDs at the firewall once cloud-init
  finishes — a `runcmd` at the end like `iptables -A OUTPUT -d 169.254.169.254
  -m owner ! --uid-owner 0 -j REJECT` is the basic shape.

- On AWS, you can also clear user-data after boot by calling
  `modify-instance-attribute --user-data` from outside (it requires the instance
  to be stopped, so this is more useful for long-lived hosts where you can take
  a brief restart).

- Treat the host key as cattle: rotate them whenever an instance is rebuilt, and
  don't pin fingerprints across rebuilds anyway.

The short version: user-data is a _delivery_ channel, not a _storage_ channel.
It's fine for config, scripts, and references; it's a poor place for anything
you'd otherwise put in `/etc/ssh/ssh_host_*_key`.
