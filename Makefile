imagename=jottr/mysql-server

build: 
	docker build -t $(imagename) .
	notify-send "Done building $(imagename)." 

clean: 
	docker rmi $(imagename)
