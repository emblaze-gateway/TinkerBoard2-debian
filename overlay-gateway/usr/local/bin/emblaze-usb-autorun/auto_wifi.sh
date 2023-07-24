#!/bin/bash

FILE_NAME="wifi.txt"

wifi_enable()
{
		echo "EMBLAZE-USB: wifi on"
        nmcli radio wifi on
		sleep 5s
}

wifi_disable()
{
		echo "EMBLAZE-USB: wifi off"
        nmcli radio wifi off
        sleep 5s
}

event_handler()
{
        echo "EMBLAZE-USB: setting wifi"

        if [ ! -e "$1/$FILE_NAME" ]; then
                echo "EMBLAZE-USB: Not found $FILE_NAME"
                return 1
        fi

        wifi_config=$("$EMBLAZE_USB_DIRPATH/read_lines.sh" "$1/$FILE_NAME")
        wifi_enabled="$(echo $(echo $wifi_config | cut -d '\' -f1))d"
        if [ "$(nmcli r wifi)" != "$wifi_enabled" ]; then
                if [ "$wifi_enabled" == "disabled" ]; then
                        wifi_disable
                elif [ "$wifi_enabled" == "enabled" ]; then
                        wifi_enable
                else
                        echo "EMBLAZE-USB: Wrong written $1/$FILE_NAME"
                        return 1
                fi
        fi

		if [ "$(nmcli r wifi)" != "enabled" ]; then
            echo "EMBLAZE-USB: wifi NOT enabled"
            return 0
        fi

        detected_wifi_names=$(nmcli dev wifi)
        wifi_name="$(echo $(echo $wifi_config | cut -d '\' -f2))"
        wifi_password="$(echo $(echo $wifi_config | cut -d '\' -f3))"
        if [ ! -z "${wifi_name}" ]; then
            is_wifi_exist=$(if echo "${detected_wifi_names}" | grep -q "${wifi_name}"; then echo "yes"; else echo "no"; fi)
            if [ "${is_wifi_exist}" = "yes" ]; then
                    if [ -z "${wifi_password}" ]; then
                            echo "EMBLAZE-USB: $(nmcli dev wifi connect ${wifi_name})"
                            # TODO: 에러 핸들링
                    else
                            echo "EMBLAZE-USB: $(nmcli dev wifi connect ${wifi_name} password ${wifi_password})"
                            # TODO: 에러 핸들링
                    fi
            else
                    echo "EMBLAZE-USB: NOT detected signal by ${wifi_name}"
            fi
        fi
}

event_handler $1
