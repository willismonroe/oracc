#!/usr/bin/perl
use warnings; use strict; use open ':utf8';
binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
use lib '/usr/local/oracc/lib';
use ORACC::P3::Slicer;
use File::Temp qw/tempdir tempfile/;
use Data::Dumper;
use integer;

# P3 is controlled by the following top-level variables:
# ===================================-==================
#
# p3prod: the producer for the list being paged--list or srch
#
# p3mode: the slicing policy for the list--full or zoom
#
# p3what: the display policy for the list--page or item
# 
# p3type: the data being listed or searched--cat, xtf, tra, cbd
#
# p3form: the UI state--full or mini
#
# p3outl: the outline state--default or special
#
# Each of these variables is computed on entry to p3-pager.plx,
# inserted into the %rt array and echoed into the hidden fields
# on return.

my $oracclib = "/usr/local/oracc/lib";
my $oraccwww = "/usr/local/oracc/www";

my $verbose = 1;

my @pg_args = ();

my %p = decode_args(@ARGV);
my %rt = ();
set_p3_state();

# perform any nav actions

if ($p{'p3do'} eq 'itemstate') {
    $rt{'itemtype'} = $p{'p3itemtype'};
    if ($p{'p3itemtype'} eq 'off') {
	$p{'item'} = 0;
    }
} elsif ($p{'item'}) {
    $rt{'itemtype'} = $p{'itemtype'};
}

if ($p{'p3do'} eq 'pagefwd') {
    if ($p{'page'} < $p{'pages'}) {
	++$p{'page'};
    }
} elsif ($p{'p3do'} eq 'pageback') {
    if ($p{'page'} > 1) {
	--$p{'page'};
    }
} elsif ($p{'p3do'} eq 'pageset') {
    if ($p{'pageset'} <= 0 || $p{'pageset'} > $p{'pages'}) {
	$p{'page'} = 1;
    } else {
	$p{'page'} = $p{'pageset'};
    }
} elsif ($p{'p3do'} eq 'itemfwd') {
    if ($p{'item'} < $p{'items'}) {
	++$p{'item'};
    }
} elsif ($p{'p3do'} eq 'itemback') {
    if ($p{'item'} > 1) {
	--$p{'item'};
    }
} elsif ($p{'p3do'} eq 'itemset') {
    if ($p{'item'} <= 0 || $p{'item'} > $p{'items'}) {
	$p{'item'} = 1;
    }
}

# set the command to send the list to stdout

my $lister = '';
my $list_type = '';

my $tmpdir = tempdir(CLEANUP => 0);

warn "$tmpdir\n";

if ($p{'list'}) {

    if ($p{'list'} eq '_all') {
	$p{'#list'} = "/usr/local/oracc/pub/$p{'project'}/cat/pqids.lst";
    } else {
	$p{'#list'} = "/usr/local/oracc/www/$p{'project'}/lists/$p{'list'}";
    }
    $list_type = 'cat';

} elsif ($p{'adhoc'}) {

} elsif ($p{'srch'}) {
    
} else {
    # can't happen because we default $p{'list'}
}

my $kwic = $p{'cetype'} eq 'kwic';

# set up the Slicer inputs
setup_pg_args();
my($pg_order,$input) = ORACC::P3::Slicer::setup($tmpdir, $p{'#list'}, $kwic);

# set up the input for the content maker
ORACC::P3::Slicer::pageinfo($tmpdir, $pg_order, $input, $kwic, $p{'project'}, $p{'state'}, @pg_args);

# generate the outline
ORACC::P3::Slicer::outline($pg_order, @pg_args);

set_runtime_vars();

# generate the content
## in page mode emit the pth page
## in item-mode emit the ith item of the pth page

if ($p{'item'} == 0) {
    run_page_maker();
} else {
    run_item_maker();
}

# echo the template including outline/content as we go
print "Content-type: html; Encoding=utf-8\n\n"
    unless $p{'noheader'};
run_form_maker();

# close and exit
close(STDOUT);
exit 0;

####################################################################

sub
ce_data_info {
    my $nth = shift;
    my @ret = ();
    my $xce = load_xml("$tmpdir/content.xml");
    if ($xce) {
	my @cedata = tags($xce,'http://oracc.org/ns/ce/1.0','data');
	my $cenode = $cedata[$nth-1];
	if ($cenode) {
	    my $line = $cenode->getAttribute('line-id');
	    my $ctxt = $cenode->getAttribute('context-id');
	    if ($line) {
		push(@ret, '-stringparam', 'line-id', $line);
		push(@ret, '-stringparam', 'frag-id', $ctxt)
		    if $ctxt;
	    }
	}
    }
    @ret;
}

