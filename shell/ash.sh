# VS Code needs to install the remote server and extensions as `root`.
# The interactive shell should run as `node`.
if [ "$(whoami)" == 'root' ]; then
  su node
else
  NODE_VERSION="$(node --version | sed -r 's/^v//')"
  NPM_VERSION="$(npm --version)"
  NPX_VERSION="$(npx --version)"
  YARN_VERSION="$(yarn --version)"

  ls() {
    echo ""
    pwd
    # TODO: Good enough in this specific context,
    #       but find a way to make the column
    #       formatting generically robust. Because.
    command ls -Al --color --group-directories-first --full-time ${1} \
    | tail -n+2 \
    | awk '{u=$3":"$4; t=$6"T"$7"Z"; print $1, "", u, "", t, "", $9, $10, $11}'
    echo ""
  }

  # TODO: RTFM
  spray() {
    echo "\e[${1}m${2}\e[0m"
  }

  cyan() {
    echo $(spray '36' "${1}")
  }

  green() {
    echo $(spray '32' "${1}")
  }

  magenta() {
    echo $(spray '35' "${1}")
  }

  red() {
    echo $(spray '1;31' "${1}")
  }

  yellow() {
    echo $(spray '33' "${1}")
  }

  update() {
    echo ""
    npm install --loglevel error --no-optional ${@}
  }

  add() {
    update ${@}
  }

  remove() {
    echo ""
    npm uninstall --loglevel error ${@}
  }

  lint() {
    npm -s run lint

    if [ "${?}" -eq 0 ]; then
      echo ""
      echo -e "All good $(green ':-)')"
    else
      echo -e $(yellow 'Trying to fix errors automagically...')
      npm -s run lint -- --fix

      if [ "${?}" -eq 0 ]; then
        echo ""
        echo -e "All good $(green ':-)')"
      else
        echo -e "There are errors that must be fixed manually $(red ':-(')"
      fi
    fi

    echo ""
  }

  test() {
    echo ""
    npm -s test
    echo $?
    echo ""
  }

  qa() {
    lint
    test
  }

  list() {
    echo ""

    if [ ${#} -eq 0 ]; then
      npm -s ls --depth=0
    else
      npm -s ls ${1}
    fi
  }

  help() {
    echo ""
    echo -e "$(yellow 'node'): ${NODE_VERSION}"
    echo -e " $(yellow 'npm'): ${NPM_VERSION}"
    echo -e " $(yellow 'npx'): ${NPX_VERSION}"
    echo -e "$(yellow 'yarn'): ${YARN_VERSION}"
    echo ""
  }

  export PS1="$(magenta '>>')$(cyan '${PROJECT}')$(magenta '>>') "

  echo ""
  echo -e "You are working as the $(yellow $(whoami)) user in $(yellow $(pwd))."
  echo ""
  echo -e "Manage $(yellow npm) dependencies with the commands"
  echo -e "  $(yellow 'add') $(cyan '[packages...]') and"
  echo -e "  $(yellow 'remove') $(cyan '[packages...]'), but let's first"
  echo -e "  $(yellow 'update')"
  echo "the project:"

  update

  echo -e "Run the $(yellow 'help') command for more information."
  echo ""
fi
