class EventNotificationJob < ApplicationJob
  queue_as :default

  def perform(object, mail = nil)
    if mail.nil?
      all_emails = (object.event.subscriptions.map(&:user_email) + [object.event.user.email]).uniq
      all_emails -= [object.user&.email]
      case object
      when Photo
        all_emails.each do |email|
          EventMailer.photo(object, email).deliver_later
        end
      when Comment
        all_emails.each do |email|
          EventMailer.comment(object, email).deliver_later
        end
      end
    else
      EventMailer.subscription(object).deliver_later
    end
  end
end
