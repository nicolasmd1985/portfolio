Recaptcha.configure do |config|
  config.site_key = ENV['RECAPTCHA_SITE_KEY']
  config.secret_key = ENV['RECAPTCHA_SECRET_KEY']
  config.skip_verify_env.push('development', 'test')
  
  # Log configuration status
  Rails.logger.info "reCAPTCHA configuration:"
  Rails.logger.info "Site key present: #{config.site_key.present?}"
  Rails.logger.info "Secret key present: #{config.secret_key.present?}"
  Rails.logger.info "Skip verify envs: #{config.skip_verify_env}"
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end