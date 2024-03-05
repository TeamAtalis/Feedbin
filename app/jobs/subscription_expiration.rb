class SubscriptionExpiration
  include Sidekiq::Worker
  sidekiq_options queue: :default_critical

  def perform
    User.all.each do |user|
      expire_plan(user.id) if Stripe::Subscription.list(customer: user.customer_id).empty?
    end
  end

  def expire_plan(user_id)
    Subscription.where(user_id:).update_all(active: false)
    User.where(id: user_id).update_all(suspended: true)
    UserMailer.timed_plan_expiration(user_id).deliver_now
  end
end
