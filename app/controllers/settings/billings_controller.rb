class Settings::BillingsController < ApplicationController
  before_action :plan_exists, only: [:update_plan]

  def index
    @user = current_user

    payments
    plan_setup

    render layout: 'settings'
  end

  def edit
    @user = current_user
    @default_plan = @user.plan
    plan_setup

    render layout: 'settings'
  end

  def payment_history
    payments
    render layout: 'settings'
  end

  def payment_details
    @message = Rails.cache.fetch(FeedbinUtils.payment_details_key(current_user.id), expires_in: 5.minutes) do
      customer = Customer.retrieve(@user.customer_id)
      card = customer.sources.first
      "#{card.brand} ××#{card.last4[-2..-1]}"
    end
  rescue StandardError
    @message = 'No payment info'
  end

  def update_credit_card
    @user = current_user

    if params[:stripe_token].present?
      @user.stripe_token = params[:stripe_token]
      if @user.save
        Rails.cache.delete(FeedbinUtils.payment_details_key(current_user.id))
        customer = Customer.retrieve(@user.customer_id)
        customer.reopen_account if customer.unpaid?
        redirect_to settings_billing_url, notice: 'Your card has been updated.'
      else
        redirect_to edit_settings_billing_url, alert: @user.errors.messages[:base].join(' ')
      end
    else
      redirect_to edit_settings_billing_url, alert: 'There was a problem updating your card. Please try again.'
      Librato.increment('billing.token_missing')
    end
  rescue Stripe::CardError => e
    redirect_to edit_settings_billing_url, alert: e.message
  end

  def change_plan
    create_checkout
  end

  def billing_success
    update_plan
    cancel_previous_subscriptions
    render 'shared/billing/_success'
  end

  def billing_error
    flash[:alert] = 'Your card was declined, please update your billing information.'
    redirect_to settings_billing_url
  end

  def update_plan
    @user = current_user
    @user.plan_id = params[:plan_id]
    @user.save
  end

  def cancel_subscription
    subscriptions = Stripe::Subscription.list(customer: @user.customer_id)
    subscriptions.each do |subscription|
      subscription.cancel_at_period_end = true
      subscription.save
    end
  end

  private

  def payments
    @default_plan = Plan.where(price_tier: @user.price_tier,
                               stripe_id: %w[basic-yearly basic-yearly-2
                                             basic-yearly-3]).first

    @next_payment = @user.billing_events.where(event_type: 'invoice.payment_succeeded')
    @next_payment = @next_payment.to_a.sort_by { |next_payment| -next_payment.event_object['date'] }
    if @next_payment.present? && !@user.timed_plan? && !@user.app_plan?
      @next_payment.first.event_object['lines']['data'].each do |event|
        @next_payment_date = Time.at(event['period']['end']).utc.to_datetime if event.safe_dig('type') == 'subscription'
      end
    end

    stripe_purchases = @user.billing_events.where(event_type: 'charge.succeeded')
    in_app_purchases = @user.in_app_purchases
    in_app_subscriptions = @user.app_store_notifications.where(notification_type: %w[SUBSCRIBED DID_RENEW])
    all_purchases = (stripe_purchases.to_a + in_app_purchases.to_a + in_app_subscriptions.to_a)
    @billing_events = all_purchases.sort_by { |billing_event| billing_event.purchase_date }.reverse
  end

  def plan_setup
    @plans = @user.available_plans
    @plan_data = @plans.map do |plan|
      { id: plan.id, name: plan.name, amount: plan.price_in_cents }
    end
  end

  def plan_exists
    render_404 unless Plan.exists?(params[:plan].to_i)
  end

  def cancel_previous_subscriptions
    subscriptions = Stripe::Subscription.list(customer: @user.customer_id)
    sorted_subscriptions = subscriptions.sort_by { |sub| -sub.created }

    sorted_subscriptions.each_with_index do |subscription, index|
      next if index == 0

      Stripe::Subscription.cancel(subscription.id)
    end
  end

  def create_checkout
    customer = Stripe::Customer.retrieve(@user.customer_id)

    session = Stripe::Checkout::Session.create(
      customer:,
      payment_method_types: ['card'],
      line_items: [{
        price: params[:plan_id],
        quantity: 1
      }],
      mode: 'subscription',
      success_url: "#{settings_billing_success_url}?plan_id=#{params[:plan_id]}",
      cancel_url: settings_billing_error_url
    )
    redirect_to session.url, allow_other_host: true
  end
end
