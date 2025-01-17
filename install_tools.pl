#!/usr/bin/perl
use strict;
use warnings;
use File::Copy;

# Determine the operating system
my $os = determine_os();

# Packages to install
my @packages = qw(gcc gdb make valgrind curl git vim);

# Install packages based on OS
if ($os eq "fedora") {
    print "Detected Fedora/RHEL-based system.\n";
    install_packages_dnf(@packages);
} elsif ($os eq "ubuntu") {
    print "Detected Ubuntu/Debian-based system.\n";
    install_packages_apt(@packages);
} else {
    die "Unsupported operating system.\n";
}

print "Installation complete.\n";

print "Install Kitty terminal\n";
system("bash", "install_kitty.sh") == 0 or die "Error installing Kitty: $!";
print "Installation Kitty complete\n";

print "Install Nvim terminal\n";
system("bash", "install_nvim.sh") == 0 or die "Error installing Nvim: $!";
print "Installation Nvim complete\n";

print "Copy .vimrc in ~\n";
copy(".vimrc", "~/.vimrc") or die "Copy failed: $!";
print "File .vimrc copied\n";

sub determine_os {
    if (-f "/etc/os-release") {
        my %os_info;
        open my $fh, "<", "/etc/os-release" or die "Could not open /etc/os-release: $!";
        while (my $line = <$fh>) {
            chomp $line;
            if ($line =~ /^ID=(.*)/) {
                $os_info{id} = $1;
            }
        }
        close $fh;
        if ($os_info{id} eq "fedora" || $os_info{id} eq "rhel") { # Check for RHEL too
            return "fedora";
        } elsif ($os_info{id} eq "ubuntu" || $os_info{id} eq "debian") { # Check for Debian too
            return "ubuntu";
        }
    }
    return undef; # If /etc/os-release isn't found or doesn't match
}


sub install_packages_dnf {
    my @packages = @_;
    my $package_string = join " ", @packages;
    my $command = "sudo dnf install -y $package_string";
    print "Executing: $command\n";
    system($command) == 0 or die "Error installing packages: $!";
}

sub install_packages_apt {
    my @packages = @_;
    my $package_string = join " ", @packages;
    my $command = "sudo apt update && sudo apt install -y $package_string"; # Update first
    print "Executing: $command\n";
    system($command) == 0 or die "Error installing packages: $!";
}
