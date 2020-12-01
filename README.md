# gcpizza

Create a little slice of Ad Hoc Pizza on Google Cloud (GCP).

## Getting Started

This project assumes a recent version of macOS, and that there is no current gcloud configuration.

All project dependencies can be installed using `make install-tools`.

`gcloud` is installed with brew, but is not added to the shell's PATH automatically.
You can configure your shell's PATH with

```
make gcloud-path
```

### Configure and authorize Google SDK tools

```
make gcloud-init
```

Open the link in your browser and authorize the SDK to your adhoc.team Google account.

- Click "Get started for free" and setup your account.
- Chose "Individual" as the account type.
- Use your personal credit card for now, it will not automatically charge you for anything unless you opt-in manually.

*If you need to (re)authorize the SDK you can run

```
make gcloud-auth
```

### Enable billing on the account
```
make gcloud-billing
```

### Deploying to App Engine

```
make gcloud-deploy
```
