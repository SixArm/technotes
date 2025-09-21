# Firefox full screen view hide scroll bars

Go to:

```
about:config
```

FInd the entry:

```
toolkit.legacyUserProfileCustomizations.stylesheets
```

Set it to true.

Go to:

```txt
about:support
```

Find the entry:

```
Profile Folder
```

Click the button to show the folder.

Create directory "chrome" and open it.

Create file "userContent.css" and edit it.

CSS:

```css
:root{ scrollbar-width: none }
```

Restart Firefox.

If you also want to hide scrollbars tthat would be in other scrollable frames then you can do it,  but be aware that without any scrollbars you won't be able to see if frames are scroallble or not:

```css 
*{ scrollbar-width: none }
```


