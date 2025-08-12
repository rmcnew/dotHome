# Name to use as override in .changes files for the Maintainer: field
# (optional; only uncomment if needed).
# $maintainer_name = 'Richard Scott McNew <scott.mcnew@canonical.com>';

# Default distribution to build.
$distribution = "noble";
# Build arch-all by default.
$build_arch_all = 1;

# When to purge the build directory afterwards; possible values are 'never',
# 'successful', and 'always'.  'always' is the default. It can be helpful
# to preserve failing builds for debugging purposes.  Switch these comments
# if you want to preserve even successful builds, and then use
# 'schroot -e --all-sessions' to clean them up manually.
$purge_build_directory = 'successful';
$purge_session = 'successful';
$purge_build_deps = 'successful';
# $purge_build_directory = 'never';
# $purge_session = 'never';
# $purge_build_deps = 'never';

# Directory for chroot symlinks and sbuild logs.  Defaults to the
# current directory if unspecified.
my $USERNAME = "$ENV{USER}";
$build_dir = "/home/${USERNAME}/work/schroot/build";

# Directory for writing build logs to
$log_dir = '/home/${USERNAME}/work/schroot/logs';

# Debian is moving to 'unshare' mode
$chroot_mode = "unshare";

# don't remove this, Perl needs it:
1;
