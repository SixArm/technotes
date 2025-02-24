# Security tools

## SecLists

SecLists is a collection of multiple types of lists used during security assessments, collected in one place. List types include usernames, passwords, URLs, sensitive data patterns, fuzzing payloads, web shells, and many more. 

https://github.com/danielmiessler/SecLists


## Shodan

Shodan.io is a SaaS company that offers internet monitoring, including IP scanning to detect exposed services.

https://shodan.io

Sign up:

https://account.shodan.io/register

Do a Shodan scan of the IP address related to your organization.


## Burp Suite

Burp Suite software for security engineers and penetration testers.

https://portswigger.net/burp

Install via macOS brew:

```sh
brew install burp-suite
```

## Feroxbuster

Install:

```sh
cargo install feroxbuster
```

Get any wordlist you want, such as from SecLists Discovery Web-Content:

https://github.com/danielmiessler/SecLists/tree/master/Discovery/Web-Content

If you're new to feroxbuster and wordlists, then we suggest starting with the file that is the feroxbuster default wordlist: `raft-medium-directories.txt` like this:

```sh
wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-medium-directories.txt
```

Note that feroxbuster and the wordlist must be on the same physical partition in order to run.

Run:

```sh
feroxbuster \
--wordlist raft-medium-directories.txt \
--url https://www.example.com
```

If you're working on a project such as a web app, then you might want to copy this feroxbuster configuration template into your project:

* https://epi052.github.io/feroxbuster-docs/docs/configuration/ferox-config-toml/

