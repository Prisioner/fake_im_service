Apipie.configure do |config|
  config.app_name                = "Fake IM Service"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/apipie"
  config.default_locale = 'ru'
  config.languages = ['ru']

  config.app_info['1.0'] = 'Описание методов для API'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/**/*.rb"
  # config.authenticate = Proc.new do
  #   authenticate_user!
  # end
end
