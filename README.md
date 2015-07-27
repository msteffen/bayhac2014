bayhac2014
==========

Small haskell webapp using Scotty and ImageMagick

If you're on a VM and need to update cabal first:
-------------------------------------------------
- Create a swap file (digitalocean and AWS VMs have no swap by default)

  See http://stackoverflow.com/questions/13104630/exitfailure-9-when-trying-to-install-ghc-mod-using-cabal

        dd if=/dev/zero of=/swapfile bs=256M count=4
        mkswap /swapfile
        swapon /swapfile

- Update package list

        cabal update

- Install zlib library needed by cabal-install (otherwise next step fails)
	
	(You may also need apt-get install zlibc, but I'm not sure. I'm pretty sure that installing zlibc without zlib1g-dev doesn't work, though)

        apt-get install zlib1g-dev

- Get the latest versions of cabal and cabal-install

	We need this for sandboxing (which we use below)

        cabal install cabal cabal-install

- Create sandbox

	(Necessary, because otherwise I get package conflicts every time)

        cabal sandbox init

If everything is all set up
---------------------------
- Install PostgreSQL (needed by one of the cabal dependencies)

        apt-get install postgresql-server-dev-9.3

	(It's possible that `postgresql-server-dev-all` also works, but `-9.3` was the only package I tried)

- Install deps of the image app

        cabal install --only-dependencies

- Build the app

        cabal build
