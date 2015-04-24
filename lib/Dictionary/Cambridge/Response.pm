package Dictionary::Cambridge::Response;

use Moose::Role;
use DDP;
use XML::LibXML;
use namespace::autoclean;
use List::MoreUtils qw( zip );
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
    # print $doc->toString;
    my $all_nodes = $doc->find('*')->get_node(1)->childNodes();
    my $content;
    my $node_name;
    my @text;
    my @nodes;
    my %hashed;
    my $child_nodes;

    for (my $i = 0; $i<@$all_nodes; $i++){
        my $node = $all_nodes->[$i];
        if ($node->hasChildNodes){
         $child_nodes = $node->find('*')->get_node(1)->childNodes();
        for (my $j = 0; $j<@$child_nodes; $j++){
               my $child_nodes = $child_nodes->[$i];

            }   
        }
        $content = $node->textContent;
        $node_name  = $node->nodeName;
        $hashed{ $node_name } = $content;
        #push (@text , $content);
        #push (@nodes, $node_name);

         # print $content."\n";
         # print '-' x 134;
         # print $node_name."\n";
    }
    #p(@text);
    #p(@nodes);
    #%hashed = zip @nodes, @text;
    
    return \%hashed;

}
1;


