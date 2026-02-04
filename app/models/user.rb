class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  has_many :sites, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :vehicles, dependent: :destroy
  has_many :schedules, dependent: :destroy

  validates :email, presence: true, uniqueness: true
end
