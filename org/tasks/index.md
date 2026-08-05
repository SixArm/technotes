# Org tasks

## TODO

TODO:

```org
* TODO A todo item.
```

DONE:

```org
* DONE A done item.
```

Aside: Org has special handling for the keywords TODO and DONE, and also can customize these.

### Priority

TODO with priority rank 1 to 9.

```org
* TODO [#1] A todo item.
```

TODO with priority rank A, B, C.

```org
* TODO [#A] A todo item.
```

Aside: Org has special handlig for priority to sort it. Priority can be any number 0-64 or any letter. Default is A, B, C.

### Progress

TODO with progress percent.

```org
* TODO A todo item. [20%]
```

TODO with progress counts.

```org
* TODO A todo item. [1/5]
```

Aside: Org has special handling for progress percent to auto-update it based on TODO children.

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

## Scheduled & Dealdine

Scheduled keyword:

```org
SCHEDULED: <YYYY-MM-DD Day>
```

Deadline keyword:

```org
DEADLINE: <YYYY-MM-DD Day>
```
