class Web < Sinatra::Application

  module I18nLocalePath

    def locale_path_prefix(locale = nil)
      locale = self.locale if locale.nil?
      return "" if locale == :en
      "#{locale}/"
    end

    def available_locales_info
      I18n.available_locales.map do |locale|
        {
            :native_name => I18n.t(:language, locale: locale),
            :path_prefix => locale_path_prefix(locale),
        }
      end
    end

  end

  I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
  I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
  I18n.config.enforce_available_locales = true
  I18n.backend.load_translations
  I18n.extend(I18nLocalePath)

  before do
    I18n.locale = "en"
  end

  before "/:locale/?*" do
    locale = params[:locale]
    path = "/#{params[:splat][0]}"
    case
      when locale === "en"
        redirect to(path), 301
      when I18n.available_locales.include?(locale.to_sym)
        I18n.locale = locale
        request.path_info = path
    end
  end

end