# README

Weather Station, hosted on a Raspberry Pi. I'm using another RPi to post data to this server. There's no reason you couldn't have that all on one device, but for various reasons I have a more convoluted setup.

## Setting up my RPi

    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install gcc g++ make bison libyaml-dev libssl-dev libffi-dev zlib1g-dev libxslt-dev libxml2-dev libpq-dev zip nodejs vim libreadline-dev postgresql postgresql-contrib libpq-dev nginx wget git
    
    mkdir installs
    cd installs
    wget "https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.3.tar.gz"
    tar -zxvf ruby-2.4.3.tar.gz
    cd ruby-2.4.3
    ./configure --disable-install-rdoc
    make -j4
    sudo make install
    sudo gem install bundler --no-document
    
    sudo mkdir /www
    sudo chown pi:pi /www

    # On my local box:
    # ssh-copy-id -i ~/.ssh/mykey user@host
    
    sudo -i -u postgres
    > createuser -s -P rails
    > exit
    
    sudo vim /etc/postgresql/9.6/main/pg_hba.conf
    
    # Change the line below this comment from 'peer' to 'md5':
    # # "local" is for Unix domain socket connections only
    
    sudo service postgresql restart
    
    # Copy nginx config
    # Copy systemd config files
    
    
    # Setup Capistrano
    # This included deploy keys, deploy config, etc.
    # Create config files on server (application.yml, secrets.yml)
    
    # Deploy locally: bundle exec cap production deploy
    # Note: This takes _forever_ the first time.