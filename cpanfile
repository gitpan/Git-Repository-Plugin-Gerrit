requires 'perl', '5.008001';
requires 'Git::Repository', '1.13';
requires 'Git::Repository::Plugin::Log';

on 'test' => sub {
    requires 'Test::Fatal';
    requires 'Test::More', '0.98';
};

