class Photo < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  # В 5-х Рельсах эти валидации не нужно явно прописывать
  validates :event, presence: true
  validates :user, presence: true
  validates :photo, presence: true

  # Добавляем uploader, чтобы заработал carrierwave
  mount_uploader :photo, PhotoUploader

  scope :persisted, -> { where "id IS NOT NULL" }
end
