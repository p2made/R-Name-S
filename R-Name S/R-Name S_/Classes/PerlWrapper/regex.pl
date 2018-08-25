#!/usr/bin/perl

if ($#ARGV == 3) {
	if ($ARGV[3] =~ m/[ig][ig]/) {
		$ARGV[0] =~ s/$ARGV[1]/$ARGV[2]/ig;
	}
	elsif ($ARGV[3] =~ m/i/) {
		$ARGV[0] =~ s/$ARGV[1]/$ARGV[2]/i;
	}
	elsif ($ARGV[3] =~ m/g/) {
		$ARGV[0] =~ s/$ARGV[1]/$ARGV[2]/g;
	}
	elsif ($ARGV[3] =~ m/^$/) {
		$ARGV[0] =~ s/$ARGV[1]/$ARGV[2]/;
	}
	else {
		print "Invalid option.\n";
		exit(1);
	}
}
else {
	print "This script requires 4 arguments.\n";
	exit(1);
}

print "$ARGV[0]";

