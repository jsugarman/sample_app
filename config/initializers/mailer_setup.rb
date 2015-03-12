# 
# cleanest implementation of a non platform specifc path specification for a rails app
# NOTE: no hard-coding of path separator
# 
require Rails.root.join('lib','redirect_mail_interceptor').to_s

# 
# ensure Figaro env vars for mailer exist in dev environment
# 
Figaro.require_keys("dev_mailer_username","dev_mailer_password") unless not Rails.env.development?
Figaro.require_keys("prod_mailer_username","prod_mailer_password") unless not Rails.env.production?

# 
# ensure mail is redirected in development mode
# 
ActionMailer::Base.register_interceptor(RedirectMailInterceptor) unless not Rails.env.development?