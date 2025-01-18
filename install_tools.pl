#!/usr/bin/perl
use strict;
use warnings;

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
    my $command = "sudo apt-get update && sudo apt-get install -y $package_string"; # Update first
    print "Executing: $command\n";
    system($command) == 0 or die "Error installing packages: $!";
}

sub install_script {
    # Run the install_nvim.sh script
    print "Running install_nvim.sh...\n";
    my $result = system("bash ./install_nvim.sh");

    if ($result != 0) {
        die "Error running install_nvim.sh: Exit code $result\n";
    } else {
        print "install_nvim.sh completed successfully.\n";
    }

    # Run the install_kitty.sh script
    print "Running install_kitty.sh...\n";
    my $result = system("bash ./install_kitty.sh");

    if ($result != 0) {
        die "Error running install_kitty.sh: Exit code $result\n";
    } else {
        print "install_kitty.sh completed successfully.\n";
    }

    # Run the install_go.sh script
    print "Running install_go.sh...\n";
    my $result = system("bash ./install_go.sh");

    if ($result != 0) {
        die "Error running install_go.sh: Exit code $result\n";
    } else {
        print "install_go.sh completed successfully.\n";
    }

}
