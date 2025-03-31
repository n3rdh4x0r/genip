#!/usr/bin/perl
use strict;
use warnings;
use Socket qw(inet_aton inet_ntoa);

# Validate and parse IP range
sub parse_ip_range {
    my ($range) = @_;
    
    if ($range =~ /^(\d+\.\d+\.\d+\.\d+)-(\d+\.\d+\.\d+\.\d+)$/) {
        # Full IP range format (192.168.1.1-192.168.1.80)
        return ($1, $2);
    }
    elsif ($range =~ /^(\d+\.\d+\.\d+\.)(\d+)-(\d+)$/) {
        # Short format (192.168.1.1-80)
        return ($1.$2, $1.$3);
    }
    else {
        die "Invalid IP range format. Use either:\n" .
            "192.168.1.1-80\n" .
            "or\n" .
            "192.168.1.1-192.168.1.80\n";
    }
}

# Convert IP to integer
sub ip_to_int {
    my ($ip) = @_;
    return unpack("N", inet_aton($ip));
}

# Convert integer to IP
sub int_to_ip {
    my ($int) = @_;
    return inet_ntoa(pack("N", $int));
}

# Generate IP list
sub generate_ips {
    my ($start_ip, $end_ip) = @_;
    
    my $start_int = ip_to_int($start_ip);
    my $end_int = ip_to_int($end_ip);
    
    ($start_int, $end_int) = ($end_int, $start_int) if $start_int > $end_int;
    
    my @ips;
    for (my $i = $start_int; $i <= $end_int; $i++) {
        push @ips, int_to_ip($i);
    }
    
    return @ips;
}

# Main program
my $usage = "Usage: $0 <ip-range> -o <output-file>\n" .
            "Example: $0 192.168.1.1-80 -o hosts.txt\n";

die $usage unless @ARGV == 3 && $ARGV[1] eq '-o';

my ($range, $output_file) = ($ARGV[0], $ARGV[2]);

my ($start_ip, $end_ip) = parse_ip_range($range);
my @ip_list = generate_ips($start_ip, $end_ip);

open(my $fh, '>', $output_file) or die "Cannot open $output_file: $!";
print $fh "$_\n" for @ip_list;
close($fh);

print "Generated " . scalar(@ip_list) . " IPs and saved to $output_file\n";
