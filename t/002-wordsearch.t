#!/usr/bin/perl


use strict;
use warnings;
use Test::More tests=>8;
use lib "./lib/";
use DDP;

my $meaningful_word = "test";
my $not_a_word = "sdfkljsdflsdkj";
use_ok('Dictionary::Cambridge');
#to make the tests pass user must regsiter for their own access key from the
#following http://dictionary-api.cambridge.org/index.php/request-api-key 
my $word = Dictionary::Cambridge->new(access_key =>
    $ENV{ACCESS_KEY});

isa_ok($word, 'Dictionary::Cambridge' );
can_ok($word, 'get_entry');
my $meaning = $word->get_entry("british", $meaningful_word, "xml");

is(ref ($meaning) ,'HASH', "Content is a Hashref");
$meaning = $word->get_entry("british", $not_a_word, "xml");
is($meaning, "Entry '$not_a_word' not found.", "Correct reply from API");

$meaning = $word->get_entry(undef, undef, "xml");
is($meaning, "Dictionary id or word not found", "Correct reply when undef params");


$meaning = $word->get_entry("british", "$meaningful_word", undef);
is($meaning, "format of the reponse content is required", "Correct replay when format param undef");


$meaning = $word->get_entry("british", "$meaningful_word", "json");
is($meaning, "Format allowed is html or xml", "Correct replay when format param is not xml or html");


my $dict - Dictionary::Cambridge->new(
        dictionary => 'british',
        access_key => 1234
    );

my $result = $dict->getEntry( $word );

print $result->topic->Label;
print $result->topic->ThesaurusName;

my @audios = $result->info->audios;
for my $audio ( @audios ) {
    $audio->type;
    $audio->region;
    my @sources = $audio->sources;
    for my $source ( @sources ) {
        $source->src;
    }
}

