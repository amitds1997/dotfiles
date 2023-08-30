if [[ $(uname) == "Darwin" ]]; then
  /usr/local/bin/brew update && /usr/local/bin/brew upgrade
  /usr/local/bin/brew bundle dump --no-upgrade --force --file ${HOME}/.config/brew/Brewfile
  echo " Wrote current brew package info into the Brewfile"
fi

# Update list of crons
mkdir -p ${HOME}/bin/cron
crontab -l >| ${HOME}/bin/cron/cron_list
