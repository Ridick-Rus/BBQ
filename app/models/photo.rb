class Photo < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  # Добавляем uploader, чтобы заработал carrierwave
  mount_uploader :photo, PhotoUploader

  scope :persisted, -> { where "id IS NOT NULL" }
end
