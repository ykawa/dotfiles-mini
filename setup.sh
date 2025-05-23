#!/bin/bash
# set -e
# set -u
# set -x

hash -r

check_lacking_commands()
{
  for command in $@; do
    if ! type "$command" >/dev/null 2>&1; then
      echo "ERROR: < ${command} > is not available." >&2
      exit 1
    else
      echo "check ${command} ... ok"
    fi
  done
}

check_lacking_commands ssh git perl curl
unset check_lacking_commands

# Add github.com to ~/.ssh/known_hosts
ssh -T -n -o StrictHostKeyChecking=accept-new git@github.com

if [[ ! -d "dotfiles-mini" ]]; then
  git clone https://github.com/ykawa/dotfiles-mini $HOME/dotfiles-mini
fi

for df in dotfiles-mini/dot.*; do
  if [[ ! -f "${df}" && ! -d "${df}" ]]; then
    continue
  fi

  link="${df##dotfiles-mini/dot}"
  if [[ -e "${link}" || -L "${link}" ]]; then
    mv -fv "${link}" "${link}.bak"
  fi
  ln -s "${df}" "${link}"
done

echo "Done."
