# Org Mode Quick Start

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

| Tag           | `:hello:` |
| Bold          | `*hello*` |
| Italic        | `/hello/` |
| Underline     | `_hello_` |
| Strikethrough | `+hello+` |
| Code          | `~hello~` |
| Verbatim      | `=hello=` |

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

## TODO & DONE

TODO:

```org
**** TODO A todo item.
```

DONE:

```org
**** DONE A done item.
```

## Time

Timestamp:

```org
<2006-11-02 Thu>
```

Timestamp with time:

```org
<2006-11-02 Thu 10:00>
```

Timestamp with time range:

```org
<2006-11-02 Thu 10:00-12:00>
```

Timestamp with repeater each week:

```org
<2006-11-02 Thu 10:00 +1w>
```

Timestamp range:

```org
<2004-08-23 Mon 10:00-11:00>--<2004-08-26 Thu 10:00-11:00>
```

Deadline:

```org
DEADLINE: <YYYY-MM-DD Day>
```

Scheduled:

```org
SCHEDULED: <YYYY-MM-DD Day>
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
