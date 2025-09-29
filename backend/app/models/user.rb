class User < ApplicationRecord

  # secure_password
  has_secure_password

  # validations
  validates :email, presence: true, uniqueness: true, if: -> { new_record? || email.present? }
  validates :phone, presence: true, uniqueness: true, if: -> { new_record? || phone.present? }
  validates :password, presence: true, confirmation: true, if: -> { new_record? || password.present? }
  validates :password_confirmation, presence: true, if: -> { new_record? || password.present? }
end
