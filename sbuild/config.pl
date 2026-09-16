# this config is derived from https://anarc.at/blog/2022-04-27-sbuild-qemu/

# Name to use as override in .changes files for the Maintainer: field
$maintainer_name = 'Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>';

# run autopkgtest inside the schroot
$run_autopkgtest = 1;

# Use schroots
#$chroot_mode = "schroot";
#$schroot = "schroot";

# Use unshare:
$chroot_mode = "unshare";
$unshare_mmdebstrap_keep_tarball = 1;

# have autopkgtest use qemu
#$autopkgtest_virt_server = 'qemu';

# have sbuild use autopkgtest as a chroot
#$chroot_mode = 'autopkgtest';

# extra parameters to pass qemu
# --enable-kvm is not necessary, it is detected automatically by autopkgtest
#my @_qemu_options = ('--ram-size=4096', '--cpus=2');

# have autopkgtest-virt-qemu use the image at this path
# use --debug to show what autopkgtest is doing
#$autopkgtest_virt_server_options = [ @_qemu_options, '--', '/srv/sbuild/qemu/%r-autopkgtest-%a.img' ];

# have normal autopkgtest also use qemu with the correct image
#$autopkgtest_opts = [ '--', 'qemu', @_qemu_options, '/srv/sbuild/qemu/%r-autopkgtest-%a.img' ];

# no need to cleanup the chroot after the build since the whole VM gets cleaned up
#$purge_build_deps = 'never';

# no need for sudo
#$autopkgtest_root_args = '';


# Default distribution to build.
$distribution = "resolute";
# Build arch-all by default.
$build_arch_all = 1;
$build_arch_any = 1;

$lintian_opts = ['-i', '-I', '-E', '--pedantic'];
$run_lintian = 1;

# Don't clean the source
$clean_source = 0;

$verbose = 1;

#$build_dir = '/home/rmcnew/work/schroot/build';
$build_environment = {
    'DEB_BUILD_OPTIONS' => 'parallel=16'
};

$log_dir = '/home/rmcnew/work/schroot/logs';

#$resolve_alternatives = 1;

$external_commands = {
    'build-failed-commands' => ['%s'],
};

# When to purge the build directory afterwards; possible values are 'never',
# 'successful', and 'always'.  'always' is the default. It can be helpful
# to preserve failing builds for debugging purposes.  Switch these comments
# if you want to preserve even successful builds, and then use
# 'schroot -e --all-sessions' to clean them up manually.
#$purge_build_directory = 'successful';
#$purge_session = 'successful';
#$purge_build_deps = 'successful';
# $purge_build_directory = 'never';
# $purge_session = 'never';
# $purge_build_deps = 'never';

$dpkg_buildpackage_user_options = ['-j16'];

# Directory for chroot symlinks and sbuild logs.  Defaults to the
# current directory if unspecified.
#my $USERNAME = "$ENV{USER}";
#$build_dir = "/home/${USERNAME}/work/schroot/build";

# Directory for writing build logs to
#$log_dir = '/home/${USERNAME}/work/schroot/logs';

# place for extra packages
$extra_packages = [
    # '/home/${USERNAME}/work/schroot/build'
];

# don't remove this, Perl needs it:
1;
