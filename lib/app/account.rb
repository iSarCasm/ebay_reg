class Account
  def initialize(user)
    @email    = user.email
    @password = user.password
  end

  def to_h
    {email: @email, password: @password}
  end
end
