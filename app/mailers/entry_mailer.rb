class EntryMailer < ApplicationMailer
  default from: "Curathor <noreply@curathor.com>"

  self.postmark_settings = { api_key: Rails.application.credentials.postmark.api_key || ENV["POSTMARK_API_KEY_BULK"] }

  def mailer(entry_id, to, subject, body, reply_to, email_name, readability)
    @entry = Entry.find(entry_id)
    @message = body
    @content = Share::Service.determine_content({entry_id: entry_id, readability: readability})
    if subject.blank?
      subject = @entry.title
    end
    mail(to: to, subject: subject, reply_to: reply_to, from: "#{email_name} <noreply@curathor.com>")
  end
end
