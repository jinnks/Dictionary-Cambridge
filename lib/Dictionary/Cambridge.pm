package Dictionary::Cambridge;

use Moose;
use DDP;
use HTTP::Request;
use LWP::UserAgent;
use URI::Encode;

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

has "http_request" =>(
    is => 'ro',
    isa => 'HTTP::Request',
    lazy_build => 1
);

has "encode_uri" =>(
    is =>'ro',
    isa => 'URI::Encode',
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

sub get_entry {

    my ($self, $dict_id, $entry_id) = @_;
    #return an error message unless there is entry_id and dict_id
    return "Dictionary id or Entry id not found" unless $dict_id and $entry_id;
    $self->user_agent->default_header(accessKey => $self->access_key);
    my $uri = $self->base_url;
    $uri .= 'dictionaries/'.$dict_id.'/entries/';
    $uri .=  $entry_id.'/?format=html';
    $uri = $self->encode_uri->encode($uri);
    p($uri);
    print STDERR $uri."\n";
    my $response = $self->user_agent->get($uri);
    return $response;

}



1;
