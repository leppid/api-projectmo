Rails.application.config.after_initialize do
  Blueprinter.configure do |config|
    config.default_transformers = [LowerCamelTransformer]
  end
end

