class Segond21OsisFileApi
  def initialize(file_path)
    @osis_xml = Nokogiri::XML(File.open(file_path))
  end

  def version
    "SG21"
  end

  def get_audio(bible_ref)
    nil
  end

  def get_read_more(bible_ref)
    "https://www.biblegateway.com/passage/?version=SG21&search=#{bible_ref}"
  end

  def get_text(bible_ref)
    book_name = get_book_name_from_bible_ref(bible_ref)
    book_id = get_book_id_from_book_name(book_name)
    book_ranges = bible_ref[book_name.length..-1].split(",").map(&:strip)

    html = %(<div class="osis"><p>)

    book_ranges.each do |book_range|
      start, finish = book_range.split("-")
      start_chapter, start_verse = start.split(":").map(&:to_i)
      if finish.include?(":")
        finish_chapter, finish_verse = finish.split(":").map(&:to_i)
      else
        finish_chapter = start_chapter
        finish_verse = finish.to_i
      end

      chapter = start_chapter
      verse = start_verse

      until chapter > finish_chapter || (chapter == finish_chapter && verse > finish_verse)
        osis_id = "#{book_id}.#{chapter}.#{verse}"
        node = @osis_xml.at_xpath("//osis:verse[@osisID='#{osis_id}']", "osis" => "http://www.bibletechnologies.net/2003/OSIS/namespace")

        if node
          if verse == 1
            html << %(<span class="chapter-num">#{chapter}:#{verse}&nbsp;</span>)
          else
            html << %(<span class="verse-num">#{verse}&nbsp;</span>)
          end

          node.children.each do |child|
            text = CGI.escapeHTML(child.inner_text.encode("utf-8"))
            case
            when child.text?
              html << text
            when child.name == "reference"
              html << %(<span class="reference">#{text}</span>)
            when child.name == "lb"
              html << %(</p><p>)
            end
          end

          verse += 1
        else
          chapter += 1
          verse = 1
        end
      end
    end

    html << "</p></div>"

    {
        :text => html,
        :copyright => %(Texte biblique de la Bible Version Segond 21. Copyright &copy; 2007 Société Biblique de Genève. Reproduit avec aimable autorisation. Tous droits réservés.),
        :css => "crossway",
    }
  end

  OSIS_BOOK_IDS = {
    "Gen"   => "Genesis",
    "Exod"  => "Exodus",
    "Num"   => "Numbers",
    "Josh"  => "Joshua",
    "Judg"  => "Judges",
    "Ruth"  => "Ruth",
    "1Sam"  => "1 Samuel",
    "2Sam"  => "2 Samuel",
    "1Kgs"  => "1 Kings",
    "2Kgs"  => "2 Kings",
    "1Chr"  => "1 Chronicles",
    "2Chr"  => "2 Chronicles",
    "Ezra"  => "Ezra",
    "Neh"   => "Nehemiah",
    "Esth"  => "Esther",
    "Job"   => "Job",
    "Ezek"  => "Ezekiel",
    "Dan"   => "Daniel",
    "Jonah" => "Jonah",
    "Matt"  => "Matthew",
    "Mark"  => "Mark",
    "Luke"  => "Luke",
    "John"  => "John",
    "Acts"  => "Acts"
  }

  def get_book_name_from_bible_ref(bible_ref)
    OSIS_BOOK_IDS.each do |book_id, book_name|
      return book_name if bible_ref.start_with?(book_name)
    end
  end

  def get_book_id_from_book_name(book_name)
    OSIS_BOOK_IDS.find { |book_id, book_id_book_name| book_id_book_name == book_name }.first
  end
end
