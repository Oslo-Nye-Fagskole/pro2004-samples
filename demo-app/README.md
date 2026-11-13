# Store API

We suggest copying only the contents of this sample folder, including `.github/`, into the root of a dedicated personal GitHub repository (public or private), with any repository name you prefer. This lets you run workflows in isolation using your own Docker Hub username, credentials, and Azure configuration.

- Read-only mock product data
- **No** database integration
- **No** authentication/authorization

## Run instructions

From the directory containing `app.py` and `requirements.txt` (your repository root if copied as suggested), run:

```sh
pip install -r requirements.txt
flask run
```

Once running, open your browser and go to:

- [http://localhost:5000/products](http://localhost:5000/products) — all products
- [http://localhost:5000/products/1](http://localhost:5000/products/1) — a single product
- [http://localhost:5000/health](http://localhost:5000/health) — health check

An unknown product ID, such as `/products/999`, returns **404**. Products can only be viewed; updates and deletions are not supported.

## Run tests

From the same directory, after installing the dependencies, run:

```sh
python -m unittest discover -s tests
```

The tests use Flask's test client, so you do not need to start the server.

## Configure the deployment workflow

> **Secrets in public repositories:** It is fine to use GitHub Actions secrets in a public repository. They are not public: only users with the required permissions can manage them, and workflows can access values explicitly supplied through `${{ secrets.NAME }}`. Saved values cannot be viewed in the settings. **NEVER EVER commit secrets to Git**, including tokens, passwords, or Azure publish-profile files. Store them under **Settings > Secrets and variables > Actions > Secrets**, reference them in the build/publication/deployment YAML, and never print them in logs. Ordinary Actions variables are for non-sensitive configuration.

The included [deployment workflow](.github/workflows/deploy-store-api.yml) is ready for the app files at your repository root. Configure your own repository variables and secrets as follows:

1. Create a public Docker Hub repository named `pro2004-store-api` and a personal access token with read/write access.
2. Publish an initial image using your Docker Hub username:

   ```sh
   docker login
   docker build -t <username>/pro2004-store-api:initial .
   docker push <username>/pro2004-store-api:initial
   ```

3. Create an Azure Linux Web App for containers using that image. Configure its container port as `8000` (`WEBSITES_PORT=8000` for classic container configuration; target port `8000` for sidecar configuration).
4. Under **Configuration → General settings**, enable **SCM Basic Auth Publishing Credentials**. Add the app setting `WEBSITE_WEBDEPLOY_USE_SCM=true`, then download the publish profile from **Overview**. See [Microsoft's setup guidance](https://learn.microsoft.com/en-us/azure/app-service/deploy-container-github-action#generate-deployment-credentials).
5. In GitHub, open **Settings → Secrets and variables → Actions** and add:

   | Type | Name | Value |
   | --- | --- | --- |
   | Variable | `DOCKERHUB_USERNAME` | Your Docker Hub username |
   | Variable | `AZURE_WEBAPP_NAME` | Your Azure Web App name |
   | Variable | `AZURE_WEBAPP_HOSTNAME` | Default hostname from Azure Overview, without `https://` or a trailing slash |
   | Secret | `DOCKERHUB_TOKEN` | Your Docker Hub access token |
   | Secret | `AZURE_WEBAPP_PUBLISH_PROFILE` | Entire downloaded publish profile contents |

The Docker Hub token allows image publication; the publish profile allows Azure deployment. Keep both in GitHub secrets, and do not commit the profile file.

## Run

Push to `main`, then follow **Deploy Store API** in the repository's **Actions** tab. After deployment, open `https://<app-hostname>/health` using the hostname shown in Azure; it should return `{"status":"ok"}`.
