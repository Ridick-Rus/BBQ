class EventNotificationJob < ApplicationJob
  queue_as :default

  def perform(object, mail = nil)
    case when mail.nil?
      all_emails = (object.event.subscriptions.map(&:user_email) + [object.event.user.email]).uniq
      all_emails -= [object.user&.email]
      all_emails.each do |email|
        EventMailer.try(object.class.to_s.downcase, object, email).deliver_later
      end
    else
      EventMailer.try(object.class.to_s.downcase, object).deliver_later
    end
  end
end
