#! /bin/sh

### BEGIN INIT INFO
# Provides:          Feelicity application instance
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts instance of feelicity app
# Description:       starts instance of feelicity app using start-stop-daemon
### END INIT INFO

############### EDIT ME ##################
# path to workingenv install if any
PYTHONPATH=/usr/lib/python2.6

# path to app
APP_PATH=/var/www/feelicity/current

# path to paster bin
DAEMON=/usr/local/bin/paster

# startup args
DAEMON_OPTS=" serve --log-file /var/log/feelicity.log production.ini"

# script name
NAME=feelicity

# app name
DESC=Feelicity

# pylons user
RUN_AS=www-data

PID_FILE=/var/run/paster.pid

############### END EDIT ME ##################

test -x $DAEMON || exit 0

set -e

case "$1" in
  start)
        echo -n "Starting $DESC: "
        start-stop-daemon -d $APP_PATH -c $RUN_AS --start --background --pidfile $PID_FILE  --make-pidfile --exec $DAEMON -- $DAEMON_OPTS
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
        start-stop-daemon --stop --pidfile $PID_FILE
        echo "$NAME."
        ;;

  restart|force-reload)
        echo -n "Restarting $DESC: "
        start-stop-daemon --stop --pidfile $PID_FILE
        sleep 1
        start-stop-daemon -d $APP_PATH -c $RUN_AS --start --background --pidfile $PID_FILE  --make-pidfile --exec $DAEMON -- $DAEMON_OPTS
        echo "$NAME."
        ;;
  *)
        N=/etc/init.d/$NAME
        echo "Usage: $N {start|stop|restart|force-reload}" >&2
        exit 1
        ;;
esac

exit 0