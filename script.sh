#!/bin/bash
database () {
	read -p "enter the application:" service
status=$(systemctl is-active $service)
if [ $status == "inactive" ]
then
	sudo dnf install $service -y
        sudo systemctl enable --now $service
        sudo firewall-cmd --add-port=80/tcp --permanent
	sudo firewall-cmd --reload
	sudo setenforce 0
	sudo getenforce
	echo "service installed successfully!!"
        sudo sed -i s/local/"all granted"/g /etc/httpd/conf.d/phpMyAdmin.conf
	sudo systemctl restart mysqld.service
	sudo systemctl restart httpd.service
	sudo mysql -u root -p -e 'alter user "root"@"localhost" identified by"redhat";flush privileges;'
	
fi	
}
database "httpd"
database "mysql-server"
database "phpmyadmin"

