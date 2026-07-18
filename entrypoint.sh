#!/bin/sh

. /lib.subr

set -e

create_user

chown -R noroot:noroot /var/cache/ntfy

exec su-exec noroot ntfy "$@"
