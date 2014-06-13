class Web < Sinatra::Application

  module I18nLocaleExtensions

    LOCALE_DEFAULT = :en

    LOCALE_TO_URL_INFO = {
        :en => {
            :host => "greatstoriesofthebible.org",
            :short_host => "greatstories.org",
            :locale_path => false,
        },
        :es => {
            :host => "greatstoriesofthebible.org",
            :short_host => "greatstories.org",
            :locale_path => true,
        },
        :"zh-hans" => {
            :host => "greatstoriesofthebible.cn",
            :short_host => "greatstoriesofthebible.cn",
            :locale_path => false,
        },
    }

    def default_locale_for_host(host)
      default_locale = LOCALE_TO_URL_INFO.find do |_, info|
        locale_host = info[:host]
        host.end_with?(locale_host)
      end
      return default_locale[0] if default_locale
      LOCALE_DEFAULT
    end

    def host_for_locale(locale: nil)
      locale = I18n.locale if locale.nil?
      host = LOCALE_TO_URL_INFO[locale.to_sym][:host]
      host = "dev.#{host}" if ENV["RACK_ENV"] == "development"
      host = "staging.#{host}" if ENV["RACK_ENV"] == "staging"
      host
    end

    def short_host_for_locale(locale: nil)
      locale = I18n.locale if locale.nil?
      host = LOCALE_TO_URL_INFO[locale.to_sym][:short_host]
      host
    end

    def path_for_locale(locale: nil)
      locale = I18n.locale if locale.nil?
      path = LOCALE_TO_URL_INFO[locale.to_sym][:locale_path] ? "/#{locale.to_s}" : nil
      path
    end

    def url_for_locale(path: "", locale: nil)
      port_for_locale = ":8080" if ENV["RACK_ENV"] == "development"
      "http://#{host_for_locale(locale: locale)}#{port_for_locale}#{path_for_locale(locale: locale)}/#{path}"
    end

    def short_url_for_locale(path: "", locale: nil)
      locale = I18n.locale if locale.nil?
      "http://#{short_host_for_locale(locale: locale)}#{path_for_locale(locale: locale)}/#{path}"
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