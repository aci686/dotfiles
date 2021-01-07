
#!/usr/bin/env sh

# Terminate already running bar instances
pgrep polybar | xargs kill -9

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launc bar
#polybar main -c ~/.config/polybar/config.ini &
polybar -q top -c ~/.config/polybar/config.ini &
polybar -q bottom -c ~/.config/polybar/config.ini &
