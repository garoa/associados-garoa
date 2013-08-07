class MonthlyFeeMailer < ActionMailer::Base
  default from: 'tesoureiro@garoa.net.br'

  def remember_to_pay_email(user)
      @aka = user.aka
      @current_month = Date.today.month.to_s
      mail(to: user.email, subject: "Garoa Hacker Clube - Mensalidade do mês de #{@current_month}")
    end
end
