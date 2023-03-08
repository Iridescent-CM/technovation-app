require "checkr"

Checkr.api_base = ENV.fetch("CHECKR_API_BASE", "https://api.checkr.com")
Checkr.api_key = ENV.fetch("CHECKR_API_KEY")
