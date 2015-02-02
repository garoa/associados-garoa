class MonthlyFeeMailer < ActionMailer::Base
  TREASURER_EMAIL = 'tesoureiro@garoa.net.br'

  default from:        TREASURER_EMAIL,
          reply_to:    TREASURER_EMAIL,
          return_path: TREASURER_EMAIL,
          sender:      TREASURER_EMAIL

  def remember_to_pay(user)
      @aka = user.aka
      @current_year_and_month = I18n.l(Date.today, :format => :year_month)
      @february = (Date.today.month == 2)

      mail(to: user.email,
           subject: "Garoa Hacker Clube - Mensalidade do mês de #{@current_year_and_month}")
    end
end
