Rails.configuration.stripe = {
  # TEST ENV
  publishable_key: ENV['STRIPE_TEST_PUBLIC_KEY'],
  secret_key: ENV['STRIPE_TEST_API_KEY']

  # PROD ENV
  # publishable_key: ENV['STRIPE_PUBLIC_KEY'],
  # secret_key: ENV['STRIPE_API_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]

# TEST ENV
MONTHLY_PLAN_ID = 'price_1OroOrHTTMHkTbegVKLOEzEh'
YEARLY_PLAN_ID = 'price_1OrojvHTTMHkTbegBX4yUinQ'

# PROD ENV
# MONTHLY_PLAN_ID = 'price_1OrGG8HTTMHkTbegVE9p3rBv'
# YEARLY_PLAN_ID = 'price_1OrGGbHTTMHkTbegGKE0schi'
