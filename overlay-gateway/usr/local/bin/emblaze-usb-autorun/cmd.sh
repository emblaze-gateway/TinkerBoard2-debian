#!/bin/bash

FILE_NAME="cmd.txt"

cmds()
{
        arg="$1"
        case $arg in
                "echo")
                        text=$@
                        echo "EMBLAZE-USB: $text"
                        echo "EMBLAZE-USB: $text" > /dev/kmsg
                        ;;
                "reboot")
                        sleep 3
                        sync
                        reboot
                        return 0
                        ;;
                "shutdown")
                        sleep 3
                        sync
                        shutdown now
                        return 0
                        ;;
                "restart")
                        shift 1
                        arg="$1"
                        case $arg in
                                "gateway")
                                        systemctl restart emblaze-gateway.service
                                        ;;
                                "all")
                                        systemctl stop emblaze-gateway.service
                                        sleep 1s
                                        systemctl stop rabbitmq.service
                                        sleep 1s
                                        systemctl stop bluetooth-mesh.service
                                        sleep 1s
                                        systemctl start bluetooth-mesh.service
                                        sleep 1s
                                        systemctl start rabbitmq.service
                                        sleep 1s
                                        systemctl start emblaze-gateway.service
                                        ;;
                                *)
                                        echo "EMBLAZE-USB: Unknown restart service: $arg"
                                        ;;
                        esac
                        ;;
                # "apt")
                #         shift 1
                #         arg="$1"
                #         case $arg in
                #                 "update")
                #                         apt update
                #                         ;;
                #                 "install")
                #                         shift 1
                #                         apt install -y $@
                #                         apt install -f -y
                #                         ;;
                #         esac
                #         ;;
                "sleep")
                        shift 1
                        arg="$1"
                        sleep "$arg"
                        ;;
                *)
                        echo "EMBLAZE-USB: Unknown cmd: $arg"
                        ;;
        esac
}

event_handler()
{
        echo "EMBLAZE-USB: command"

        if [ ! -e "$1/$FILE_NAME" ]; then
                echo "EMBLAZE-USB: Not found $FILE_NAME"
                return 1
        fi

        cmd_list=$("$EMBLAZE_USB_DIRPATH/read_lines.sh" "$1/$FILE_NAME")

        i=1
        while true; do
                line="$(echo $(echo $cmd_list | cut -d '\' -f$i))"
                if [ -z "$line" ]; then
                        break
                fi
                cmds $line
                i="$(expr $i + 1)"
        done
}

event_handler $1
