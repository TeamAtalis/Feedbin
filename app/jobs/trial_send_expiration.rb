class TrialSendExpiration
  include Sidekiq::Worker
  sidekiq_options queue: :default_critical

  def perform(user_id)
    user = User.where(id: user_id).first
    return unless user.present? && user.plan_id == FREE_TRIAL_PLAN_ID

    UserMailer.trial_expiration(user_id).deliver
  end
end
