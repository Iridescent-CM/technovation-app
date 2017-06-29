# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
#
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w(
  email.css

  public.css
  admin.css
  regional_ambassador.css
  student.css
  mentor.css
  judge.css

  public.js
  admin.js
  regional_ambassador.js
  student.js
  mentor.js
  judge.js

  location-details.js

  location-based-search.js
  text-based-search.js
  toggle-based-search.js
)
