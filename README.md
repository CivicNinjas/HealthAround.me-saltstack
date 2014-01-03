Healthgeist Salt Stack
======================

Setup
-----

    sudo apt-get update
    sudo apt-get install git
    sudo git clone https://github.com/CivicNinjas/SitegeistHealth-saltstack.git /srv/salt
    cd /srv/salt
    sudo ./setupsalt
    sudo salt-call state.highstate
