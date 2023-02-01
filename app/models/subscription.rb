class Subscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user, optional: true

  validates :user_name, presence: true, unless: -> { user.present? }
  validates :user_email, presence: true, format: /\A[a-zA-Z0-9\-_.]+@[a-zA-Z0-9\-_.]+\z/, unless: -> { user.present? }
  validate :unique_email, unless: -> { user.present? }
  validate :not_a_creator, if: -> { user.present? }

  validates :user, uniqueness: { scope: :event_id }, if: -> { user.present? }

  validates :user_email, uniqueness: { scope: :event_id }, unless: -> { user.present? }

  def user_name
    if user.present?
      user.name
    else
      super
    end
  end

  def user_email
    if user.present?
      user.email
    else
      super
    end
  end

  private

  def unique_email
    if User.find_by(email: user_email.downcase).present?
      errors.add(:user, :used_email)
    end
  end

  def not_a_creator
    if user == event.user
      errors.add(:user, :must_not_be_creator)
    end
  end
end
