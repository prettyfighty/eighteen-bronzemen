class User < ApplicationRecord
  has_many :missions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: /.+\@.+\..+/ }
  validates :password, presence: true, confirmation: true

  before_create :encrypt_password
  before_update :encrypt_password

  def self.login(params)
    email = params[:email]
    password = params[:password]

    encrypted_password = Digest::SHA256.hexdigest("eighteen#{password}bronzemen")
    find_by(email: email, password: encrypted_password)
  end

  private
  def encrypt_password
    self.password = Digest::SHA256.hexdigest("eighteen#{password}bronzemen")
  end

end
