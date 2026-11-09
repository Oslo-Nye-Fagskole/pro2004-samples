"""Store API with the optional display price feature from Module 4."""

import os

from flask import Flask, jsonify
from mock_data import PRODUCTS

app = Flask(__name__)


def product_response(product, display_price_enabled):
    result = dict(product)
    if display_price_enabled:
        result["display_price"] = f"{product['price']} {product['currency']}"
    return result


@app.get("/")
def home():
    return jsonify(message="Hello, shoppers!", endpoints=["/products", "/products/1", "/health"])


@app.get("/health")
def health():
    return jsonify(status="ok")


@app.get("/products")
def products():
    enabled = os.getenv("DISPLAY_PRICE_ENABLED", "false").lower() == "true"
    return jsonify([product_response(item, enabled) for item in PRODUCTS])


@app.get("/products/<int:product_id>")
def product(product_id):
    item = next((item for item in PRODUCTS if item["id"] == product_id), None)
    if item is None:
        return jsonify(error="Product not found"), 404
    enabled = os.getenv("DISPLAY_PRICE_ENABLED", "false").lower() == "true"
    return jsonify(product_response(item, enabled))


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
