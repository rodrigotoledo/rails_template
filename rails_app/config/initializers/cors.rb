# Configuração global para lidar com CORS (Cross-Origin Resource Sharing)
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  # Permite solicitações de qualquer origem
  allow do
    # Origens permitidas
    origins '*'
    # Recurso permitido
    resource '*',
             # Permite todos os cabeçalhos
             headers: :any,
             # Métodos HTTP permitidos
             methods: %i[get post put patch delete options head],
             # Expor os seguintes cabeçalhos nas respostas
             expose: %w[access-token expiry token-type uid client],
             # Define a idade máxima para as respostas em cache (0 para desativar o cache)
             max_age: 0
  end
end
