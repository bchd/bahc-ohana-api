if defined?(ActionMailer)
  module Users
    class Mailer < Devise::Mailer
      def account_created_instructions(record, token, opts = {})
        @token = token
        devise_mail(record, :account_created_instructions, opts)
      end
    end
  end
end
