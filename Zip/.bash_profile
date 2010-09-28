gpg-agent --daemon --enable-ssh-support --pinentry-program /usr/bin/pinentry-gtk-2 --write-env-file "/home/liveuser/.gpg-agent-info"

PATH=$PATH:$HOME
export PATH
