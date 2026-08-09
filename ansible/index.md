# Ansible notes

Add user:

```ansible
- name: Add the user 'alice' with a home directory, bash shell, groups, SSH key, etc.
  ansible.builtin.user:
    name: alice
    create_home: yes
    skeleton: /etc/skel
    shell: /bin/bash
    group: staff
    groups: developers,testers
    append: yes
    generate_ssh_key: yes
    ssh_key_bits: 4096
    ssh_key_file: .ssh/id_rsa
```

Add users via loop:

```ansible
- name: Add users
    name: "{{ item }}"
    …
  loop:
     - alice
     - bob
```

Add users via loop and text file:

```ansible
- name: Add users
    name: "{{ item }}"
    …
    loop: "{{ lookup('ansible.builtin.file', file_path).splitlines() }}"
    when: 
      - item | trim | length > 0
      - not item.startswith('#')
```
