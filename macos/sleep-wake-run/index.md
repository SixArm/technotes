# Sleep + wake + run

To sleep, then wake, then run, here are the three commands to use.

Step 1. Use the command `at` to schedule anything you want:

```sh
echo "claude CLAUDE.md" | at 01:02
```

Step 2. Use the command `pmset` to set a wake or power on every day:

```sh
sudo pmset repeat wakeorpoweron MTWRFSU 01:00:00
```

Step 3. Use the command `pmset` to sleep now:

```sh
sudo pmset sleepnow
```

See also: <https://github.com/sixarm/mac-nap>
