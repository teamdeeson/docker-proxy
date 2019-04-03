default: start

certificate:
	./scripts/genlocalcrt.sh clean

start:
	./scripts/start.sh

stop:
	./scripts/stop.sh

status:
	./scripts/status.sh

status-watch:
	watch -n 300 ./scripts/status.sh

view-logs:
	./scripts/logs.sh
