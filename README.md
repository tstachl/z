# z

## Prepare Environment

### Connect via SSH

First I'm going to set up the `nixos` user with my public key:

```sh
mkdir ~/.ssh
touch ~/.ssh/authorized_keys
curl https://github.com/tstachl.keys >> ~/.ssh/authorized_keys
```

Next I have to find the IP address of the machine so I can connect to it:

```sh
ifconfig
```

Then I can connect to the machine via ssh:

```sh
ssh nixos@192.168.64.3
```

### Machines
#### Hermod
My ephemeral testing VPN configuration.

##### Setup

```sh
nix shell github:tstachl/z#setup
setup hermod
```

#### Meili
My Macbook configuration

##### Prerequisites
* Apple Store Login
* Homebrew installed
* Xcode Command Line Tools installed
* Terminal needs Full Disk Access

##### Install

```sh
mkdir -p workspace/tstachl && cd workspace/tstachl
git clone https://github.com/tstachl/z
cd ./z
nix --experimental-features "nix-command flakes" build .#darwinConfigurations.meili.system
./result/sw/bin/darwin-rebuild switch --flake .#meili
```

#### Odin
My RaspberryPi in Austria

#### Thor
My VPS in Santiago, Chile

