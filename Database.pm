package DBIx::Database;

use strict;
use vars qw($VERSION @ISA @EXPORT_OK $errstr);
use Exporter;

@ISA = qw(Exporter);
@EXPORT_OK = qw( create_database drop_database );

$VERSION = '0.01';

=head1 NAME

DBIx::Database - Database-independant create and drop functions

=head1 SYNOPSIS

  use DBIx::Database qw( create_database drop_database );

  create_database( $data_source, $username, $password )
    or warn $DBIx::Database::errstr;

  drop_database( $data_source, $username, $password )
    or warn $DBIx::Database::errstr;

=head1 DESCRIPTION

This module implements create_database and drop_database functions for
databases.  It aims to provide a common interface to database creation and
deletion regardless of the actual database being used.

Currently supported databases are MySQL and PostgreSQL.  Assistance adding
support for other databases is welcomed and relatively simple - see
L<DBIx::Database::Driver>.

=head1 FUNCTIONS

=over 4

=item create_database DATA_SOURCE USERNAME PASSWORD

Create the database specified by the given DBI data source.

=cut

sub create_database {
  my( $dsn, $user, $pass ) = @_;
  my $driver = _load_driver($dsn);
  eval "DBIx::Database::$driver->create_database( \$dsn, \$user, \$pass )"
    or do { $errstr=$@ if $@; ''; };
}

=item drop_database DATA_SOURCE

Drop the database specified by the given DBI data source.

=cut

sub drop_database {
  my( $dsn, $user, $pass ) = @_;
  my $driver = _load_driver($dsn);
  eval "DBIx::Database::$driver->drop_database( \$dsn, \$user, \$pass )"
    or do { $errstr=$@ if $@; ''; };
}

sub _load_driver {
  my $datasrc = shift;
  $datasrc =~ s/^dbi:(\w*?)(?:\((.*?)\))?://i #nicked from DBI->connect
                        or '' =~ /()/; # ensure $1 etc are empty if match fails
  my $driver = $1 or die "can't parse data source: $datasrc";
  require "DBIx/Database/$driver.pm";
  $driver;
}

=back

=head1 AUTHOR

Ivan Kohler <ivan-dbix-database@420.am>

=head1 COPYRIGHT

Copyright (c) 2000 Ivan Kohler
Copyright (c) 2000 Mail Abuse Prevention System LLC
All rights reserved.
This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 BUGS

If DBI data sources were objects, these functions would be methods.

=head1 SEE ALSO

L<DBIx::Database::Driver>, L<DBIx::Database::mysql>, L<DBIx::Database::Pg>,
L<DBI>

=cut

1;
