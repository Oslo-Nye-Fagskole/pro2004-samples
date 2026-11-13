# Store API

We suggest copying only the contents of this sample folder into the root of a dedicated personal GitHub repository (public or private), with any repository name you prefer. This lets you run workflows in isolation using your own Docker Hub username, credentials, and Azure configuration.

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

## Add the deployment workflow

> **Secrets in public repositories:** It is fine to use GitHub Actions secrets in a public repository. They are not public: only users with the required permissions can manage them, and workflows can access values explicitly supplied through `${{ secrets.NAME }}`. Saved values cannot be viewed in the settings. **NEVER EVER commit secrets to Git**, including tokens, passwords, or Azure publish-profile files. Store them under **Settings > Secrets and variables > Actions > Secrets**, reference them in the build/publication/deployment YAML, and never print them in logs. Ordinary Actions variables are for non-sensitive configuration.

Follow the [Module 2 setup instructions](https://github.com/Oslo-Nye-Fagskole/pro2004-samples/tree/main/Module%202) to copy the workflow into `.github/workflows/` and configure your own repository variables and secrets. If the app is at your repository root, change the workflow's `working-directory: demo-app` to `working-directory: .` and the Docker build context from `./demo-app` to `.`.