sub
decode_args {
    my %tmp = ();
    foreach my $a (@_) {
	warn "$a\n";
       	my($k,$v) = ($a =~ /^(.*?)=(.*)$/);
	$tmp{$k} = $v;
    }
    warn "args: ", Dumper \%tmp;
    # set up some defaults if not all values are given
    $tmp{'cetype'} = 'line' unless $tmp{'cetype'};
    $tmp{'item'} = 0 unless defined $tmp{'item'};
    $tmp{'itemset'} = 0 unless defined $tmp{'itemset'};
    $tmp{'list'} = '_all' unless $tmp{'list'} || $tmp{'adhoc'} || $tmp{'srch'};
    $tmp{'pageset'} = 1 unless $tmp{'pageset'};
    $tmp{'pagesize'} = 25 unless $tmp{'pagesize'};
    $tmp{'p3do'} = 'default' unless $tmp{'p3do'};
    $tmp{'state'} = 'default' unless $tmp{'state'};
    $tmp{'zoom'} = '0' unless $tmp{'zoom'};
    $tmp{'translation'} = 'en' unless $tmp{'translation'};
    $tmp{'transonly'} = 0 unless $tmp{'transonly'};
    warn "+defaults: ", Dumper \%tmp;
    %tmp;
}

sub
find_xmdoutline {
    my $eproject = $p{'project'};
    my $parent_project = $eproject;
    $parent_project =~ s#/.*$##;
    if (find_xmdoutline_sub("$oraccwww/$eproject/xmdoutline.xsl")) {
	"$oraccwww/$eproject/xmdoutline.xsl";
    } elsif ($parent_project ne $eproject && find_xmdoutline_sub("$oraccwww/$parent_project/xmdoutline.xsl")) {
	"$oraccwww/$parent_project/xmdoutline.xsl";
    } else {
	"$oracclib/scripts/p3-xmd-div.xsl";
    }
}

sub
find_xmdoutline_sub {
    my $ok = (-r $_[0] ? 'found' : 'not found');
    warn "trying xmdoutline $_[0] => $ok\n";
    $ok eq 'found';
}

sub
run_form_maker {
    my $t = "/usr/local/oracc/pub/$p{'project'}/p3.html";
    print '<!DOCTYPE html>', "\n";
    open(T,$t);
    while (<T>) {
	if (m#<p>\@</p>#) {
	    print '<div id="p3left">';
	    system 'cat', "$tmpdir/outline.html";
	    print '</div><div id="p3right" class="p3right80">';
	    system 'cat', "$tmpdir/results.html";
	    print '</div>';
	} elsif (m#p3:value=\"\@\@(.*?)\@\@\"#) {
	    my $atat = $1;
	    my($class,$var) = ($atat =~ /^(.*?):(.*?)$/);
	    my $rep = '';
	    my $default = '0';
#	    warn "var=$var\n";
	    if ($var =~ s#/(.+)$##) {
		$default = $1;
#		warn "default=$default\n";
	    }
	    if ($class eq 'cgivar') {
		if (defined $p{$var}) {
		    $rep = $p{$var};
		} else {
		    $rep = $default;
#		    warn "set default\n";
		}
		warn "cgivar $var = $rep\n";
	    } elsif ($class eq 'runtime') {
		if (defined $rt{$var}) {
		    $rep = $rt{$var};
		} else {
		    $rep = $default;
#		    warn "set default\n";
		}
		warn "runtime $var = $rep\n";
	    } else {
		warn "bad \@\@ class '$class'\n";
	    }
	    if (m#<(span.*?p3:value.*?)#) {
		s#>.+</span>#>$rep</span># || s#/>#>$rep</span>#;
	    } else {
		s/\svalue=\".*?\"//;
		s#p3:v# value=\"$rep\" p3:v#;
	    }
	    print;
	} else {
	    print;
	}
    }
    close(T);
}

