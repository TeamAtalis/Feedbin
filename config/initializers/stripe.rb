Rails.configuration.stripe = {
  # TEST ENV
  secret_key: Rails.application.credentials.stripe.test.api_key,
  publishable_key: Rails.application.credentials.stripe.test.public_key

  # PROD ENV
  # secret_key: Rails.application.credentials.stripe.production.api_key,
  # publishable_key: Rails.application.credentials.stripe.production.public_key
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

# TEST ENV
MONTHLY_PLAN_ID = 'price_1OroOrHTTMHkTbegVKLOEzEh'
YEARLY_PLAN_ID = 'price_1OrojvHTTMHkTbegBX4yUinQ'

# PROD ENV
# MONTHLY_PLAN_ID = 'price_1OrGG8HTTMHkTbegVE9p3rBv'
# YEARLY_PLAN_ID = 'price_1OrGGbHTTMHkTbegGKE0schi'
