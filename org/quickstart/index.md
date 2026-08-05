# Org Mode Quick Start

## Quick examples

Contact:

```org
* Alice Adams
:properties:
:email: alice@example.com
:phone: 1-800-555-5555
:end:
:note:
This text can be
on multiple lines
:end
```

Todo:

```org
* TODO Lorem Ipsum [/]
- [ ] Alpha
- [ ] Bravo
- [ ] Charlie
```

## Preamble

```org
#+title: Hello World
#+author: Alice Adams
#+tags: alfa bravo charlie
```

## Headlines

```org
* Headline 1
** Headline 2
*** Headline 3
```

## Markers

| Tag | `:hello:` |
| Bold | `*hello*` |
| Italic | `/hello/` |
| Underline | `_hello_` |
| Strikethrough | `+hello+` |
| Code | `~hello~` |
| Verbatim | `=hello=` |

### Context tags

Use tags to assign physical contexts or resource requirements to your tasks (e.g., :email:, :office:, :home:, :calls:).

## References

### Link

```org
[[https://org.mode][Org]]
```

### Image

```org
[[https://example.com/image.jpg]]
```

## Lists

Orderless:

```org
- Alfa
- Bravo
- Charlie
```

Ordered:

```org
1. Alfa
2. Bravo
3. Charlie
```

Check List:

```org
- [ ] Alfa work ready to do
- [-] Bravo work in progress
- [x] Charlie work complete
```

## Table

```org
| x | x | x |
|---|---|---|
| x | x | x |
| x | x | x |
```

## Drawer

```org
:DRAWERNAME:
This is inside the drawer.
:END:
```

### Properties drawer

Properties are key-value pairs associated with an entry. They live in a special drawer with the name ‘PROPERTIES’. Each property is specified on a single line, with the key (surrounded by colons) first, and the value after it:

```org
:PROPERTIES:
:Title: Antigone
:Author: Sophocles
:END:
```

## Begin-End

### Comment

```org
#+BEGIN_COMMENT
Think of the circularity as posing a sort
of koan, whose contemplation may ultimately
yield a higher spiritual awareness."
#+END_COMMENT
```

### Center

```org
#+BEGIN_CENTER
Nature is an infinite sphere
of which the center is everywhere
and the circumference nowhere.
#+END_CENTER
```

### Quote

```org
#+BEGIN_QUOTE
Everything should be made
as simple as possible,
but not any simpler.
- Albert Einstein
#+END_QUOTE
```

### Verse

```org
#+BEGIN_VERSE
I write, erase, rewrite
Erase again, and then
A poppy blooms.
- Katsushika Hokusai
#+END_VERSE
```

### Source

```org
#+BEGIN_SRC rust
fn main() {
    println!("Hello, world!");
}
#+END_SRC
```
