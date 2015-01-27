package Dictionary::Cambridge;

use Moose;
use DDP;
use HTTP::Request;
use LWP::UserAgent;
use URI::Escape;

has "base_url" =>(
        is => 'ro',
        isa => 'Str',
        default => 'https://dictionary.cambridge.org/api/v1'
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

has "header" => (
    is => 'ro',
    isa => 'HTTP::Request',
    lazy_build => 1,
);

has 'encode_uri' => (
     is => 'ro',
     isa => 'URI::Escape',
     lazy_build => 1
);

1;
