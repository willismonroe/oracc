package ORACC::CBD::Util;
require Exporter;
@ISA=qw/Exporter/;
@EXPORT = qw/pp_args pp_cbd pp_load pp_entry_of pp_sense_of header_vals setup_args setup_cbd/;

use warnings; use strict; use open 'utf8'; use utf8;
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';

my @data = qw/usage collo sense/;

%ORACC::CBD::data = (); @ORACC::CBD::data{@data} = ();

use ORACC::L2GLO::Langcore;
use ORACC::CBD::Forms;
use ORACC::CBD::PPWarn;
use ORACC::CBD::Sigs;
use ORACC::CBD::SuxNorm;
use ORACC::CBD::Validate;

use Getopt::Long;

%ORACC::CBD::bases = ();
%ORACC::CBD::forms = ();

sub pp_args {
    my %args = ();

    GetOptions(
	\%args,
	qw/bare check kompounds dry edit filter force lang:s output:s project:s 
	reset sigs trace vfields:s xml/,
	) || die "unknown arg";
    
    $ORACC::CBD::PPWarn::trace = $args{'trace'};
    $ORACC::CBD::check_compounds = $args{'kompounds'};
    
    unless ($args{'filter'}) {
	die "cbdpp.plx: must give glossary on command line\n"
	    unless setup_args(\%args, shift @ARGV);
    } else {
	$args{'cbd'} = '<stdin>';
    }
    %args;
}

sub pp_cbd {
    my ($args,@c) = @_;
    return if pp_status() && !$$args{'force'};
    if ($$args{'filter'}) {
	foreach (@c) {
	    print "$_\n" unless /^\000$/;
	}
    } else {
	my $ldir = "$$args{'projdir'}/01tmp";
	system 'mkdir', '-p', $ldir;
	open(CBD, ">$ldir/$$args{'lang'}.glo") 
	    || die "cbdpp.plx: can't write to $ldir/$$args{'lang'}.glo";
	if ($ORACC::CBD::Forms::external) {
	    my $cfgw = '';
	    my $forms_printed = 0;
	    foreach (@c) {
		next if /^\000$/;
		if (/\@entry.*?\s+(.*)$/) {
		    $cfgw = $1;
		    $forms_printed = 0;
		} elsif (/\@sense/ && !$forms_printed) {
		    forms_print($cfgw, \*CBD);
		    ++$forms_printed;
		}
		print CBD "$_\n";
	    }
	} else {
	    foreach (@c) {
		print CBD "$_\n" unless /^\000$/;
	    }
	}
	close(CBD);
    }
}

sub pp_load {
    my $args = shift;
    my @c = ();
    
    if ($$args{'filter'}) {
	@c = (<>); chomp @c;
    } else {
	forms_load($args) if $$args{'cbd'} =~ m#^00src#;
	open(C,$$args{'cbd'}) || die "cbdpp.plx: unable to open $$args{'cbd'}. Stop.\n";
	@c = (<C>); chomp @c;
	close(C);
    }

    my $insert = -1;
    for (my $i = 0; $i <= $#c; ++$i) {
	if ($c[$i] =~ /^$ORACC::CBD::Edit::acd_rx?\@([a-z]+)/) {
	    my $tag = $1;
	    if ($tag ne 'end') {
		if ($tag eq 'project') {
		    pp_line($i+1);
		    $$args{'project'} = v_project($c[$i]);
		} elsif ($tag eq 'lang') {
		    pp_line($i+1);
		    $$args{'lang'} = v_lang($c[$i]);
		} elsif ($tag eq 'qpnbaselang') {
		    pp_line($i+1);
		    my $l = v_lang($c[$i]);
		    if ($l) {
			if (lang_uses_base($l)) {
			    $ORACC::CBD::qpn_base_lang = $l;
			} else {
			    pp_warn("\@qpnbaselang language `$l' does not use bases");
			}
		    }
		    $c[$i] = "\000";
		}
		push(@{$ORACC::CBD::data{$tag}}, $i) if exists $ORACC::CBD::data{$tag};
	    } else {
		$insert = -1;
	    }
	} elsif ($c[$i] =~ s/^\s+(\S)/ $1/) {
	    if ($insert >= 0) {
		$c[$insert] .= $c[$i];
		$c[$i] = "\000";
	    } else {
		pp_warn("indented lines only allowed within \@entry");
	    }
	}
    }

    @c;
}

sub pp_entry_of {
    my ($i,@c) = @_;
    while ($i && $c[$i] !~ /^[+-]?\@entry/) {
	--$i;
    }
    $i;
}

sub pp_sense_of {
    my ($i,@c) = @_;
    while ($i && $c[$i] !~ /\@sense/) {
	--$i;
    }
    $i;
}

sub header_vals {
    my ($c) = @_;
    my %h = ();
    my @p = `head -4 $c`;
    foreach my $p (@p) {
	if ($p =~ /^\@(project|lang|name)\s+(.*?)\s*$/) {
	    my($t,$v) = ($1,$2);
	    $h{$t} = $v;
	} else {
	    $p = undef;
	}
    }
    @h{qw/project lang name/};
}

sub setup_args {
    my ($args,$file) = @_;
    return undef unless $file;
    $$args{'cbd'} = $file;
    my $lng = '';
#    $lng = $$args{'cbd'}; $lng =~ s/\.glo$//; $lng =~ s#.*?/([^/]+)$#$1#;
#    $$args{'lang'} = $lng unless $$args{'lang'};
    my ($h_p,$h_l,$h_n) = header_vals($$args{'cbd'});
    $$args{'project'} = $h_p
	unless $$args{'project'};
    $$args{'lang'} = $h_l
	unless $$args{'lang'};
    $$args{'name'} = $h_n
	unless $$args{'name'};
    $ORACC::CBD::bases = lang_uses_base($$args{'lang'});
    $ORACC::CBD::qpn_base_lang = 'sux'; # reset with @qpnbaselang in glossary header
    # Allow files of bare glossary bits for testing
    if ($$args{'bare'}) {
	$$args{'lang'} = 'sux' unless $$args{'lang'};
	$$args{'project'} = 'test' unless $$args{'project'};
    } else {
	die "cbdpp.plx: $$args{'cbd'}: can't continue without project and language\n"
	    unless $$args{'project'} && $$args{'lang'};
    }
    $$args{'projdir'} = "$ENV{'ORACC_BUILDS'}/$$args{'project'}";
    system 'mkdir', '-p', "01bld/$$args{'lang'}";
    $file;
}

sub setup_cbd {
    my $args = shift;
    pp_file($$args{'cbd'});
    my @cbd = pp_load($args);
    @cbd = pp_validate($args, @cbd);
    if ($ORACC::CBD::Forms::external) {
	$ORACC::CBD::Forms::external = 0; # so v_form will validate
	forms_validate();
	if ($$args{'lang'} =~ /sux|qpn/) {
	    forms_normify();
	}
	$ORACC::CBD::Forms::external = 1;
	forms_dump();
    } else {
	if ($$args{'lang'} =~ /sux|qpn/) {
	    @cbd = ORACC::CBD::SuxNorm::normify($$args{'cbd'}, @cbd);
	}
    }
#    sigs_from_glo($args,@cbd) unless $$args{'check'} || pp_status();
    @cbd;
}

1;
