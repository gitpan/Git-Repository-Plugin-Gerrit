package Git::Repository::Plugin::Gerrit;

use 5.008005;
use strict;
use warnings;

our $VERSION = "0.02";

use parent qw(Git::Repository::Plugin);

use Git::Repository qw(Log);

sub _keywords { qw(
    find_change
) }

sub import {
    require Git::Repository::Log;
    my $attr = 'Git::Repository::Log::change_id';
    no strict 'refs';
    *$attr = sub {
        my $self = shift;
        return ($self->{message} =~ /Change-Id: (I\S{40})/)[0];
    };
}

sub find_change {
    my $repo = shift;
    my $change_id = __PACKAGE__->_normalize_change_id(shift);
    my @extra = @_;
    my $pattern = "Change-Id: ${change_id}";
    my @logs = $repo->log("--grep=$pattern", @extra);
    if (@logs > 1) {
        die 'Non-unique Change-Id!';
    }
    return shift @logs;
}

sub _normalize_change_id {
    my $package = shift;
    my $change_id = shift;

    my $orig_change_id = $change_id;

    $change_id =~ s/^Change-Id: //;

    if (length($change_id) == 40) {
        $change_id = 'I' . $change_id;
    }

    unless (length($change_id) == 41) {
        die "Unable to normalize Change-Id '$orig_change_id'";
    }

    return $change_id;
}

1;
__END__

=encoding utf-8

=head1 NAME

Git::Repository::Plugin::Gerrit - It's new $module

=head1 SYNOPSIS

    use Git::Repository::Plugin::Gerrit;

=head1 DESCRIPTION

Git::Repository::Plugin::Gerrit is ...

=head1 LICENSE

Copyright (C) Nathaniel Nutter.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Nathaniel Nutter E<lt>iam@nnutter.comE<gt>

=cut

