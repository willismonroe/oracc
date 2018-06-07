package ORACC::CBD::Util;
require Exporter;
@ISA=qw/Exporter/;
@EXPORT = qw/pp_args pp_cbd pp_load pp_entry_of pp_sense_of header_vals setup_args 
    setup_cbd cbdname project lang name projdir file_index errfile/;

use warnings; use strict; use open 'utf8'; use utf8;
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';

use Data::Dumper;

my @data = qw/usage collo sense/;

%ORACC::CBD::data = (); @ORACC::CBD::data{@data} = ();

use ORACC::L2GLO::Langcore;
use ORACC::CBD::Forms;
use ORACC::CBD::PPWarn;
use ORACC::CBD::Sigs;
use ORACC::CBD::SuxNorm;
use ORACC::CBD::Validate;

my %file_indexes = ();

use Getopt::Long;

%ORACC::CBD::bases = ();
%ORACC::CBD::forms = ();

$ORACC::CBD::bases = 0;
$ORACC::CBD::noletters = 0;
$ORACC::CBD::nonormify = 0;
$ORACC::CBD::nosetupargs = 0;
$ORACC::CBD::qpn_base_lang = 'sux';

my $file_index = 1;

sub dump_file_indexes {
    print Dumper \%file_indexes;
}

sub pp_args {
    my $cbd = shift;
    my %args = ();

    GetOptions(
	\%args,
	qw/announce bare base:s check kompounds dry edit entries=s filter fix:s force invert lines list:s
	nonormify lang:s mode:s output:s project:s reset sigs trace vfields:s words=f xml/,
	) || die "unknown arg";
    
    $ORACC::CBD::PPWarn::trace = $args{'trace'};
    $ORACC::CBD::check_compounds = $args{'kompounds'};
    $ORACC::CBD::nonormify = $args{'nonormify'};

    if ($ORACC::CBD::nosetupargs) {
	@{$args{'argv'}} = @ARGV;
    } else {
        unless ($args{'filter'}) {
	    die "cbdpp.plx: must give glossary on command line\n"
		unless setup_args(\%args, shift @ARGV || $cbd);
	} else {
	    $args{'cbd'} = '<stdin>';
	}
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
	my $ldir = '01tmp';
	system 'mkdir', '-p', $ldir;
	my $outf = $ldir.'/'.lang().'.glo';
	open(CBD, ">$outf") 
	    || die "cbdpp.plx: can't write to $outf";
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
	warn "cbdpp: wrote $outf\n"
	    if $$args{'announce'};
    }
}

sub pp_load {
    my $args = shift;
    my @c = ();
    
    my $file = pp_file();
    
    if ($$args{'filter'}) {
	@c = (<>); chomp @c;
    } else {
	%{$ORACC::CBD::data{'files'}{$file}} = header_vals($file);
	forms_load($args) if $file =~ m#^00src#;
	open(C,$file) || die "cbdpp.plx: unable to open $file. Stop.\n";
	@c = (<C>); chomp @c;
	close(C);
    }
#    print Dumper \%ORACC::CBD::data; exit 0;

    my $insert = -1;
    for (my $i = 0; $i <= $#c; ++$i) {
	pp_line($i+1);
	if ($c[$i] =~ /^$ORACC::CBD::Edit::acd_rx?\@([a-z]+)/) {
	    my $tag = $1;
	    if ($tag ne 'end') {
		if ($tag eq 'project') {
		    pp_line($i+1);
#		    $$args{'project'} = v_project($c[$i]);
		} elsif ($tag eq 'lang') {
		    pp_line($i+1);
#		    $$args{'lang'} = v_lang($c[$i]);
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
		$insert = $i;
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
    
    $h{'projdir'} = "$ENV{'ORACC_BUILDS'}/$h{'project'}";
    $file_indexes{$c} = $file_index++ unless $file_indexes{$c};
    $h{'file_index'} = $file_indexes{$c};

    if ($c =~ /^01tmp/) {
	my $e = $c;
	$e =~ s/01tmp/00lib/;
	# we only track errors to 00lib glossaries because only epsd2
	# uses 00src right now and the split forms and glo architecture
	# there means that error messages from the combined 01tmp glo
	# aren't useful
	if (-r $e) {
	    $h{'errfile'} = $e;
	} else {
	    $h{'errfile'} = '';
	}
    }
    
    %h;
}

sub header_info {
    my($file,$tag) = @_;
    return '' unless $file && $tag;
    if (%{$ORACC::CBD::data{'files'}{$file}}) {
	my %f = %{$ORACC::CBD::data{'files'}};
	my %h = %{$f{$file}};
	return $h{$tag};
    }
    undef;
}

sub cbdname {
    my $p = project();
    my $l = lang();
    if ($p && $l) {
	return $p.':'."${l}_$file_indexes{pp_file()}";
    } else {
	return '';
    }
}
sub errfile {
    header_info(pp_file(),'errfile');
}
sub file_index {
    header_info(pp_file(),'file_index');
}
sub projdir {
    header_info(pp_file(),'projdir');
}
sub project {
    header_info(pp_file(),'project');
}
sub name {
    header_info(pp_file(),'name');
}

sub lang {
    header_info(pp_file(),'lang');
}

sub setup_args {
    my ($args,$file) = @_;
    return undef unless $file;
    $$args{'cbd'} = $file;
    my $lng = '';
    $ORACC::CBD::qpn_base_lang = 'sux'; # reset with @qpnbaselang in glossary header
    my %h = header_vals($$args{'cbd'});
    die "cbdpp.plx: $$args{'cbd'}: can't continue without project and language\n"
	unless $h{'project'} && $h{'lang'};
    $ORACC::CBD::bases = lang_uses_base($h{'lang'});
    $ORACC::CBD::norms = lang_uses_norm($h{'lang'});
#    warn "uses_base = $ORACC::CBD::bases\n";
    $$args{'lang'} = $h{'lang'};
    system 'mkdir', '-p', "01bld/$h{'lang'}";
    $file;
}

sub setup_cbd {
    my($args,$glossary) = @_;
    pp_file($glossary ? $glossary : $$args{'cbd'});
    my @cbd = pp_load($args, $glossary);
    @cbd = pp_validate($args, @cbd);
    if ($ORACC::CBD::Forms::external) {
	$ORACC::CBD::Forms::external = 0; # so v_form will validate
	forms_validate();
	if ($ORACC::CBD::bases || lang() =~ /qpn/) { # fix-me should check use base
	    forms_normify() unless $ORACC::CBD::nonormify;
	}
	$ORACC::CBD::Forms::external = 1;
#	forms_dump();
    } else {
	if ($ORACC::CBD::bases || lang() =~ /qpn/) {
	    @cbd = ORACC::CBD::SuxNorm::normify($$args{'cbd'}, @cbd)
		unless $ORACC::CBD::nonormify;
	}
    }
#    sigs_from_glo($args,@cbd) unless $$args{'check'} || pp_status();
    @cbd;
}

1;
