# 
# ensure Figaro env vars for mailer exist in dev environment
# 
Figaro.require_keys("dev_mailer_username","dev_mailer_password") unless not Rails.env.development?