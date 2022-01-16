# frozen_string_literal: true

class Email < MandrillMailer::TemplateMailer
    default from: 'no-reply@bridj.com'
    
    def send_email(traveler, template, subject, vars)
        mandrill_mail(
        template: template,
        subject: I18n.t(subject),
        to: { email: traveler.email, name: traveler.first_name },
        vars: vars,
        inline_css: true
      )
    end
end
