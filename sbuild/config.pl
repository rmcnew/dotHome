# Name to use as override in .changes files for the Maintainer: field
# (optional; only uncomment if needed).
# $maintainer_name = 'Richard Scott McNew <scott.mcnew@canonical.com>';
$maintainer_name = 'Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>';

$chroot_mode = "schroot";
$schroot = "schroot";

# Default distribution to build.
$distribution = "noble";
# Build arch-all by default.
$build_arch_all = 1;
$build_arch_any = 1;

$lintian_opts = ['-i', '-I', '-E', '--pedantic'];
$run_lintian = 1;

# Don't clean the source
$clean_source = 0;

$build_dir = '/home/rmcnew/work/schroot/build';
$build_environment = {
    'DEB_BUILD_OPTIONS' => 'parallel=16'
};

$log_dir = '/home/rmcnew/work/schroot/logs';

$resolve_alternatives = 1;

$external_commands = {
    'build-failed-commands' => ['%s'],
};

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

$dpkg_buildpackage_user_options = ['-j16'];

# Directory for chroot symlinks and sbuild logs.  Defaults to the
# current directory if unspecified.
my $USERNAME = "$ENV{USER}";
$build_dir = "/home/${USERNAME}/work/schroot/build";

# Directory for writing build logs to
$log_dir = '/home/${USERNAME}/work/schroot/logs';



# don't remove this, Perl needs it:
1;
