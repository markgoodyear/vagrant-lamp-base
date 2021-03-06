Vagrant LAMP stack with Puppet
==============================
> A simple LAMP stack using Puppet for provisioning, based off Puphpet generator.


Includes:
---------

- Ubuntu Precise 64
- Apache 2.2.22
- PHP 5.4
- MySQL


Structure
---------

- Vagrant files and privisioning in `vagrant`
- Apache doc root is in `www`
- Auto imports database from `www/db/database.sql` on first `$ vagrant up`


Notes
-----
### Configuation
- Configurations for Vagrant are available in the `Vagrantfile` file
- Configurations for Puppet are available in the  `vagrant/manifests/config.pp` file

### Custom dot files
Custom dot files can be added in `vagrant/files/dot/`

### Dumping the database
Before `$ vagrant destroy` remember to dump the database if there has been any changes by ssh'ing into the box and running:
`$ mysqldump -u root -proot DATABASE_NAME > /vagrant/www/db/database.sql`

### Importing the database
If you need to import the database manually, ssh into the box and run:
 `$ mysql -u root -proot DATABASE_NAME <  /var/www/db/database.sql`



Access
------

- Access the box by the IP set in the `Vagrantfile`
- Alternately, set up an alias in the `vagrant/manifests/config.pp` file—an example is included
- LAN access uses your host machine IP along with the forwarded port set in the `Vagrantfile`. E.g. 192.168.2.14:8080
- SSH into the box with the command `$ vagrant ssh`
