class User < ActiveRecord::Base
  before_save :ensure_authentication_token
  
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible  :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :password, :admin, :as => :admin
  # attr_accessible :title, :body
  
  has_many :permissions
  
  def self.reset_request_count!
    update_all("request_count = 0", "request_count > 0")
  end
  
  def to_s
     "#{email} (#{admin? ? "Admin" : "User"})"
  end
  
  
  
end
