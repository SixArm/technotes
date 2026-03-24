# Codeberg and GitHub

I like using [codeberg.org](https://codeberg.com) for git hosting.

This page explains how I use Codeberg and GitHub together.

1. Sign up at Codeberg and GitHub. I prefer to use the same username on both sites.

2. Create a repo on Codeberg and GitHub. I prefer to use the same repo name on both sites.

3. Decide on using HTTPS or SSH. I prefer to use SSH because it's more powerful for multiple keys.

### Generate your SSH key

Generate a typical SSH key for Codeberg and another typical SSH key for GitHub.

I like to use the tool [ssh-keygen-pro](https://github.com/sixarm/ssh-keygen-pro)

```sh
ssh-keygen-pro
```

For site-specific user SSH keys, I like this naming convention:

```txt
codeberg-user-joelparkerhenderson
```

Example output files:

```stdout
codeberg-user-joelparkerhenderson=7aaea5d5aad09bc5ffd34bfe2a99a303=ssh-ed25519-with-automation
codeberg-user-joelparkerhenderson=7aaea5d5aad09bc5ffd34bfe2a99a303=ssh-ed25519-with-automation.pub
codeberg-user-joelparkerhenderson=7aaea5d5aad09bc5ffd34bfe2a99a303=ssh-ed25519-with-passphrase
codeberg-user-joelparkerhenderson=7aaea5d5aad09bc5ffd34bfe2a99a303=ssh-ed25519-with-passphrase.pub
```

### Put the SSH key where you want

I like to put the SSH key files in my existing SSH identity directory:

```sh
mv codeberg-user-* ~/.ssh/id.d
```

### Add the SSH key to Codeberg

Add the SSH to your Codeberg account via the Codeberg web interface.

Heads up: Codeberg currently has a 50-character limit on the SSH key name.

So when I save the SSH key to Codeberg, then I shorten the key name to just the unique secure random id:

```txt
7aaea5d5aad09bc5ffd34bfe2a99a303
```

### Repeat for GitHub

Do the same kind of process for GitHub: generate your SSH key, put it where you want, and add it to GitHub.

### Save the SSH keys

Save the SSH keys anywhere reliable, such as to your preferred password manager.

- I like to use [Bitwarden](https://bitwarden.com)

Heads up: Bitwarden has a buggy UI for creating an SSH key, so here's a workaround.

- The UI doesn't work on the Bitwarded web page, so use the Bitwarden desktop, not the Bitwarden web page.

- Click "+" and choose SSH key. You see Bitwarden generate a random SSH key. Save this, even though it's not what you want.

- Then edit the random SSH key. You see a new icon for clipboard paste.

- Copy your SSH key to the clipboard (dangerous) and click the Bitwarden clipboard past.

### Adjust SSH config

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

### Verify the SSH connections

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

## For each repo

### Edit .git/config

Edit your local repo file `.git/config`.

There are various ways to make a repo push to multiple upstream sites.

I prefer the way that uses `pushurl`.

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

Run:

```sh
git push
```

You should see two pushes: one to Codeberg, one to GitHub.
