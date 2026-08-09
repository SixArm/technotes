# query-replace-regexp downcase

Disable case-replace helper:

```emacs
M-x set-variable RET case-replace RET nil RET
```

Query:

```
M-x query-replace-regexp
Search: \(\w+\)
Replace: \,(downcase \1)
```

Optionlly enable case-replace helper:

```emacs
M-x set-variable RET case-replace RET t RET
```
