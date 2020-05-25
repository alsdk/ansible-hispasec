#!/usr/bin/env bash
case $SSH_ORIGINAL_COMMAND in
    "/usr/bin/docker-compose "*)
        $SSH_ORIGINAL_COMMAND
        ;;
    "/usr/bin/git "*)
        $SSH_ORIGINAL_COMMAND
        ;;
    *)
        echo "Permission denied."
        exit 1
        ;;
esac
