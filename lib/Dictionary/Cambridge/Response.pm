package Dictionary::Cambridge::Response;

use Moose::Role;
use DDP;
use XML::LibXML;
use namespace::autoclean;
$|=1;
has "xml" => (
    is => 'ro',
    isa => 'XML::LibXML',
    lazy_build => 1
);
sub _build_xml {
    return XML::LibXML->new();
}
sub parse_xml {
    my ($self, $xml_data) = @_;
    my $doc = $self->xml->load_xml(string => $xml_data);
    my @pos=$doc->findnodes("//di/pos-block/header/info/posgram/pos");
    foreach my $pos(@pos){
            p($pos->textContent);
        }
    
}
1;


