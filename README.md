bayhac2014
==========

Small haskell webapp using Scotty and ImageMagick

To build, just run
## If you're on a VM and need to update cabal first:
# Create a swap file (digitalocean and AWS VMs have no swap by default)
# see http://stackoverflow.com/questions/13104630/exitfailure-9-when-trying-to-install-ghc-mod-using-cabal
dd if=/dev/zero of=/swapfile bs=256M count=4
mkswap /swapfile
swapon /swapfile

# Update package list
cabal update

# library needed by cabal-install (otherwise next step fails)
# may also need apt-get install zlibc, but I'm not sure
# I am pretty sure that installing zlibc without zlib1g-dev doesn't work, though
apt-get install zlib1g-dev

# Get the latest versions of cabal and cabal-install
# We need this for sandboxing (which I think we need to run this. I remember
# we were definitely using sandboxing at the hackathon where we wrote this)
cabal install cabal cabal-install

# Create sandbox -- may be optional (probably is)
cabal init

## If everything is all set up
# Install deps of the image app
cabal install --only-dependencies
# Build the app
cabal build
