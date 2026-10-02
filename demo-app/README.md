# Store API

- Read-only mock product data
- **No** database integration
- **No** authentication/authorization

## Run instructions

From the `demo-app` directory, run:

```sh
pip install -r requirements.txt
flask run
```

Once running, open your browser and go to:

- [http://localhost:5000/products](http://localhost:5000/products) — all products
- [http://localhost:5000/products/1](http://localhost:5000/products/1) — a single product
- [http://localhost:5000/health](http://localhost:5000/health) — health check

An unknown product ID, such as `/products/999`, returns **404**. Products can only be viewed; updates and deletions are not supported.
