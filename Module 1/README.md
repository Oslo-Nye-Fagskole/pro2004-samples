# Module 1 - Cloud Fundamentals

Use the shared [store API](../demo-app/) to explore resource groups, App Service, identity, and costs.

Draft setup: create a Linux Web App using a supported Python runtime (3.13 where available) and an App Service **Free (F1)** plan. Deploy the contents of `demo-app/` as the application root, with `app.py` and `requirements.txt` at its top level.

For ZIP deployment, enable `SCM_DO_BUILD_DURING_DEPLOYMENT=true` so Azure installs dependencies. Set the startup command to:

```text
gunicorn --bind 0.0.0.0:8000 --workers 1 --access-logfile - --error-logfile - app:app
```

Check `/health` and `/products` at the Web App URL. Keep the plan on F1; no database, container registry, or deployment slots are required.

[TODO - short video on Azure App Service Free (F1) deployment of the store API]

Reference: [Microsoft's Python App Service guidance](https://learn.microsoft.com/en-us/azure/app-service/configure-language-python). Some quickstarts default to paid plans; select F1 explicitly.
