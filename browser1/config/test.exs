import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :browser1, Browser1Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "kWamFi0PGRZ9di1Pp9Y1D7xqBTllfz3sFeLEYdiKfETrPY7RH3Z8VUUIhm1WuH5k",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
