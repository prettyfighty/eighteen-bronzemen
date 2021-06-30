class User < ApplicationRecord
  has_many :missions, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: /.+\@.+\..+/ }
  validates :password, presence: true, confirmation: true

  before_create :encrypt_password

  module Jiami

    def self.salt(password, head = 'abc', tail = '123')
      "#{head}#{password}#{tail}"
    end

    def self.encrypt(password)
      Digest::SHA256.hexdigest(password)
    end
  end


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
