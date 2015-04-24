package Dictionary::Cambridge;

use Moose;
use HTTP::Request;
use LWP::UserAgent;
use URI::Encode;
use JSON;
use namespace::autoclean;
use lib "../";
use DDP;

with 'Dictionary::Cambridge::Response';

has "base_url" => (
    is      => 'ro',
    isa     => 'Str',
    default => 'https://dictionary.cambridge.org/api/v1/'
);

has "dictionary" => (
    is => 'rw',
    isa => 'Str',
    required => 1
);

has "format" => (
    is => 'rw',
    isa => 'Str',
    default => 'xml'
);

has "access_key" => (
    is  => 'rw',
    isa => 'Str',
    required => 1
);

has "user_agent" => (
    is         => 'ro',
    isa        => 'LWP::UserAgent',
    lazy_build => 1
);

has "encode_uri" => (
    is         => 'ro',
    isa        => 'URI::Encode',
    lazy_build => 1
);

has "json" => (
    is         => 'ro',
    isa        => 'JSON',
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

    return JSON->new()->utf8;

}

sub get_entry {

    my ( $self, $word ) = @_;

    my $response;

    #return an error message unless there is entry_id and dict_id
    return "Dictionary id or word not found" unless $self->dictionary and $word;
    return "format of the reponse content is required" unless $self->format;
    return "Format allowed is html or xml"
      unless $self->format eq 'xml'
      or $self->format eq 'html';
    $self->user_agent->default_header( accessKey => $self->access_key );

    my $uri = $self->base_url;
    $uri .= 'dictionaries/' . $self->dictionary . '/entries/';
    $uri .= $word . '/?format=' . $self->format;
    $uri = $self->encode_uri->encode($uri);

    eval { $response = $self->user_agent->get($uri); };
    if ( my $e = $@ ) {
        die "Could not get response from API $e";
    }

    if ( $response->is_success and $response->content ) {
        my $data = $self->json->decode( $response->content );
        my $hashed_content = $self->parse_xml($data->{entryContent});
        p($hashed_content);
    }
    else {
        my $data = $self->json->decode($response->content);
        die $data->{errorMessage};
    }

}
__PACKAGE__->meta->make_immutable;
1;
