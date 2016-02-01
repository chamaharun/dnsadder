#!/usr/bin/perl
use CGI qw/:standard/;
use HTML::Template;


my $mode        = param('mode');
my $hostname    = param('host');
my $ipaddress   = param('ip');
my $gotkey      = param('apikey'); 
my $apikey      = '';


sub print_http_header{
    my ($mime,$status) = @_;

    if($status == 200){
        print header(-type=>"$mime",-charset=>'utf-8',-Access-Control-Origin=>'*');
    }else{
        print header(-type=>"$mime",-status=>"$status",-charset=>'utf-8',-Access-Control-Origin=>'*');
    }
}

sub ns_data_validation{
   my ($hostname,$ipaddress) = @_;
   if ($hostname =~ /^(\w)*$/ && $ipaddress =~ /^(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/){
        return "Valid";
   }else{
        return "Invalid";
   }
}


sub add_dns_table{
    my ($hostname,$ipaddress) = @_;
    my $validation = &ns_data_validation($hostname,$ipaddress);
    if ($gotkey eq $apikey){
        if ($validation eq 'Valid'){
            my $ret = system("bash nsadd.sh -h $hostname -i $ipaddress >> log.txt");
            if ($ret eq 0){
                &print_http_header("text/html",200);
                print "Succeeded";
            }else{
                &print_http_header("text/html",200);
                print "Failed";
            }
        }else{
            &print_http_header("text/plain",400);
            print "Parameter Format Error";
        }
    }else{
        &print_http_header("text/plain",400);
        print "Auth Error";
    }
}



if ($ENV{'REQUEST_METHOD'} eq 'POST'){
    if ($mode eq 'add'){
        &add_dns_table($hostname,$ipaddress);
    }else{
        &print_http_header("text/plain",400);
        print "Bad Parameter";
    }
}else{
    &print_http_header("text/html",200);
    my $template = HTML::Template->new(filename => 'index.tmpl',
                                    'die_on_bad_params' => 0
                                    );
    print $template->output;
}
