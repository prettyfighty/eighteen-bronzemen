class User < ApplicationRecord
  before_destroy :check_admin_numbers, prepend: true
  has_many :missions, dependent: :destroy
  has_many :sharings, dependent: :destroy
  has_many :shared_missions, through: :sharings, source: :mission
  has_many :groups, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :joined_groups, through: :memberships, source: :group

  validates :email, presence: true, uniqueness: true, format: { with: /.+\@.+\..+/ }
  validates :password, presence: true, confirmation: true

  before_create :encrypt_password
  before_update :encrypt_password

  mount_uploader :avatar, AvatarUploader

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

  def check_admin_numbers
    if self.role == "admin"
      throw :abort if User.where(role: "admin").count <= 1
    end
  end

end
