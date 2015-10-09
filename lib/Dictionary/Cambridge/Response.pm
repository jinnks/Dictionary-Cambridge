package Dictionary::Cambridge::Response;
#ABSTRACT: the roles to parse different part of the xml returned


use Moose::Role;
use XML::LibXML;
use namespace::autoclean;
use List::MoreUtils qw( zip );

has "xml" => (
    is         => 'ro',
    isa        => 'XML::LibXML',
    lazy_build => 1
);

sub _build_xml {
    return XML::LibXML->new();
}

=head2 METHODS
    parse_xml_def_eg
    params: xml content of the API get_entry call
=cut

sub parse_xml_def_eg {
    my ( $self, $xml_data ) = @_;
    my $doc = $self->xml->load_xml( string => $xml_data );
    my %definition = ();

    my @pos_blocks = $doc->findnodes( '//di/pos-block' );
    for my $pos_block (@pos_blocks) {
        my $pos = $pos_block->findvalue( './header/info/posgram/pos' );
        my @defs = $pos_block->findnodes( './sense-block/def-block' );
        for my $d( @defs ) {
            my $def = $d->findvalue('./definition/def');
            my @eg = map { $_->string_value() } $d->findnodes('./examp/eg');
            push @{$definition{$pos}},{"definition" => $def, "example" => \@eg};
        }

    }
    return \%definition;
}
1;
