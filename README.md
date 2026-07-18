# ntfy

ntfy (pronounced "notify") is a simple HTTP-based pub-sub notification service. With ntfy, you can send notifications to your phone or desktop via scripts from any computer, without having to sign up or pay any fees. If you'd like to run your own instance of the service, you can easily do so since ntfy is open source.

ntfy.sh

<img src="https://camo.githubusercontent.com/bb33a92ccf2cc350e8fc95bf49c991ba00f8bee6557a361727c0136df7a5e473/68747470733a2f2f6e7466792e73682f5f6e6578742f7374617469632f6d656469612f6c6f676f2e30373766366131332e737667" width="30%" height="auto" alt="ntfy logo">

## How to use this Makejail

### Basic usage (no cache or additional config)

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    ghcr.io/appjail-makejails/ntfy ntfy \
    serve
```

### With persistent cache (configured as command line arguments)

```console
$ mkdir -p /var/appjail-volumes/ntfy/cache
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o fstab="/var/appjail-volumes/ntfy/cache /var/cache/ntfy" \
    ghcr.io/appjail-makejails/ntfy ntfy \
    serve --cache-file /var/cache/ntfy/cache.db
```

### Using `appjail-director` with non-root user and healthchecks enabled

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:

services:
  ntfy:
    name: ntfy
    makejail: gh+AppJail-makejails/ntfy
    options:
      - container: 'boot args:--pull'
      - healthcheck: '"health_cmd:jail:fetch -qo - http://localhost:8080/v1/health | grep -Eo \"\\\"healthy\\\"\\\\s*:\\\\s*true\" || exit 1" interval:60 timeout:10 start_period:40'
    scripts:
      - type: local
        text: service appjail-health onerestart
    volumes:
      - cache: /var/cache/ntfy
      - config: /usr/local/etc/ntfy
    oci:
      environment:
        - PUID: 15000
        - PGID: 15000
        - TZ: America/Caracas
      arguments: ["serve"]

volumes:
  cache:
    device: /var/appjail-volumes/ntfy/cache
  config:
    device: /var/appjail-volumes/ntfy/config
```

**Note**: Remember to set `appjail_health_enable=YES` in your `rc.conf(5)` file so that the healthcheckers start when the system boots.

### Arguments (stage: build)

* `ntfy_from` (default: `ghcr.io/appjail-makejails/ntfy`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `ntfy_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| appjail-2c53054646-var_cache_ntfy | `${PUID}` | `${PGID}` | - | - | /var/cache/ntfy |
| appjail-54d53978b2-usr_local_etc_ntfy | `${PUID}` | `${PGID}` | - | - | /usr/local/etc/ntfy |

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
