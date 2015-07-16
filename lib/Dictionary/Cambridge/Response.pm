package Dictionary::Cambridge::Response;

use Moose::Role;
use DDP;
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

sub parse_xml {
    my ( $self, $xml_data ) = @_;
    my $doc = $self->xml->load_xml( string => $xml_data );
    my %definition = ();

    print $doc->toString(2), "\n";
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
    p(%definition);
}
1;

__DATA__

{
    noun => {
    definition => "defi"
}

my $result = $dict->lookup('telephone');

p($result);

for my ??? ( $result->???? ) {
    for my $definition ( ???->definitions ) {
        print $definition->text;
        for my $example ( $definition->examples ) {
        }
    }
}
