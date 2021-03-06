package ORACC::CBD::Map;
require Exporter;
@ISA=qw/Exporter/;

@EXPORT = qw/map_apply_glo map_apply_sig map_load map_set_map/;

use warnings; use strict; use open 'utf8'; use utf8;

use ORACC::CBD::PPWarn;
use ORACC::CBD::Util;
use ORACC::L2GLO::Util;
use Data::Dumper;

my $marshalling = '';

my @cmdcombos = qw/addentry addsense mapentry mapsense mapbase newbases/;
my %combofuncs = (
    addentry => \&addentry,
    addsense => \&addsense,
    addform => \&addform,
    newbases => \&newbases,
    mapentry => \&mapentry,
    mapsense => \&mapsense,
    mapbase => \&mapbase,
    addbase => undef,
);

my %currmap = ();

sub map_set_map {
    my $ref = shift;
    %currmap = %$ref;
}

sub map_apply_glo {
    my @cbd = @_;
    my @n = ();
#    print STDERR Dumper \%currmap;
    for (my $i = 0; $i <= $#cbd; ++$i) {
	if ($cbd[$i] =~ /^\@entry\S*\s+(.*?)\s*$/) {
	    my $key = $1;
	    $key =~ s/\s*(\[.*?\])\s*/$1/;
	    if ($currmap{$key}) {
		my %emap = %{$currmap{$key}};
#		print Dumper \%emap;
		# emap may have @bases @form @sense:
		if ($emap{'bases'}) {
		    while ($cbd[$i] !~ /^\@bases/) {
			push @n, $cbd[$i++];
		    }
		    push @n, $${$emap{'bases'}}[0];
		    ++$i;
		}
		while ($i < $#cbd && $cbd[$i] !~ /^\@form/) {
		    push @n, $cbd[$i++];
		}
		while ($cbd[$i] =~ /^\@form/) {
		    push @n, $cbd[$i++];
		}
		if ($emap{'form'}) {
		    if ($emap{'#basemap'}) {
			my %bmap = %{${$emap{'#basemap'}}};
			foreach my $f (@{${$emap{'form'}}}) {
			    my($b) = ($f =~ m#\s/(\S+)#);
			    if ($b && $bmap{$b}) {
				$f =~ s#\s/(\S+)# /$bmap{$b}#;
			    }
			    push @n, $f;
			}
		    } else {
			push @n, @{${$emap{'form'}}};
		    }
		}
		while ($i < $#cbd &&$cbd[$i] !~ /^\@sense/) {
		    push @n, $cbd[$i++];
		}
		while ($cbd[$i] =~ /^\@sense/) {
		    push @n, $cbd[$i++];
		}
		if ($emap{'sense'}) {
		    push @n, @{${$emap{'sense'}}};
		}
	    }
	    while ($i < $#cbd && $cbd[$i] !~ /^\@end\s+entry/) {
		push @n, $cbd[$i++];
	    }
	    push @n, $cbd[$i];
	} else {
	    push @n, $cbd[$i];
	}
    }
    if ($currmap{'#entries'}) {
	my @newentries = @{$currmap{'#entries'}};
	for (@newentries) {
	    my @e = split(/\cA/,$_);
	    push @n, @e, '';
	}
    }
    @n;
}

sub map_apply_sig {
    my ($args,$s) = @_;
    chomp($s);
    $s =~ s/\t(.*$)//;
    my $t = $1;
    if ($s =~ /^\{/) {
	my($psu,$sigs) = ($s =~ /^(.*?)::(.*?)$/);
	my @s = ();
	foreach my $s (split(/\+\+/,$sigs)) {
#	    warn "map_apply_sig_sub in psu\n";
	    push @s, map_apply_sig_sub($args,$s);
	}
	$s = $psu.'::'.join('++',@s);
    } else {
#	warn "map_apply_sig_sub non-psu\n";
	$s = map_apply_sig_sub($args,$s);
    }
    "$s\t$t\n";
}

sub map_apply_sig_sub {
    my ($args, $s) = @_;
    my $orig = $s;
    my %f = parse_sig($s);
    my $key = "$f{'cf'}\[$f{'gw'}]$f{'pos'}";
#    print Dumper \%currmap;
#    warn "key=$key\n";
    if ($currmap{$key}) {
	my $keysense = "$f{'cf'}\[$f{'gw'}//$f{'sense'}]$f{'pos'}'$f{'epos'}";
#	warn "keysense=$keysense\n";
	if ((my $to = ${$currmap{$key,'sense'}}{$keysense})) {
#	    warn "mapping $keysense => $$to\n";
	    my %f2 = parse_sig($$to); # why is this a ref to a scalar??
#	    print Dumper \%f2;
	    $f{'sense'} = $f2{'sense'};
	    $f{'epos'} = $f2{'epos'};
	}
	if ($$args{'#lang'}) { # could add && $$args{'coerce-lang'} here
	    $f{'lang'} = $$args{'#lang'};
	}
	$f{'form'} =~ s/^%.*?://;
	$f{'base'} =~ s/^%.*?:// if $f{'base'};
	if ($currmap{$key,'base'}) {
	    if ((my $mbase = ${$currmap{$key,'base'}}{$f{'base'}})) {
		$f{'base'} = $$mbase;
	    }
	}
	$s = serialize_sig(%f);
	my $op = (($orig eq $s) ? '==' : '->');
#	warn "map_apply_sig_sub $orig $op $s\n";
    } elsif ($$args{'#lang'}) {
	$s =~ s/\%.*?:/\%$$args{'#lang'}:/
    }
    $s;
}

sub map_load {
    my ($map,$for) = @_;
    $marshalling = $for;
    my %map = ();
    open(M, $map) || die "$0: failed to open map file for read\n";
    while (<M>) {
	next if /^\s*$/ || /^\#/;
	s/^.*?:\d+:\s+//; # remove file:line: info
	if (/^(add|cut|fix|map|new)\s+(.*?)$/) {
	    my ($cmd,$arg) = ($1,$2);
	    my($what,$from,$to) = ();
	    if (/=>/) {
		unless (($what,$from,$to) 
			= ($arg =~ /^(entry|sense|bases|base|form)\s+(.*?)\s*=>\s*(.*?)\s*$/)) {
		    warn "$map:$.: syntax error: bad field\n";
		    next;
		}
	    } else {
		unless (($what,$from) = ($arg =~ /^(entry|sense|bases|base|form)\s+(.*?)\s*$/)) {
		    warn "$map:$.: syntax error: bad field\n";
		    next;
		}
	    }
	    my %f = parse_sig($from);
	    my $key = "$f{'cf'}\[$f{'gw'}]$f{'pos'}";
	    my $combo = "$cmd$what";
	    my $combofunc = $combofuncs{$combo};
	    if ($combofunc) {
		my ($mapkey,$mapdata) = &$combofunc($key,\%f,$to);
		if ($mapkey) {
		    if ($marshalling eq 'sigs') {
			my($what,$from,$to) = @$mapdata;
			$map{$mapkey} = 1;
			${${$map{$mapkey,$what}}{$from}} = $to;
		    } elsif ($marshalling eq 'glos') {
			my($what,$from,$to) = @$mapdata;		       
			if ($to =~ /^\@(\S+)/) {
			    my $tag = $1;
			    if ($to =~ /^\@entry/) {
				push @{$map{'#entries'}}, $to;
			    } else {
				push @{${$map{$mapkey}{$tag}}}, $to;
			    }
			} else {
			    ${${$map{$mapkey}{'#basemap'}}}{$from} = $to;
			}
		    } else {
			die "$0: no support for marshalling type '$marshalling'\n";
		    }
		}
	    } else {
		warn "$map:$.: cmd/field combination '$combo' not handled\n"
		    unless exists $combofuncs{$combo};
	    }
	} elsif (/: add base /) {
	    # do nothing; this is for human review
	} else {
	    warn "$map:$.: syntax error: bad command\n";
	}
    }
    close(M);
    map_set_map(\%map);
    %map;
}


sub addentry {
    return undef if $marshalling eq 'sigs';
    my($k,$f,$to) = @_;
    ($k,['add','entry',$to]);
}

sub addsense {
    return undef if $marshalling eq 'sigs';
    my($k,$f,$to) = @_;
    ($k,['add','sense',$to]);
}

sub addform {
    return undef if $marshalling eq 'sigs';
    my($k,$f,$to) = @_;
    ($k,['add','form',$to]);
}

sub newbases {
    return undef if $marshalling eq 'sigs';
    my($k,$f,$to) = @_;
    ($k,['add','bases',$to]);
}

sub mapentry {
    return undef if $marshalling eq 'sigs';
    my($k,$f,$to) = @_;
    ($k,['map','entry',$to]);
}

sub mapsense {
    if ($marshalling eq 'sigs') {
	my($k,$f,$to) = @_;
	my $from = $k;
	$from =~ s#\]#//$$f{'sense'}]#;
	$from .= "'$$f{'epos'}";
	($k,['sense',$from,$to]);
    } else {
	return undef;
    }
}

sub mapbase {
    my($k,$f,$to) = @_;
    $to =~ /^(.*?)\s+~\s+(.*?)$/;
    ($k,['base',$1,$2]);
}

1;

