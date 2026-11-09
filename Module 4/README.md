# Module 4 - Decoupling Code and Feature Releases

- [Store API with Feature Flags](store-api-feature-flags/): runnable version for section 4.2. `DISPLAY_PRICE_ENABLED` controls the optional `display_price` product field. Includes local and Docker instructions, tests, and instructions for deploying this version through the existing pipeline.
- [Original Store API](../demo-app/): baseline used in earlier modules.

Use the feature flag sample to separate deployment from release, check backward compatibility, and rehearse disabling a feature without rebuilding an image. Traffic routing, API versioning, and centrally managed flags remain further examples discussed in the module.
