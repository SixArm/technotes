
# GitHub Settings: SSH key + GPG key + Vigilant mode

This page helps you set up a new GitHub account:

* Add GitHub as a known host

* Create your SSH key

* Create your GPG key

* Enable Vigilant mode


## Add GitHub as a known host

Run:

```sh
echo 'github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl' >> "$HOME/.ssh/known_hosts"
```

## Create your SSH key

Be sure you understand this help page: 
https://docs.github.com/en/authentication/connecting-to-github-with-ssh


Run this with your own email address:

```sh
export EMAIL=''
ssh-keygen -t ed25519 -C "example@example.com" 
cat ~/.ssh/id_ed25519.pub
```

Visit https://github.com/settings/keys

Add your SSH key.


## Create your GPG key

Be sure you understand this help page: 
https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key


Run:

```sh
gpg --full-generate-key
```

Please select what kind of key you want:

  * ECC (sign and encrypt)

Please select which elliptic curve you want:

  * Curve 25519

Please specify how long the key should be valid:

  * 1y [IMPORTANT-- Do not choose 0, because the SOC 2 will commit to expiring keys]

For the rest of the choices, use your professional name, email address, etc.

Output looks like this:

```sh
pub   ed25519 2025-03-02 [SC] [expires: 2026-03-02]
      92852F0416824F3A39C96F091E255CE2B76DE065
uid                      Joel Henderson <joel@heron-ai.com>
sub   cv25519 2025-03-02 [E] [expires: 2026-03-02]
```

List the secret key:

```sh
gpg --list-secret-keys --keyid-format=long
```


## Add Vigilant mode

Visit your GitHub settings:
https://github.com/settings/keys

See the section "Vigilant mode".

Check the box "Flag unsigned commits as unverified".

