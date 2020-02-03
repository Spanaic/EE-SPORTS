Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      # origins "localhost:3000", 'https://ee-sports.firebaseapp.com/'
      origins "*"

      resource "*",
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head],
        expose: ['Per-Page', 'Total', 'Link']
    end
  end