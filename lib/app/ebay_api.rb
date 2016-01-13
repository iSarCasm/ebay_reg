class EbayAPI
  def self.sign_up(user)
    agent = Mechanize.new

    agent.get 'https://reg.ebay.com/reg/PartialReg?ru='
    sleep 3
    agent.page.iframes.first.content

    agent.page.forms.first.email      = user.email
    agent.page.forms.first.remail     = user.email
    agent.page.forms.first.firstname  = user.first_name
    agent.page.forms.first.lastname   = user.last_name
    agent.page.forms.first.PASSWORD   = user.password

    agent.page.forms.first.submit

    Account.new(user)
  end
end
