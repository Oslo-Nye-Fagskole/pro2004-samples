import os
import unittest
from unittest.mock import patch

from app import app
from mock_data import PRODUCTS


class FeatureFlagTests(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_flag_values_preserve_original_fields_on_both_routes(self):
        for value in (None, "false", "", "invalid", "1", "true", "TRUE", "True"):
            with self.subTest(value=value), patch.dict(os.environ):
                os.environ.pop("DISPLAY_PRICE_ENABLED", None)
                if value is not None:
                    os.environ["DISPLAY_PRICE_ENABLED"] = value
                enabled = value in ("true", "TRUE", "True")
                expected = [dict(item) for item in PRODUCTS]
                if enabled:
                    for item in expected:
                        item["display_price"] = f"{item['price']} {item['currency']}"
                for path, body in (("/products", expected), ("/products/1", expected[0])):
                    response = self.client.get(path)
                    self.assertEqual(response.status_code, 200)
                    self.assertEqual(response.get_json(), body)

    def test_disabling_after_enabling_does_not_leave_field_in_mock_data(self):
        with patch.dict(os.environ, {"DISPLAY_PRICE_ENABLED": "true"}):
            self.client.get("/products")
            self.client.get("/products/1")
        with patch.dict(os.environ, {"DISPLAY_PRICE_ENABLED": "false"}):
            self.assertEqual(self.client.get("/products").get_json(), PRODUCTS)
            self.assertEqual(self.client.get("/products/1").get_json(), PRODUCTS[0])
        self.assertTrue(all("display_price" not in item for item in PRODUCTS))

    def test_health_and_missing_product_in_both_flag_states(self):
        for value in ("false", "true"):
            with self.subTest(value=value), patch.dict(os.environ, {"DISPLAY_PRICE_ENABLED": value}):
                health = self.client.get("/health")
                self.assertEqual(health.status_code, 200)
                self.assertEqual(health.get_json(), {"status": "ok"})
                missing = self.client.get("/products/999")
                self.assertEqual(missing.status_code, 404)
                self.assertEqual(missing.get_json(), {"error": "Product not found"})

    def test_list_evaluates_flag_once(self):
        with patch("app.os.getenv", return_value="true") as getenv:
            response = self.client.get("/products")
        getenv.assert_called_once_with("DISPLAY_PRICE_ENABLED", "false")
        self.assertTrue(all("display_price" in item for item in response.get_json()))


if __name__ == "__main__":
    unittest.main()
