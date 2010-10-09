<?php

define(API_KEY, 'IP');
define(API_URL, 'http://www.esvapi.org/v2/rest/passageQuery?key='.API_KEY
               .'&include-passage-references=false'
               .'&include-first-verse-numbers=false'
               .'&include-footnotes=false'
               .'&include-footnote-links=false'
               .'&include-surrounding-chapters=true'
               .'&passage=');

$input = array(
	"ref"=>FILTER_SANITIZE_STRING
);

$input=filter_var_array($_REQUEST, $input);
$ref=$input['ref'];

echo get_passage($ref);

function get_passage($ref)
{
  return get_url(API_URL.urlencode($ref));
}

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
