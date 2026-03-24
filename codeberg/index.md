# Codeberg

### Generate SSH keys

Generate a typical SSH key set such as:

```sh
ssh-keygen-pro
```

For Codeberg user SSH keys, we prefer this naming convention:

```txt
codeberg-user-joelparkerhenderson
```

Example output files:

```stdout
codeberg-user-joelparkerhenderson=7aaea5d5aad09bc5ffd34bfe2a99a303=ssh-ed25519-with-automation
codeberg-user-joelparkerhenderson=7aaea5d5aad09bc5ffd34bfe2a99a303=ssh-ed25519-with-automation.pub
codeberg-user-joelparkerhenderson=7aaea5d5aad09bc5ffd34bfe2a99a303=ssh-ed25519-with-passphrase
codeberg-user-joelparkerhenderson=7aaea5d5aad09bc5ffd34bfe2a99a303=ssh-ed25519-with-automation.pub
```

We prefer moving them to our existing SSH identity directory:

```sh
mv codeberg-user-* ~/.ssh/id.d
```

### Save SSH keys to Bitwarden

Codeberg currently has a 50-character limit on the SSH key name.

When we save the SSH key to Bitwarden, then we choose the name as the random info only:

```txt
7aaea5d5aad09bc5ffd34bfe2a99a303
```

### SSH config

Edit `~/.ssh/config`:

```config
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/your-github-key
    IdentitiesOnly yes

Host codeberg.org
    HostName codeberg.org
    User git
    IdentityFile ~/.ssh/your-codeberg-key
    IdentitiesOnly yes
```

### Git config

Edit your file `.git/config`.

If you use HTTPS, then add the lines `pushurl` like this:

```toml
[remote "origin"]
    url = https://github.com/user/repo.git
    pushurl = https://github.com/user/repo.git
    pushurl = https://codeberg.org/user/repo.git
    fetch = +refs/heads/*:refs/remotes/origin/*
```

If you use SSH, then add the lines `pushurl` like this:

```toml
[remote "origin"]
    url = git@github.com:user/repo.git
    pushurl = git@codeberg.org:c/repo.git
    pushurl = git@github.com:user/repo.git
    fetch = +refs/heads/*:refs/remotes/origin/*
```

### Verify

```sh
ssh -T git@codeberg.org
ssh -T git@github.com
```

Prompt:

```sh
The authenticity of host 'codeberg.org (217.197.84.140)' can't be established.
ED25519 key fingerprint is: SHA256:mIlxA9k46MmM6qdJOdMnAQpzGxF4WIVVL+fj+wZbw0g
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```
