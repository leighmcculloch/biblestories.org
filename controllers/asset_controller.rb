class Web < Sinatra::Application
  register Sinatra::AssetPack

  assets {
    serve "/js",     from: "assets/js"
    serve "/css",    from: "assets/css"
    serve "/images", from: "assets/images"

    js :web, "/js/web.js", [
        "/js/**/*.js"
    ]

    css :web, "/css/web.css", [
        "/css/**/*.css"
    ]

    js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
    css_compression :simple   # :simple | :sass | :yui | :sqwish

    prebuild true
  }

end
