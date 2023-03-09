if [[ $(uname) == "Darwin" ]]; then
  /usr/local/bin/brew bundle dump --no-upgrade --force --file ${HOME}/.config/brew/Brewfile
  echo " Wrote current brew package info into the Brewfile"
fi

mkdir -p ${HOME}/bin/cron
crontab -l >| ${HOME}/bin/cron/cron_list
