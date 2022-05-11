require_relative "../../oauth_strategy"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :keepa, "RvQNo-uyWePnkLWJd0-vX2quVIQfnBBMyAoNOBZX2uc", "6q9vBDHO9F_qn-xHqpye5SdbatgmkCiNgv_GCTYGFyI", scope: "public_writes",
    client_options: {
      site: "http://localhost:3000", scope: "public_writes"
    }
end
