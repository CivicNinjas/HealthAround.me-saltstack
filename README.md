Healthgeist Salt Stack
======================

Setup
-----

    sudo apt-get update
    sudo apt-get install git
    sudo git clone https://github.com/CivicNinjas/SitegeistHealth-saltstack.git /srv/salt
    sudo cp -a pillar-example /srv/pillar
    ### EDIT /srv/pillar/data.sls to include real passwords
    cd /srv/salt
    sudo ./setupsalt-minion
    sudo cp /srv/salt/etc/salt/minion /etc/salt/minion
    sudo salt-call state.highstate
