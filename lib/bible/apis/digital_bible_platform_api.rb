class DigitalBiblePlatformApi
  API_KEY = ENV["API_KEY_DBP"]
  API_URL_AUDIO_SERVERS = "http://dbt.io/audio/location?key=#{API_KEY}&v=2&protocol=http&reply=json"
  API_URL_AUDIO_PATH = "http://dbt.io/audio/path?key=#{API_KEY}&encoding=mp3&reply=json&v=2"
  API_URL_AUDIO_VERSE_TIMECODE = "http://dbt.io/audio/versestart?key=#{API_KEY}&reply=json&v=2"
  API_URL_COPYRIGHT = "http://dbt.io/library/metadata?key=#{API_KEY}&reply=json&v=2"

  # en      - ENGESVN2DA - English ESV New Testament
  # zh-Hans - CHNUN1N2DA - Chinese (Simplified) New Testament
  # es-419  - SPNBDAN2DA - Spanish 2010 Biblia de América New Testament
  # fr      - FRNPDFO2ET - French 2000 Parole de Vie (European) Version

  def initialize(version)
    @version = version
  end

  def version
    @version
  end

  def get_copyright
    response = HTTParty.get("#{API_URL_COPYRIGHT}&dam_id=#{@version}")
    response_json = JSON.parse(response.body)
    meta_info = response_json[0]
    return meta_info["mark"] if meta_info
    nil
  end

  def get_base_url
    response = HTTParty.get(API_URL_AUDIO_SERVERS)
    response_json = JSON.parse(response.body)
    server_index = 0
    host = response_json[server_index]["server"]
    protocol = response_json[server_index]["protocol"]
    path = response_json[server_index]["root_path"]
    "#{protocol}://#{host}#{path}"
  end

  def get_audio_info(bible_ref)
    base_url = self.get_base_url

    parts = bible_ref.split(/[\ \-]/)

    # book id
    case parts[0]
      when "Mathew"
        book_id = "Matt"
      when "Luke", "Mark", "John", "Acts"
        book_id = parts[0]
      else
        return nil
    end

    # start chapter:verse
    start_parts = parts[1].split(":")
    start_chapter = start_parts[0].to_i
    start_verse = start_parts[1].to_i

    # end verse or chapter:verse
    end_parts = parts[2].split(":")
    if end_parts.length == 2
      end_chapter = end_parts[0].to_i
      end_verse = end_parts[1].to_i
    else
      end_chapter = start_chapter
      end_verse = end_parts[0].to_i
    end
    chapters = (start_chapter..end_chapter).to_a.map do |chapter|

      start_verse = chapter == start_chapter ? start_verse : 1
      end_verse = chapter == end_chapter ? end_verse : nil

      response = HTTParty.get("#{API_URL_AUDIO_VERSE_TIMECODE}&dam_id=#{@version}&book_id=#{book_id}&chapter_id=#{chapter}")
      response_json = JSON.parse(response.body)
      if start_chapter == start_chapter
        start_time_info = response_json.find { |v| v["verse_id"] == start_verse }
        start_time = start_time_info["verse_start"] if start_time_info

        # hack: all of the times returned seem to be off by anywhere from 4 to 13 seconds
        start_time = start_time.to_i
      end
      if end_verse
        end_time_info = response_json.find { |v| v["verse_id"] == (end_verse + 1) }
        end_time = end_time_info["verse_start"] if end_time_info
      end

      response = HTTParty.get("#{API_URL_AUDIO_PATH}&dam_id=#{@version}&book_id=#{book_id}&chapter_id=#{chapter}")
      response_json = JSON.parse(response.body)
      path = response_json[0]["path"]
      if path
        {
            :bible_ref => "#{book_id} #{chapter}:#{start_verse}-#{end_verse}",
            :url => "#{self.get_base_url}/#{path}",
            :start_time => start_time,
            :end_time => end_time,
        }
      else
        nil
      end
    end
    chapters.delete_if { |chapter| chapter == nil }
    chapters
  end

  def get_audio(bible_ref)
    audio_info = self.get_audio_info(bible_ref)
    audio = {
      :audio_info => audio_info,
      :copyright => "#{I18n.t(:audio)}: #{self.get_copyright}",
    }
    audio
  end

  def get_text(bible_ref)
    nil
  end

  def get_read_more(bible_ref)
    nil
  end
end
