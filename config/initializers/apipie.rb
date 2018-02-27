Apipie.configure do |config|
  config.app_name                = "Fake IM Service"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  config.default_locale = 'en'
  config.languages = ['en']

  config.app_info['1.0'] = 'API documentation'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
  # config.authenticate = Proc.new do
  #   authenticate_user!
  # end
end
