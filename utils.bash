CALLING_COMMAND="$0 $*"
trap "exit 1" TERM

export TOP_PID=$$

# Colorlist used by this script
export COLOR_txtblk='\033[0;30m' # Black - Regular
export COLOR_txtred='\033[0;31m' # Red
export COLOR_txtgrn='\033[0;32m' # Green
export COLOR_txtylw='\033[0;33m' # Yellow
export COLOR_txtblu='\033[0;34m' # Blue
export COLOR_txtpur='\033[0;35m' # Purple
export COLOR_txtcyn='\033[0;36m' # Cyan
export COLOR_txtwht='\033[0;37m' # White
export COLOR_txtgry='\033[1;30m' # White
export COLOR_bldblk='\033[1;30m' # Black - Bold
export COLOR_bldred='\033[1;31m' # Red
export COLOR_bldgrn='\033[1;32m' # Green
export COLOR_bldylw='\033[1;33m' # Yellow
export COLOR_bldblu='\033[1;34m' # Blue
export COLOR_bldpur='\033[1;35m' # Purple
export COLOR_bldcyn='\033[1;36m' # Cyan
export COLOR_bldwht='\033[1;37m' # White
export COLOR_unkblk='\033[4;30m' # Black - Underline
export COLOR_undred='\033[4;31m' # Red
export COLOR_undgrn='\033[4;32m' # Green
export COLOR_undylw='\033[4;33m' # Yellow
export COLOR_undblu='\033[4;34m' # Blue
export COLOR_undpur='\033[4;35m' # Purple
export COLOR_undcyn='\033[4;36m' # Cyan
export COLOR_undwht='\033[4;37m' # White
export COLOR_bakblk='\033[40m'   # Black - Background
export COLOR_bakred='\033[41m'   # Red
export COLOR_bakgrn='\033[42m'   # Green
export COLOR_bakylw='\033[43m'   # Yellow
export COLOR_bakblu='\033[44m'   # Blue
export COLOR_bakpur='\033[45m'   # Purple
export COLOR_bakcyn='\033[46m'   # Cyan
export COLOR_bakwht='\033[47m'   # White
export COLOR_txtrst='\033[0m'    # Text Reset

# Being able to terminate out of everywhere
function terminate
{
   #info "Terminated by itself. Called with: $CALLING_COMMAND"
   loginfo "Terminated on $(logdate). Called by $CALLING_COMMAND."
   kill -s TERM $TOP_PID
}

# Output logging
function logdate {
    printf "$(date +'%d.%m.%Y %H:%M:%S')\n"
}
function logdebug {
    [ "$LOGLEVEL" == "debug" ] && printf "[$(logdate)] [${COLOR_bldcyn}DEBUG${COLOR_txtrst}  ] ${COLOR_txtcyn}$*${COLOR_txtrst}\n"
}
function logwarn {
    [ "$LOGLEVEL" == "debug" -o "$LOGLEVEL" == "warn" ] && printf "[$(logdate)] [${COLOR_bldylw}WARNING${COLOR_txtrst}] ${COLOR_txtylw}$*\n${COLOR_txtrst}"
}
function loginfo {
    [ "$LOGLEVEL" == "debug" -o "$LOGLEVEL" == "warn" -o "$LOGLEVEL" == "info" ] && printf "[$(logdate)] [${COLOR_bldwht}INFO${COLOR_txtrst}   ] $*\n"
}
function logerror {
    printf "[$(logdate)] [${COLOR_bldred}ERROR${COLOR_txtrst}  ] ${COLOR_txtred}$*${COLOR_txtrst}\n"
}
function logsuccess {
    printf "[$(logdate)] [${COLOR_bldgrn}SUCCESS${COLOR_txtrst}] ${COLOR_txtgrn}$*${COLOR_txtrst}\n"
}
function logparam {
    printf "[$(logdate)] [${COLOR_bldpur}PARAM${COLOR_txtrst}  ] ${COLOR_txtgry}$1${COLOR_txtrst} ${COLOR_txtpur}$2${COLOR_txtrst}\n"
}


function logcow() {
    MSG=$1
    SCRIPT_DIR_L=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
    ROOT_DIR_L=${SCRIPT_DIR_L}/../
    COWSAY="$ROOT_DIR_L/frontend/node_modules/.bin/cowsay"
    LOLCAT="$ROOT_DIR_L/frontend/node_modules/.bin/lolcatjs"

    if [[ -e "$COWSAY" && -e "$LOLCAT" ]]; then
        $COWSAY $MSG | $LOLCAT
    else
        logsuccess $MSG
    fi
}


# Show this scripts usage
function showUsageAndExit {
    showUsage
    terminate
}

function showUsage {
    logwarn "--> Usage information should be printed here."
}

function trycatch {
    # $RETVAL $TMPFILE "PIP installed dependencies successfully." "PIP install failed with return code: $RETVAL"
    RETVAL=$1
    LOGFILE=$2
    MSG_OK=$3
    MSG_FAIL=$4

    if [ $RETVAL -eq 0 ]; then
        logsuccess $MSG_OK
        rm $LOGFILE
    else
        cat $LOGFILE
        rm $LOGFILE
        logerror "${MSG_FAIL} Return code: $RETVAL"
        terminate
    fi;
}

function softtrycatch {
    # $RETVAL $TMPFILE "PIP installed dependencies successfully." "PIP install failed with return code: $RETVAL"
    RETVAL=$1
    LOGFILE=$2
    MSG_OK=$3
    MSG_WARN=$4

    if [ $RETVAL -eq 0 ]; then
        logsuccess $MSG_OK
        rm $LOGFILE
    else
        cat $LOGFILE
        rm $LOGFILE
        logwarn "${MSG_WARN} Return code: $RETVAL"
    fi;
}