require_relative "passage_version"

class Passage
  def self.bible_ref(book_key, book_ref)
    "#{I18n.t("bible_book.#{book_key}")} #{book_ref}"
  end

  def self.bible_ref_english(book_key, book_ref)
    "#{I18n.t("bible_book.#{book_key}", locale: :en)} #{book_ref}"
  end

  attr_reader :versions

  def initialize(book_key, book_ref)
    @book_key = book_key
    @book_ref = book_ref
    @versions = PassageVersion.load_versions(book_key, book_ref)
  end

  def bible_ref
    self.class.bible_ref(@book_key, @book_ref)
  end

  def bible_ref_english
    self.class.bible_ref_english(@book_key, @book_ref)
  end

  def author
    I18n.translate!("bible_book_author.#{@book_key}")
  rescue I18n::MissingTranslationData
    nil
  end
end
