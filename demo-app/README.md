# Store API

We suggest copying only the contents of this sample folder, including `.github/` and `workflow-examples/`, into the root of a dedicated personal GitHub repository (public or private), with any repository name you prefer. This lets you run workflows in isolation using your own Docker Hub username, credentials, and Azure configuration.

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

## Build and publish an image (Module 2.5)

The included [manual workflow](.github/workflows/build-store-api.yml) tests the app and publishes a commit-tagged image to Docker Hub. It does not deploy to Azure.

1. Reuse or create a public Docker Hub repository named `pro2004-store-api` under your username.
2. In Docker Home, open **Account settings > Personal access tokens > Generate new token**. Name it `pro2004-actions`, choose an expiry, and allow repository **Read and Write** access. Generate and copy the token; it is shown only once.
3. In your GitHub repository, open **Settings > Secrets and variables > Actions**. Add `DOCKERHUB_USERNAME` under **Variables** and `DOCKERHUB_TOKEN` under **Secrets**.
4. Commit and push to your default branch, `main`, then open **Actions > Build and Publish Store API > Run workflow**. Select `main`, start the run, and check the resulting image in Docker Hub.

> **Secrets in public repositories:** GitHub Actions secrets can be used in a public repository. Only users with the required permissions can manage them; saved values are not viewable in settings. **NEVER EVER commit secrets to Git**, put credentials directly in YAML, or print them in logs. Use Actions secrets for credentials and ordinary variables for non-sensitive settings.

## Configure the deployment workflow

For Module 2.6, copy the included [deployment example](workflow-examples/deploy-store-api.yml) to `.github/workflows/deploy-store-api.yml`. You can keep the manual workflow for building and publishing without deployment. The example stays inactive outside `.github/workflows/` until you copy it.

> **Heads up:** Once committed, the deployment workflow runs on every push to `main`, including documentation or configuration changes, and deploys if the preceding steps succeed. The manual workflow still runs only when you select **Run workflow**.

Reuse the Azure Web App from Module 1 and keep the Docker Hub settings above.

1. In the Web App, enable **SCM Basic Auth Publishing Credentials** under **Configuration > General settings**.
2. Add the application setting `WEBSITE_WEBDEPLOY_USE_SCM=true`, save, and select **Download publish profile** from **Overview**.
3. In GitHub Actions settings, add these values:

   | Type | Name | Value |
   | --- | --- | --- |
   | Variable | `AZURE_WEBAPP_NAME` | Your Web App's name |
   | Variable | `AZURE_WEBAPP_HOSTNAME` | Default hostname from Azure Overview, without `https://` or a trailing slash |
   | Secret | `AZURE_WEBAPP_PUBLISH_PROFILE` | Entire downloaded publish profile contents |

Never commit the publish-profile file. Keep registry-triggered automatic deployment disabled; the workflow selects the image to deploy.

Push the workflow change to `main`, then follow **Deploy Store API** in **Actions**. It repeats testing and publication, deploys to Azure, and checks `/health`. A failed health check does not automatically roll back the deployment.
