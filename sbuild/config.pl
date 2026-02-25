# this config is derived from https://anarc.at/blog/2022-04-27-sbuild-qemu/

# Name to use as override in .changes files for the Maintainer: field
$maintainer_name = 'Ubuntu Developers <ubuntu-devel-discuss@lists.ubuntu.com>';

# run autopkgtest inside the schroot
$run_autopkgtest = 1;

# have sbuild use autopkgtest as a chroot
$chroot_mode = 'autopkgtest';
#$chroot_mode = "schroot";
#$schroot = "schroot";

# have autopkgtest use qemu
$autopkgtest_virt_server = 'qemu';

# extra parameters to pass qemu
# --enable-kvm is not necessary, it is detected automatically by autopkgtest
my @_qemu_options = ('--ram-size=4096', '--cpus=2');

# have autopkgtest-virt-qemu use the image at this path
# use --debug to show what autopkgtest is doing
$autopkgtest_virt_server_options = [ @_qemu_options, '--', '/srv/sbuild/qemu/%r-autopkgtest-%a.img' ];

# have normal autopkgtest also use qemu with the correct image
$autopkgtest_opts = [ '--', 'qemu', @_qemu_options, '/srv/sbuild/qemu/%r-autopkgtest-%a.img' ];

# no need to cleanup the chroot after the build since the whole VM gets cleaned up
$purge_build_deps = 'never';

# no need for sudo
$autopkgtest_root_args = '';


# Default distribution to build.
$distribution = "noble";
# Build arch-all by default.
$build_arch_all = 1;
$build_arch_any = 1;

$lintian_opts = ['-i', '-I', '-E', '--pedantic'];
$run_lintian = 1;

# Don't clean the source
#$clean_source = 0;

$verbose = 1;

$build_dir = '/home/rmcnew/work/schroot/build';
$build_environment = {
    'DEB_BUILD_OPTIONS' => 'parallel=16'
};

$log_dir = '/home/rmcnew/work/schroot/logs';

$resolve_alternatives = 1;

$external_commands = {
    'build-failed-commands' => ['%s'],
};


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
