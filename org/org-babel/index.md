# org-babel

## Outcomes

Org Babel lets you display a code block outcome in these ways:

- `:results output` = show the standard output

- `:results value` = show the return value

- `:exports code`: show the source code

- `:exports results :results output`: show the standard output

- `:exports results :results value`: show the return value

- `:exports both :results output` = show the source code and the standard output

- `:exports both :results value` = show the source code and the return value

## JSON

```org
#+begin_src json
{
  "fruit": "apple",
  "color": "red"
}
#+end_src
```

JSON with pretty wrap:

```org
#+begin_src shell :results output :wrap src json
echo '{"fruit":"apple","color":"red"}'
#+end_src

#+RESULTS:
{
  "fruit": "apple",
  "color": "red"
}

```

## Python

```org
#+begin_src python :results output
print("Hello")
#+end_src

#+RESULTS:
: Hello
```

Python with a persistent session across blocks:

```org
#+begin_src python :session mysession :results silent
x = 42
#+end_src

#+begin_src python :session mysession :results value
return f"{x}"
#+end_src

#+RESULTS:
: 42
```

Python with input table and output value:

```org
#+NAME: fruits

| Item    | Quantity |
| ------- | -------- |
| Apples  | 2        |
| Bananas | 3        |

#+begin_src python :var data=fruits :results value
count = sum(row[1] for row in data)
return f"Count: {total_items}"
#+end_src

#+RESULTS:
: Count: 5
```

## Rust

```org
#+begin_src rust :exports both :results output
fn main() {
    println!("Hello");
}
#+end_src
```

#+RESULTS:
: Hello

````

## PostgreSQL

```org
#+begin_src sql :engine postgresql :dbhost localhost :dbuser postgres :database my_database
SELECT id, username, email
FROM users
LIMIT 3;
#+end_src

#+RESULTS:

| id | username | email           |
|----+----------+-----------------|
|  1 | alice    | alice@email.com |
|  2 | bob      | bob@email.com   |
|  3 | charlie  | char~@email.com |
````

If you plan to run multiple blocks against the same database, avoid repeating connection parameters by defining a global #+PROPERTY header at the top of your file:

```org
#+PROPERTY: header-args:sql :engine postgresql :dbhost localhost :dbuser postgres :dbpassword my_secret_pass :database dev_db :dbport 5432
```

```org
#+begin_src sql
SELECT count(*)
FROM users;
#+end_src

#+begin_src sql
SELECT id, username, email
FROM users
LIMIT 3;
#+end_src
```

## PlantUML

```org
#+begin_src plantuml
@startuml
skinparam monochrome true
Alpha -> Bravo
@enduml
#-end_src
```
