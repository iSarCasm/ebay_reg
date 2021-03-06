class User
  attr_reader :email, :first_name, :last_name, :password

  def initialize(email)
    @email      = email
    @first_name = Faker::Name.first_name
    @last_name  = Faker::Name.last_name
    @password   = Faker::Internet.password(8)
  end
end
