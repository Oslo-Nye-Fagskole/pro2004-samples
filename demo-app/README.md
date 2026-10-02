# Store API

A small Flask API with read-only mock products. No database, credentials, or external services are needed.

From this directory, run locally (PowerShell):

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe app.py
```

Open `http://localhost:5000/products`. Also try `/`, `/health`, `/products/1`, and `/products/999` (404).

Run with Docker:

```powershell
docker build -t pro2004-store .
docker run --rm -p 8000:8000 pro2004-store
```

Open `http://localhost:8000/products`. Gunicorn runs the container; `python app.py` runs Flask's local development server.

For Azure, deploy this directory as the application root using the built-in Python runtime on App Service Free (F1). See [Module 1](../Module%201/README.md).
