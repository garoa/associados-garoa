class MonthlyMembershipMailer < ActionMailer::Base
  TREASURER_EMAIL = 'tesoureiro@garoa.net.br'

  default from:        TREASURER_EMAIL,
          reply_to:    TREASURER_EMAIL,
          return_path: TREASURER_EMAIL,
          sender:      TREASURER_EMAIL

  def remember_to_pay(user)
    @aka = user.aka
    @current_year_and_month = I18n.l(Date.today, :format => :year_month)
    @february = User.yearly_membership_month?
    @user_has_overdue_membership_payments = user.has_overdue_membership_payments?

    @overdue_payments = I18n.translate(:monthly_payment, count: user.overdue_monthly_memberships.to_i)

    simple_subject = "Garoa Hacker Clube - Mensalidade do mês de #{@current_year_and_month}"
    overdue_payments = " e #{@overdue_payments} em atraso"
    email_subject = user.has_overdue_membership_payments? ? (simple_subject + overdue_payments) : simple_subject

    mail(to: user.email,
         subject: email_subject)
  end

  def users_with_overdue_membership

    subject = "Garoa Hacker Clube - Associados com mensalidade em atraso"

    @users_with_overdue_payments = OverduePaymentsBuilder.new.build_users_list

    mail(to: 'associados-garoa@googlegroups.com',
         cc: 'cs@garoa.net.br',
         subject: subject)
  end

end
