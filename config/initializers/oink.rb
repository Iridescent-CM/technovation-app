unless Rails.env.test? or Rails.env.development?
  Rails.application.middleware.use Oink::Middleware,
    logger: Hodel3000CompliantLogger.new(STDOUT)
end
