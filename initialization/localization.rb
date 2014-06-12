class Web < Sinatra::Application

  module I18nLocaleExtensions

    LOCALE_DEFAULT = :en

    LOCALE_TO_URL_INFO = {
        :en => [ "greatstoriesofthebible.org", nil ],
        :es => [ "greatstoriesofthebible.org", "/es" ],
        :"zh-hans" => [ "greatstoriesofthebible.cn", nil ],
    }

    def default_locale_for_host(host)
      default_locale = LOCALE_TO_URL_INFO.find do |_, info|
        locale_host = info[0]
        host.end_with?(locale_host)
      end
      return default_locale[0] if default_locale
      LOCALE_DEFAULT
    end

    def host_for_locale(locale: nil)
      locale = I18n.locale if locale.nil?
      host = LOCALE_TO_URL_INFO[locale.to_sym][0]
      host = "dev.#{host}" if ENV["RACK_ENV"] == "development"
      host = "staging.#{host}" if ENV["RACK_ENV"] == "staging"
      host
    end

    def path_for_locale(locale: nil)
      locale = I18n.locale if locale.nil?
      path = LOCALE_TO_URL_INFO[locale.to_sym][1]
      path
    end

    def url_for_locale(path: "", locale: nil)
      port_for_locale = ":8080" if ENV["RACK_ENV"] == "development"
      "http://#{host_for_locale(locale: locale)}#{port_for_locale}#{path_for_locale(locale: locale)}/#{path}"
    end

    def available_locales_info
      # I18n.available_locales.map do |locale|
      #   {
      #       :native_name => I18n.t(:language, locale: locale),
      #       :url_prefix => url_for_locale(locale: locale),
      #   }
      # end
      []
    end

  end

  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.config.enforce_available_locales = true
  I18n.backend.load_translations
  I18n.extend(I18nLocaleExtensions)

end