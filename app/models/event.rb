class Event < ActiveRecord::Base
  # Событие принадлежит юзеру
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  # Валидируем юзера на присутствие. В Rails 5 связи
  # валидируются по умолчанию
  validates :user, presence: true

  validates :title, presence: true, length: {maximum: 255}
  # У события должны быть заполнены место и время
  validates :address, presence: true
  validates :datetime, presence: true
end
