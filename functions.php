<?php

/* ====== GENERAL DEFINITIONS ======*/
define('TITLE_DEFAULT', 'Great Stories of the Bible');
define('SLOGAN_DEFAULT', 'An index of the great stories in the Bible');
define('SEARCH_DEFAULT', 'Type your search here...');
define('INDEX_FILE_DEFAULT', 'index.txt');
define('RETURN_TO_INDEX_DEFAULT', '&#x21FD;Find other great stories in the Bible');

/* ====== STORY & INDEX ====== */
define('STORY_NAME', 'name');
define('STORY_SHORT_NAME', 'short-name');
define('STORY_REF', 'ref');
define('INDEX_3COL_COLWIDTH', 40);

function get_index($file)
{
  return get_index_three_column($file);
}

function get_index_three_column($file)
{
  $index = array();
  $fp = fopen($file, "r");
  while(!feof($fp)) {
    $line = fgets($fp);
    $line = str_split($line, INDEX_3COL_COLWIDTH);
    
    $shortname = trim($line[0], "\r\n\t ");
    $name = trim($line[1], "\r\n\t ");
    $ref = trim($line[2], "\r\n\t ");
    $index[] = array(STORY_SHORT_NAME=>$shortname, STORY_NAME=>$name, STORY_REF=>$ref);
  }
  fclose($fp);
  return $index;
}

function get_index_two_column($file)
{
  $index = array();
  $fp = fopen($file, "r");
  while(!feof($fp)) {
    $line = fgets($fp);
    $line = explode('  ', $line, 2);
    
    $name = trim($line[0], "\r\n\t ");
    $shortname = get_story_short_name($name);
    $ref = trim($line[1], "\r\n\t ");
    $index[] = array(STORY_NAME=>$name, STORY_SHORT_NAME=>$shortname, STORY_REF=>$ref);
  }
  fclose($fp);
  return $index;
}

function write_index($index, $file)
{
  $fp = fopen($file, "w+");
  foreach($index as $row)
  {
    fwrite($fp, str_pad($row[STORY_SHORT_NAME], INDEX_3COL_COLWIDTH));
    fwrite($fp, str_pad($row[STORY_NAME], INDEX_3COL_COLWIDTH));
    fwrite($fp, str_pad($row[STORY_REF], INDEX_3COL_COLWIDTH));
    fwrite($fp, "\n");
    fflush($fp);
  }
  fclose($fp);
}

function get_story_short_name($name)
{
  /* replace spaces with underscores */
  $name = str_replace(' ', '_', $name);
  
  /* strip anything that isn't alphanumeric or an underscore */
  $name = ereg_replace('[^a-zA-Z0-9_]', '', $name);
  
  /* make it all lower case */
  $name = strtolower($name);
  
  return $name;
}

/* ====== PASSAGE RETRIEVAL ====== */
define('API_KEY', 'IP');
define('API_URL', 'http://www.esvapi.org/v2/rest/passageQuery?key='.API_KEY);
define('API_URL_AUDIO', API_URL
               .'&output-format=mp3'
               .'&passage=');
define('API_URL_TEXT', API_URL
               .'&include-passage-references=true'
               .'&include-first-verse-numbers=true'
               .'&include-footnotes=false'
               .'&include-footnote-links=false'
               .'&include-surrounding-chapters=true'
               .'&include-headings=false'
               .'&include-subheadings=false'
               .'&include-audio-link=true'
               .'&include-short-copyright=false'
               .'&audio-format=flash'
               .'&passage=');
define('CACHE_DIR', 'cache');
define('CACHE_AGE_LIMIT', 86400); /* 24 hours */

function get_passage($ref)
{
  $ref_id = get_passage_ref_id($ref);
  $file = CACHE_DIR.'/'.$ref_id;
  
  /* check if the cached file needs updating */
  $fileage = time()-filemtime($file);
  if($fileage > CACHE_AGE_LIMIT) {
    mkdir(CACHE_DIR);
    $passage = get_url(API_URL_TEXT.urlencode($ref));
    file_put_contents($file, $passage);
  }
  
  /* create the cached file if it doesn't exist */
  return file_get_contents($file);
}

function get_passage_mp3($ref)
{
  return API_URL_AUDIO.$ref;
}

function get_passage_ref_id($ref)
{
  return $ref;
}

/* ====== GENERIC ====== */
function get_url($url)
{
	$curl = curl_init();
	curl_setopt($curl,CURLOPT_URL,$url);
	curl_setopt($curl,CURLOPT_RETURNTRANSFER,1);
	curl_setopt($curl,CURLOPT_CONNECTTIMEOUT,5);
	$data = curl_exec($curl);
	curl_close($curl);
	return $data;
}

?>