sub
run_item_maker {
    # first recalibrate item and page: values{item} is an integer
    # from 1 to values{items}; we need to split it into page and
    # offset
    
    my($newPage,$sedItem) = ();

    $newPage = ($p{'item'} / $p{'pagesize'});
    ++$newPage unless !($p{'item'} % $p{'pagesize'});
    $sedItem = ($p{'item'} % $p{'pagesize'}) || $p{'pagesize'};

    warn "newPage = $newPage; sedItem = $sedItem; thisType=$rt{'itemtype'}\n";
    $p{'page'} = $newPage;

    my $id = `grep -v '^#' $tmpdir/pgwrap.out | sed -n '${sedItem}p'`;

    chomp($id);
    my($eproject,$eid) = ($p{'project'},'');
    if ($id =~ /^(.*?):(.*?)$/) {
	($eproject,$eid) = ($1,$2);
    } else {
	$eid = $id;
    }
    my @idinfo = ();
    $eid =~ s/_.*$//;
    $eid =~ s/^.*?://;
    $eid =~ s/\s.*$//;
    my $base = $eid;
    $base =~ s/^(....).*$/$1/;
    my $xmd = "/usr/local/oracc/bld/$eproject/$base/$eid/$eid.xmd";

    if ($rt{'itemtype'} eq 'cat') {
	xsystem('xsltproc',
		'-o', "$tmpdir/results.html",
		'/usr/local/oracc/lib/scripts/g2-xmd-HTML.xsl',
		$xmd
	    );
    } elsif ($rt{'itemtype'} eq 'xtf' || $rt{'itemtype'} eq 'tra') {
	my $line = $eid;
	$eid =~ s/\..*$//;
	if ($rt{'type'} =~ /^tra|xtf$/ && $rt{'what'} eq 'item') {
	    @idinfo = ce_data_info($p{'item'});
	} else {
	    push(@idinfo, '-stringparam', 'line-id', $p{'itemline'})
		if $p{'itemline'} && $p{'itemline'} ne 'none';
	    push(@idinfo, '-stringparam', 'frag-id', $p{'itemctxt'})
		if $p{'itemctxt'} && $p{'itemctxt'} ne 'none';
	}
	xsystem('xsltproc', 
		'-stringparam', 'p2', 'yes',
		'-stringparam', 'host', $p{'project'},
		'-stringparam', 'project', $eproject,
		'-stringparam', 'trans', $p{'translation'},
		'-stringparam', 'transonly', $p{'transonly'},
		@idinfo,
		'-o', "$tmpdir/results.html",
		'/usr/local/oracc/lib/scripts/p3-htmlview.xsl',
		$xmd);
	sig_fixer($p{'project'});
	xsystem('xsltproc', 
		'-stringparam', 'project', $eproject,
		'-o', "$tmpdir/outline.html",
		find_xmdoutline(),
		$xmd);
    } elsif ($rt{'itemtype'} eq 'cbd') {
	
    } else {
	warn "p3-pager.plx: no handler for type = $rt{'itemtype'}\n";
    }
}

sub
run_page_maker {
    my $vminus = $p{'page'} || 0;
    $vminus -= 1 if $vminus;
    my $ce_arg = '';
    if ($p{'cetype'}) {
	$ce_arg = $p{'cetype'};
	$ce_arg =~ s/^(.).*$/-$1/;
    } elsif ($list_type eq 'xtf') {
	$ce_arg = '-l';
    }
    my $item_offset = ($vminus) * $p{'pagesize'};
    my @offset_arg = ('-o', $item_offset);
    my @offset_param = ('-stringparam', 'item-offset', $item_offset);
    if ($list_type eq 'xtf') { ## sigfixer may need adding to end of pipe here some day
	xsystem("cat $tmpdir/pgwrap.out | /usr/local/oracc/bin/ce_xtf -3 $ce_arg -p $p{'project'} | /usr/local/oracc/bin/s2-ce_trim.plx >$tmpdir/content.xml");
	xsystem('xsltproc', '-stringparam', 'fragment', 'yes', '-stringparam', 'project', $p{'project'}, @offset_param, '-o', "$tmpdir/results.html", '/usr/local/oracc/lib/scripts/p3-ce-HTML.xsl', "$tmpdir/content.xml");
    } elsif ($list_type eq 'cat' || $list_type eq 'tra') {
	my $link_fields = `/usr/local/oracc/bin/oraccopt $p{'project'} catalog-link-fields`;
	my $lfopt = ($link_fields ? "-a$link_fields" : '');
	warn "lfopt=$lfopt\n";
	xsystem("cat $tmpdir/pgwrap.out | /usr/local/oracc/bin/ce2 -3 $lfopt -S$p{'state'} @offset_arg -i$list_type -p $p{'project'} >$tmpdir/content.xml");
	xsystem('xsltproc', '-stringparam', 'fragment', 'yes', '-stringparam', 'project', $p{'project'}, @offset_param, '-o', "$tmpdir/results.html", '/usr/local/oracc/lib/scripts/p3-ce-HTML.xsl', "$tmpdir/content.xml");
    } elsif ($list_type eq 'cbd') {
	xsystem("cat $tmpdir/pgwrap.out | /usr/local/oracc/bin/ce2 -3 -S$p{'state'} -icbd/$p{'glossary'} -p $p{'project'} >$tmpdir/content.xml");
	xsystem('xsltproc', '-stringparam', 'fragment', 'yes', '-stringparam', 'project', $p{'project'}, @offset_param, '-o', "$tmpdir/results.html", '/usr/local/oracc/lib/scripts/p3-ce-HTML.xsl', "$tmpdir/content.xml");    
    }
}

