# kiwi-cli-tools-desktop

Four small CLI helpers for a Linux desktop. Installable with
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
and sorted. Another config file can be given with `-f FILE`.

Hosts can carry **tags**, a comment line inside the Host block (ssh ignores
it), and you can filter by them:

```
Host db1 db2
    # tags: work prod
    HostName ...
```

```
$ select-server work          # only hosts tagged work (several tags = all must match)
1) db1  [work prod]    3) web  [work]
2) db2  [work prod]
connect to: 2
$ select-server --tags        # work (3), prod (2), home (1)
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

## torlink

A poor man's VPN: reach any TCP service (ssh, a web UI, a database) on
another machine over Tor — no open ports, no accounts, no server. Tor and
socat run in one rootless podman container, so podman is all you need.

An onion address is the identity. Meeting takes one out-of-band exchange:
the offering side makes an **invite code** for one peer, the other side
accepts it. The code carries a Tor client-authorization key, so the service
is invisible to everyone without it — treat the code like a password.

```
# machine A: offer ssh and a web UI to "bob"
torlink add-service ssh 22
torlink add-service web 8080
torlink invite bob ssh web          # prints torlink1:...  (secret!)

# machine B: use them
torlink accept torlink1:... alice
torlink up
torlink ssh alice                   # ssh over tor
torlink connect alice web           # 127.0.0.1:2200 -> alice's web
torlink ssh-config >> ~/.ssh/config # then `ssh alice-tor` (and select-server) work
```

Each invite is its own onion service with only the services you listed, so
`torlink revoke bob` removes that access for good. `torlink ls` shows
services, peers and forwards. Tor is TCP only (no UDP), and the first
connection takes a while. The container uses host networking so it can reach
your local services; its SOCKS port (19050) is open on loopback only.

State (including your onion keys) lives in `~/.local/share/torlink`.
`./install.sh uninstall` stops every torlink container but keeps that state
and the image; `uninstall --purge` (or `torlink purge`) deletes the
containers, the image and all state — those onion addresses are then gone.

## License

GPL-3.0-or-later.
