import unittest

from app import app


class StoreAPITests(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_health(self):
        response = self.client.get("/health")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.get_json(), {"status": "ok"})

    def test_products(self):
        response = self.client.get("/products")

        self.assertEqual(response.status_code, 200)
        self.assertEqual([product["id"] for product in response.get_json()], [1, 2, 3])

    def test_single_product(self):
        response = self.client.get("/products/1")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.get_json(), {
            "id": 1,
            "name": "Coffee mug",
            "price": 129,
            "currency": "NOK",
        })

    def test_missing_product(self):
        response = self.client.get("/products/999")

        self.assertEqual(response.status_code, 404)
        self.assertEqual(response.get_json(), {"error": "Product not found"})


if __name__ == "__main__":
    unittest.main()
