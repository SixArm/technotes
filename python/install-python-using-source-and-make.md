# Install Python using source and make

Install python from source into a user directory that is version specific:

```sh
version=3.11.10
wget https://www.python.org/ftp/python/$version/Python-$version.tgz
tar -xf Python-$version.tgz 
cd Python-$version
printf "*disabled*\n_tkinter\n" >> Modules/Setup
./configure --prefix="$HOME/opt/python/$version/" &&
make && 
make test && 
make install
```

Troubleshooting:

* If `make test` fails due to peg, then this could be because there's a conflict with setuptools, such as if there's another python installation on the system, thus another setuptools. 

* The only solution that seems to work reliably is to delete the other python installation, then retry `make test`. 

* We welcome advice about how to isolate `make test` from other python installations.

Create links for consistency:

```sh
cd "$HOME/opt/python/$version/bin"
ln -sfn idle3.11 idle
ln -sfn pydoc3.11 pydoc
ln -sfn python3.11 python
ln -sfn python3.11-config python-config
```

Add to start of path:

```sh
export PATH="$HOME/opt/python/$version/bin:$PATH"
```

Verify:

```sh
which python3.11
```

Output:

```txt
~/opt/python/3.11.10/bin/python
```

### pip

Run:

```sh
python -m ensurepip --upgrade
```

Troublethooting: 

* There can be unexpected warnings if there are similar versions of dependencies that are installed elsewhere, such as if there's another python installation on the system, thus another setuptools and another pip. 

* Example warnings: "Requirement already satisfied: setuptools in ~/.local/lib/python3.11/site-packages (65.5.0)" or "Requirement already satisfied: pip in ~/.local/lib/python3.11/site-packages (24.3.1)"

* The only solution that seems to work reliably is to delete the other python installation, then retry. 

Verify:

```sh
python -m pip --version
```

Output:

```txt
pip 24.0 from ~/opt/python/3.11.10/lib/python3.11/site-packages/pip (python 3.11)
```

➜ pip3.11 install --upgrade pip
➜ python3.11 -m pip --version   
pip 24.3.1 from /Users/jph/.local/lib/python3.11/site-packages/pip (python 3.11)

## pipx

Run:

```sh
python -m pip install pipx
python -m pipx --version   
```

Output:

```sh
1.7.1
```

### poetry

Run:

```sh
python -m pip install poetry
python -m poetry --version
```

Output:

```txt
Poetry (version 1.8.4)
```

poetry lock --no-update 


