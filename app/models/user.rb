class User < ApplicationRecord
  has_many :favorites

  # Devise checks for presence of email and password by default
  validates :name, presence: true
  validates :email, email: true, uniqueness: { case_sensitive: false }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  scope :admins, -> { where(admin: true) }   
  
  def admin?
    admin
  end

  # Resets reset password token and sends the account created instructions by email.
  # Returns the token sent in the e-mail.
  def send_account_created_instructions
    token = set_reset_password_token
    send_account_created_instructions_notification(token)

    token
  end

  def send_account_created_instructions_notification(token)
    send_devise_notification(:account_created_instructions, token, {})
  end

end
