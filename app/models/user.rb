class User < ParseUser
  # no validations included, but feel free to add your own
  #has_many :venues, :inverse_of => :author

  fields :username,:emailVerified,:address,:address2,:city,:coordinate,:description,:email,:facebookId,:firstName,:lastName,:reportFlag,:role,:state,:zip

  validates_presence_of :username
  validates_presence_of :password
  validates_presence_of :password_confirmation
  validates_confirmation_of :password_confirmation


end