sub
set_p3_state {
    if ($p{'srch'}) {
	$rt{'prod'} = 'srch';
	$rt{'outl'} = 'special';
	if ($p{'srch'} =~ /^\!(\S+)/) {
	    $p{'#index'} = $1;
	} else {
	    $p{'#index'} = $p{'defaultIndex'};
	}
    } else {
	$rt{'prod'} = 'list';
	$rt{'outl'} = 'default';
    }

    if ($p{'zoom'} > 0) {
	$rt{'mode'} = 'zoom';
    } else {
	$rt{'mode'} = 'full';
    }

    if ($p{'form'}) {
	$rt{'form'} = $p{'form'};
    } else {
	$rt{'form'} = 'full';
    }

    if ($p{'type'}) {
	$rt{'type'} = $p{'type'};
    } elsif ($rt{'prod'} eq 'list') {
	if ($p{'glo'}) {
	    $rt{'type'} = 'cbd';
	} else {
	    $rt{'type'} = 'cat';
	}
    } else {
	if ($p{'thisIndex'}) {
	    $rt{'type'} = $p{'#index'};
	} else {
	    $rt{'type'} = 'cat';
	}
    }

    # Whether the item is a cat-item or a text-item is controlled by the item
    # content constructor based on the $rt{'itemtype'} parameter (set by p3itemtype).
    if ($p{'item'}) {
	$rt{'what'} = 'item';
    } else {
	$rt{'what'} = 'page';
    }
}

sub
set_runtime_vars {
    open(P, "$tmpdir/pg.info");
    while (<P>) {
	next if /^\#/;
	chomp;
	my($k,$v) = (/^(\S+)\s+(\S+)$/);
	$rt{$k} = $v;
    }
    close(P);
    my @itemlist = `grep -v '^#' $tmpdir/pgwrap.out`; chomp @itemlist;
    $rt{'itemlist'} = join(' ', @itemlist);
}

sub
setup_pg_args {
    $p{'page'} = 1 unless $p{'page'};
    my $tmpstate = ($p{'state'} =~ /^default|special$/ ? $p{'state'} : $p{'pushed-state'});
    $tmpstate = 'default' unless $tmpstate;
    @pg_args = ('-fm', "-p$p{'project'}", "-P$p{'pagesize'}", 
		"-n$p{'page'}", "-S$tmpstate");

    push @pg_args, '-q', if $list_type eq 'cbd';
    if ($tmpstate && $p{"$tmpstate-sort"}) {
	my $tmp = $p{"$tmpstate-sort"};
	$tmp =~ tr/_/^/; # escape field names like ch_no
	push(@pg_args, "-s$tmp") if $tmp;
    }
    push @pg_args, "-z$p{'zoom'}" if $p{'zoom'};
    push @pg_args, '-3';
}

# sig_fixer($project)
sub
sig_fixer {
    my $p = shift;
    local($/) = undef;
    open(T, "$tmpdir/results.html");
    my $text = <T>;
    close(T);
    my $l = '';
    my $reps = ($text =~ s/(pop1sig\()/pop1sig('$p','$l',/go);
    open(T,">$tmpdir/results.html");
    print T $text;
    close(T);
}

sub
xsystem {
    warn "system @_\n"
	if $verbose;
    system @_;
}

1;
