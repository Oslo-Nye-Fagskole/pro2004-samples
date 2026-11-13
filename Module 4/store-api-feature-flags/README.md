# Store API with Feature Flags

Copy the contents of this sample folder, including `.github/` and `workflow-examples/`, into its own GitHub repository (public or private), with any repository name you prefer. This lets you run workflows in isolation using your own Docker Hub username, credentials, and Azure configuration.

Runnable sample for Module 4, especially section 4.2, Feature Flags and Toggles. This version extends the [original Store API](https://github.com/Oslo-Nye-Fagskole/pro2004-samples/tree/main/demo-app) with an optional `display_price` field. It retains the same read-only mock products, routes, health check, Docker port, and 404 response. There is no database or authentication.

## Feature flag

`DISPLAY_PRICE_ENABLED` is an environment variable, evaluated once per product response. The list route uses the same value for every product.

| Setting | Product response |
| --- | --- |
| `true` (case insensitive) | Original fields plus `display_price`, such as `129 NOK` |
| `false`, missing, or any other value | Original fields only |

For example, `/products/1` returns the following when enabled:

```json
{"id": 1, "name": "Coffee mug", "price": 129, "currency": "NOK", "display_price": "129 NOK"}
```

The flag applies to all requests; user targeting and percentage rollouts are discussion topics in the module, rather than features of this sample.

## Run locally

From your local copy of that repository, where `app.py` and `requirements.txt` are located:

```sh
python -m pip install -r requirements.txt
python -m flask run
```

The flag is disabled by default. Open `/products`, `/products/1`, and `/health` at `http://localhost:5000`. `/products/999` returns 404.

Stop the server, enable the flag, and start it again. In PowerShell:

```powershell
$env:DISPLAY_PRICE_ENABLED = "true"
python -m flask run
```

In Bash:

```sh
DISPLAY_PRICE_ENABLED=true python -m flask run
```

To disable it, restart with `false` instead. Setting an environment variable in another shell does not update an already running process.

## Run tests

```sh
python -m unittest discover -s tests -v
```

Tests cover the original API contract, enabled and disabled responses on both product routes, missing and invalid values, unchanged mock data after disabling, and the existing health and 404 responses. No server is needed.

## Build once, release through configuration

From the same application directory:

```sh
docker build -t pro2004-store-api:feature-flags .
docker run --rm -p 8000:8000 -e DISPLAY_PRICE_ENABLED=false pro2004-store-api:feature-flags
```

Request `http://localhost:8000/products/1`, stop the container, then run the same image with the flag enabled:

```sh
docker run --rm -p 8000:8000 -e DISPLAY_PRICE_ENABLED=true pro2004-store-api:feature-flags
```

The second response includes `display_price`. Repeat with `false` to verify recovery. No image rebuild is needed.

## Use the existing deployment workflow

> **Secrets in public repositories:** It is fine to use GitHub Actions secrets in a public repository. They are not public: only users with the required permissions can manage them, and workflows can access values explicitly supplied through `${{ secrets.NAME }}`. Saved values cannot be viewed in the settings. **NEVER EVER commit secrets to Git**, including tokens, passwords, or Azure publish-profile files. Store them under **Settings > Secrets and variables > Actions > Secrets**, reference them in the build/publication/deployment YAML, and never print them in logs. Ordinary Actions variables are for non-sensitive configuration.

The included [manual workflow](.github/workflows/build-store-api.yml) builds and publishes the image when started manually. To deploy automatically, copy the [deployment example](workflow-examples/deploy-store-api.yml) to `.github/workflows/deploy-store-api.yml`. Both workflows can remain: the deployment workflow runs on every push to `main`, including documentation or configuration changes, and deploys if the preceding steps succeed. Configure your variables and secrets using [the Store API setup instructions](https://github.com/Oslo-Nye-Fagskole/pro2004-samples/tree/main/demo-app#configure-the-deployment-workflow), or reuse your existing personal repository setup. Both workflows expect `app.py`, `requirements.txt`, and `Dockerfile` directly in your sample repository's folder; the container listens on port `8000`.

Deploy this version, then set `DISPLAY_PRICE_ENABLED=false` in your Web App's application settings. Check the product response, change the setting to `true`, apply it, wait for the application restart, and check again. Change it back to `false` to confirm the original response returns. Use the same deployed image throughout; record its digest and the flag setting separately.

## Flag lifecycle

The flag introduces an additive response field, defaults to the original response, and provides a way to disable that field. For the section 4.6 exercise, record an owner, review date, and removal condition in your release notes. Remove the conditional only after choosing the permanent response and checking supported consumers and recovery versions.
