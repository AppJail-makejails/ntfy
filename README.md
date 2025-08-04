# ntfy

ntfy (pronounced "notify") is a simple HTTP-based pub-sub notification service. With ntfy, you can send notifications to your phone or desktop via scripts from any computer, without having to sign up or pay any fees. If you'd like to run your own instance of the service, you can easily do so since ntfy is open source.

ntfy.sh

<img src="https://ntfy.sh/_next/static/media/logo.077f6a13.svg" alt="ntfy logo" width="30%" height="auto">

## How to use this Makejail

```sh
appjail makejail \
    -j ntfy \
    -f gh+AppJail-makejails/ntfy \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose=8080
```

## Tags

| Tag        | Arch     | Version            | Type   |
| ---------- | -------- | ------------------ | ------ |
| `13.5` | `amd64`  | `13.5-RELEASE` | `thin` |
| `14.3` | `amd64`  | `14.3-RELEASE` | `thin` |
