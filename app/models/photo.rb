class Photo < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  # В 5-х Рельсах эти валидации не нужно явно прописывать
  validates :event
  validates :user
  validates :photo

  # Добавляем uploader, чтобы заработал carrierwave
  mount_uploader :photo, PhotoUploader

  scope :persisted, -> { where "id IS NOT NULL" }
end
