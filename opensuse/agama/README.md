# Agama installer notes

To generat initial configuration start installer and fill out all questions up to point that 'Install' button becomes available. In that state do NOT press the 'Install' button, but instead use console to get current configuration with command below.
~~~
# agama config show
~~~

For consistency re-order the content from that command with jq.
~~~
# cat config.json | jq -S .
~~~
