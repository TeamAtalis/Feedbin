class UserMailer < ApplicationMailer
  default from: "Curathor <#{ENV["FROM_ADDRESS"]}>", skip_premailer: true
  include ApplicationHelper
  helper ApplicationHelper

  def payment_receipt(billing_event)
    @billing_event = BillingEvent.find(billing_event)
    @user = @billing_event.billable
    mail to: @user.email, subject: "[Curathor] Payment Receipt"
  end

  def payment_failed(billing_event)
    @billing_event = BillingEvent.find(billing_event)
    @user = @billing_event.billable
    mail to: @user.email, subject: "[Curathor] Please Update Your Billing Information"
  end

  def subscription_reminder(billing_event)
    @billing_event = BillingEvent.find(billing_event)
    @user = @billing_event.billable
    mail to: @user.email, subject: "[Curathor] Your Subscription Will Renew Soon"
  end

  def password_reset(user_id, reset_token)
    @user = User.find(user_id)
    @reset_token = reset_token
    mail to: @user.email, subject: "[Curathor] Password Reset"
  end

  def trial_expiration(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "[Curathor] Your Trial is About to End"
  end

  def timed_plan_expiration(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "[Curathor] Your Account has Expired"
  end

  def starred_export_download(user_id, download_link)
    @user = User.find(user_id)
    @download_link = download_link
    mail to: @user.email, subject: "[Curathor] Starred Items Export Complete"
  end

  def kindle(kindle_address, title, epub)
    filename = title || "epub"
    attachments["#{filename}.epub"] = File.read(epub)
    mail to: kindle_address, subject: "Kindle Content", body: ".", from: ENV["KINDLE_EMAIL"]
  end

  def mailtest(user_id)
    @user = User.find(user_id)
    mail to: @user.email, subject: "[Curathor] Starred Items Export Complete", body: "test body"
  end

  def account_closed(user_id, opml)
    @user = User.find(user_id)
    attachments["subscriptions.xml"] = opml
    mail to: @user.email, subject: "[Curathor] Account Closed"
  end
end
