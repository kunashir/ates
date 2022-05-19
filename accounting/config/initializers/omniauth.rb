require_relative "../../oauth_strategy"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :keepa, "c7N5hF3EI1-ML-dZd7ML9RCzICD7yqsP2dfZWgw1jCk", "FEr_Tgn5U5fcA7f-Vy7Dq5yq_1E7Kqjc99YOIffw-Xk", scope: "public_writes",
    client_options: {
      site: "http://localhost:3000", scope: "public_writes"
    }
end
