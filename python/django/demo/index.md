# Demo Django

https://docs.djangoproject.com/en/5.1/intro/tutorial01/

## Prequisites

Get the Python programming language any way you wish, such as via mise:

```sh
mise use python@latest
```

Get the Postgres database any way you wish, such as via mise:

```sh
mise use postgres@latest
```

Get the Django web framework any way you wish, such as via pip:

```sh
python -m pip install Django
```

Create top directory that will contain the project:

```sh
mkdir demo_django
```

Create project:

```sh
django-admin startproject mysite demo_django
```

Migrate:

```sh
python manage.py migrate
```

Create app:

```sh
python manage.py startapp polls
```