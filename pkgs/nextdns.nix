{ writeShellApplication
, curl
, jq
}:
writeShellApplication {
  name = "nextdns";
  runtimeInputs = [ curl jq ];
  text = ''
    function usage {
      cat <<EOM
    Usage: $(basename "$0") [options] <action> [payload]

    Options:
      -k|--api-key <key>    the api key
      -h|--help             show usage information

    Arguments:
      action      get or set the rewrites
      [payload]   payload for the set action
    EOM
      exit 0
    }

    PARAMS=""
    API_KEY=""
    while (( "$#" )); do
      case "$1" in
        -h|--help)
          usage
          ;;
        -k|--api-key)
          if [ -n "$2" ] && [ "''${2:0:1}" != "-" ]; then
            API_KEY=$2
            shift 2
          else
            echo "Error: Missing API Key" >&2
            exit 1
          fi
          ;;
        -*) # unsupported flags
          echo "Error: Unsupported flag $1" >&2
          exit 1
          ;;
        *)
          PARAMS="$PARAMS $1"
          shift
          ;;
      esac
    done

    eval set -- "$PARAMS"

    if [[ "$API_KEY" == "" ]]; then
      echo "Error: You need to provide an API key!"
      exit 1
    fi

    if [[ "$1" == "get" ]]; then
      curl -sH "X-Api-Key: $API_KEY" https://api.nextdns.io/profiles/bdf4d2/rewrites | jq .
    elif [[ "$1" == "set" ]]; then
      echo "set"
    else
      echo "I don't understand ..."
      exit 1
    fi
  '';
}
