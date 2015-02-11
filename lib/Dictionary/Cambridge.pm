package Dictionary::Cambridge;

use Moose;
use DDP;
use HTTP::Request;
use LWP::UserAgent;
use URI::Encode;
use JSON;

has "base_url" =>(
        is => 'ro',
        isa => 'Str',
        default => 'https://dictionary.cambridge.org/api/v1/'
);

has "access_key" => (
    is => 'rw',
    isa => 'Str',
);

has "user_agent" => (
    is => 'ro',
    isa => 'LWP::UserAgent',
    lazy_build => 1
);

has "encode_uri" =>(
    is =>'ro',
    isa => 'URI::Encode',
    lazy_build => 1
);

has "json" =>(
     is => 'ro',
     isa => 'JSON',
     lazy_build => 1
);

sub _build_user_agent {
    
    return LWP::UserAgent->new();
}

sub _build_http_request {
    
    return HTTP::Request->new(); 
}

sub _build_encode_uri {
    
    return URI::Encode->new();
}

sub _build_json {
     
    return JSON->new();

}


sub get_entry {

    my ($self, $dict_id, $word, $format) = @_;

    my $response;

    #return an error message unless there is entry_id and dict_id
    return "Dictionary id or Entry id not found" unless $dict_id and $word;
    return "Format allowed is html or xml" unless $format eq 'xml' or $format eq 'html';

    $self->user_agent->default_header(accessKey => $self->access_key);

    my $uri = $self->base_url;
    $uri .= 'dictionaries/'.$dict_id.'/entries/';
    $uri .=  $word.'/?format=html';
    $uri = $self->encode_uri->encode($uri);

	   eval{ $response = $self->user_agent->get($uri);};
		if (my $e = $@){
			die "Could not get response from API $e"; 
		}

    my $content = $self->json->decode($response->content);

    $content;

}



1;
