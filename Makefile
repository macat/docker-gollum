imagename=jottr/gollum

build:
	docker build -t $(imagename) .
	notify-send "Done building $(imagename)."
	blink-thinklight 3


clean:
	docker rmi $(imagename)
