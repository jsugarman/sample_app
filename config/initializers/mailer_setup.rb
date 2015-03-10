# require '~/rails_projects/sample_app/lib/redirect_mail_interceptor'

require_relative '../../lib/redirect_mail_interceptor'

# 
# ensure Figaro env vars for mailer exist in dev environment
# 
Figaro.require_keys("dev_mailer_username","dev_mailer_password") unless not Rails.env.development?

# 
# ensure mail is redirected in development mode
# 
ActionMailer::Base.register_interceptor(RedirectMailInterceptor) unless not Rails.env.development?