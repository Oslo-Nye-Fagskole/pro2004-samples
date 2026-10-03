# Module 2 - DevOps and CI/CD Pipelines

[GitHub Actions workflow](../.github/workflows/deploy-store-api.yml) for the [demo app](../demo-app/): test, build, publish to Docker Hub, and deploy to Azure Web App on a push to `main`. Failed tests stop deployment. Images are tagged with the commit ID.

## Setup

1. Create a public Docker Hub repository named `pro2004-store-api` and a personal access token with read/write access.
2. Publish an initial image using your Docker Hub username:

   ```sh
   docker login
   docker build -t <username>/pro2004-store-api:initial ./demo-app
   docker push <username>/pro2004-store-api:initial
   ```

3. Create an Azure Linux Web App for containers using that image. Configure its container port as `8000` (`WEBSITES_PORT=8000` for classic container configuration; target port `8000` for sidecar configuration).
4. Under **Configuration → General settings**, enable **SCM Basic Auth Publishing Credentials**. Add the app setting `WEBSITE_WEBDEPLOY_USE_SCM=true`, then download the publish profile from **Overview**. See [Microsoft's setup guidance](https://learn.microsoft.com/en-us/azure/app-service/deploy-container-github-action#generate-deployment-credentials).
5. In GitHub, open **Settings → Secrets and variables → Actions** and add:

   | Type | Name | Value |
   | --- | --- | --- |
   | Variable | `DOCKERHUB_USERNAME` | Your Docker Hub username |
   | Variable | `AZURE_WEBAPP_NAME` | Your Azure Web App name |
   | Secret | `DOCKERHUB_TOKEN` | Your Docker Hub access token |
   | Secret | `AZURE_WEBAPP_PUBLISH_PROFILE` | Entire downloaded publish profile contents |

The Docker Hub token allows image publication; the publish profile allows Azure deployment. Keep both in GitHub secrets, and do not commit the profile file.

## Run

Push to `main`, then follow **Deploy Store API** in the repository's **Actions** tab. After deployment, open `https://<app-hostname>/health` using the hostname shown in Azure; it should return `{"status":"ok"}`.
