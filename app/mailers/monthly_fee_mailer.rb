class MonthlyFeeMailer < ActionMailer::Base
  default from: 'tesoureiro@garoa.net.br'

  def remember_to_pay(user)
      @aka = user.aka
      @current_year_and_month = I18n.l(Date.today, :format => :year_month)
      mail(to: user.email, subject: "Garoa Hacker Clube - Mensalidade do mês de #{@current_year_and_month}")
    end
end
