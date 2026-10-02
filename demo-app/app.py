"""Small store API used for Azure and DevOps demonstrations."""

from flask import Flask, jsonify
from mock_data import PRODUCTS

app = Flask(__name__)


@app.get("/")
def home():
    return jsonify(message="Hello, shoppers!", endpoints=["/products", "/products/1", "/health"])


@app.get("/health")
def health():
    return jsonify(status="ok")


@app.get("/products")
def products():
    return jsonify(PRODUCTS)


@app.get("/products/<int:product_id>")
def product(product_id):
    item = next((item for item in PRODUCTS if item["id"] == product_id), None)
    if item is None:
        return jsonify(error="Product not found"), 404
    return jsonify(item)


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
