package Dictionary::Cambridge::Response;

use Moose;
use DDP;
use XML::LibXML;
use namespace::autoclean;

extends 'Dictionary::Cambridge';

has 'xml_data' =>(
    is => 'rw',
    isa => 'Str',
    required => 1,

);


__PACKAGE__->meta->make_immutable;
1;


