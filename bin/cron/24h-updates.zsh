if [[ $(uname) == "Darwin" ]]; then
  brew bundle dump --no-upgrade --force --file ${XDG_CONFIG_HOME}/brew/Brewfile
  echo " Wrote current brew package info into the Brewfile"
fi

mkdir -p ${HOME}/bin/cron
crontab -l >| ${HOME}/bin/cron/cron_list
