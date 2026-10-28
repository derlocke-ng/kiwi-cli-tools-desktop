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

## License

GPL-3.0-or-later.
