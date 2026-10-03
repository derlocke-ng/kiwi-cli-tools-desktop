# kiwi-cli-tools-desktop

Three small CLI helpers for a Linux desktop. Installable with
[kiwi-updater](https://github.com/derlocke-ng/kiwi-updater) — or standalone
with `./install.sh install`, which puts them in `~/.local/bin`.

## pweb

Serve the **current directory** over HTTPS on a random free port — for
handing a file to another machine on the same network without setting
anything up.

```
$ cd ~/Downloads && pweb
serving /home/you/Downloads
on https://yourhost:40123  (also https://localhost:40123)
```

A self-signed certificate is generated on first run (needs `openssl`) and
reused afterwards, so the browser warning happens once per machine. It serves
to the whole LAN: start it in the directory you mean to share, stop it with
Ctrl+C when done.

## select-server

A numbered menu of every concrete `Host` alias in your `~/.ssh/config`; pick
one and it connects. Wildcard patterns are skipped, aliases are de-duplicated
and sorted. A different config file can be given as the first argument.

```
$ select-server
1) backup    3) pi
2) hetzner   4) work
connect to: 3
```

## tethering

Sets TTL 64 on traffic arriving from one interface, so devices tethered
through this machine look like the machine's own traffic to a carrier that
counts hops. Elevates itself with sudo, applies one `iptables` mangle rule,
and the rule intentionally does **not** survive a reboot.

```
tethering            # pick the interface, set the rule (idempotent)
tethering --status   # show what is set
tethering --off      # remove it now
```

## License

GPL-3.0-or-later.
