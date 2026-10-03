#!/usr/bin/env bash
# installer for kiwi-cli-tools-desktop — kiwi convention:
#   ./install.sh install|update|uninstall [--purge]
#
# Everything goes to $KIWI_PREFIX/bin (~/.local/bin under kiwi, or standalone).
# Nothing here needs root; tethering asks for it itself at run time.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="${KIWI_PREFIX:-$HOME/.local}"
TOOLS=(pweb select-server tethering)

case "${1:-install}" in
    install|update)
        for t in "${TOOLS[@]}"; do
            install -Dm755 "$SRC/bin/$t" "$PREFIX/bin/$t"
        done
        echo "installed: ${TOOLS[*]} -> $PREFIX/bin" ;;
    uninstall)
        for t in "${TOOLS[@]}"; do
            rm -f "$PREFIX/bin/$t"
        done
        # Only on --purge: an ordinary uninstall keeps pweb's certificate so
        # browsers that accepted it once do not have to warn again later.
        if [[ "${KIWI_PURGE:-0}" == 1 || "${2:-}" == --purge ]]; then
            rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/pweb"
            echo "purged pweb's certificate"
        fi
        echo "removed: ${TOOLS[*]}" ;;
    *) echo "usage: $0 install|update|uninstall [--purge]" >&2; exit 1 ;;
esac
