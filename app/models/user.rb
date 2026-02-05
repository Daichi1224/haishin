class User < ApplicationRecord
  has_secure_password
  has_one_attached :avatar

  has_many :sites, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :vehicles, dependent: :destroy
  has_many :schedules, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  validates :password, presence: true, length: { minimum: 6 }, on: :create

  validates :password, length: { minimum: 6 }, allow_nil: true, on: :update
end
