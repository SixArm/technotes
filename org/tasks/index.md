# Org tasks

## List

List items:

```org
* Call mom
* Walk dog
* Work out
```

## TODO & DONE

TODO prefix:

```org
* TODO Call mom
```

DONE prefix:

```org
* DONE Call mom
```

Org has special handling for the TODO prefix and DONE prefix, and also has ways you can customize these.

## Tag

Tag syntax:

```org
:foo:
```

Example:

```org
* TODO Call mom :important:
```

## Priority

Priority rank can use numbers such as 1 to 9.

```org
* TODO [#1] Call mom
* TODO [#2] Walk dog
* TODO [#3] Work out
```

Priority rank can use letters such as A to Z.

```org
* TODO [#A] Call mom
* TODO [#B] Walk dog
* TODO [#C] Work out
```

Org has special handling for priority to sort it. Priority can be any number 0-64 or any letter. Default is A, B, C.

## Sublists

Sublists use indentation like this:

```org
* TODO Work out
  * TODO Warm up
  * TODO Run laps
  * TODO Cool down
```

Org has special handling for nesting: you can use the tab to open a list and shut a list.

## Checklists

Checklists use a dash then braces like this:

```org
* TODO Work out
  - [ ] Warm up
  - [ ] Run laps
  - [ ] Cool down
```

When you're doing an item, add "-" like this first item:

```org
* TODO Work out
  - [-] Warm up
  - [ ] Run laps
  - [ ] Cool down
```

When you've done an item, add "x" like this first item:

```org
* TODO Work out
  - [x] Warm up
  - [ ] Run laps
  - [ ] Cool down
```

Org has special handling for checklists and checkboxes.

### Progress

Progress percent:

```org
* TODO Work out [33%]
  - [x] Warm up
  - [ ] Run laps
  - [ ] Cool down
```

Progress counter:

```org
* TODO Work out [1/3]
  - [x] Warm up
  - [ ] Run laps
  - [ ] Cool down
```

Org has special handling for progress auto-updates based on TODO children.

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

Timestamp range double-dash:

```org
<2004-08-23 Mon 10:00-11:00>--<2004-08-26 Thu 10:00-11:00>
```

Org has special handling for timing.

## Scheduled & Deadline

Scheduled keyword:

```org
SCHEDULED: <YYYY-MM-DD Day>
```

Deadline keyword:

```org
DEADLINE: <YYYY-MM-DD Day>
```

Org has special handling for these two words for agendas.

## Example: email list

```org
* TODO Send emails
  - [ ] alice@example.com
  - [ ] bob@example.com
  - [ ] carol@exmaple.com
```

## Example: user story checklist

```org
* TODO Try search
  - [ ] Given I see the search box
  - [ ] When I enter my search terms
  - [ ] Then I see the search results
```

## Example: shopping checklist

```org
* TODO Shop
  * Fruits
    - [ ] Apples
    - [ ] Bananas
  * Greens
    - [ ] Kale
    - [ ] Spinach
```

## Example: exercise checklist

```org
* TODO Exercise
  * Arms
    - [ ] Curls
    - [ ] Pushups
  * Legs
    - [ ] Jumps
    - [ ] Squats
```

## Example: meeting checklist

```org
* TODO Meet stakeholders
  * Before
    - [ ] Send invitations
    - [ ] Prepare materials
  * During
    - [ ] Start with purpose
    - [ ] Work toward outcomes
    - [ ] Finish with actions
  * After
    - [ ] Send followups
    - [ ] Track outcomes
```
