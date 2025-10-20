#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
# Author : Aditya Shakya (adi1090x) - Adapté version UTF-8-safe
# GitHub : @adi1090x
# Rofi Power Menu (compatible Nerd Fonts)
#
# Styles disponibles : style-1 .. style-5

# Chemin du thème
dir="$HOME/.config/rofi/powermenu/type-4"
theme='style-3'

# Uptime
uptime="$(uptime -p | sed -e 's/up //g')"

# Icônes (en Unicode sécurisé)
shutdown=$(printf '\U0000E9C0')  # 
reboot=$(printf '\U0000E9C4')    # 
lock=$(printf '\U0000E98F')      # 
suspend=$(printf '\U0000E9A3')   # 
logout=$(printf '\U0000E991')    # 
yes=$(printf '\U0000E92C')       # 
no=$(printf '\U0000EA12')        # 

# Commande rofi principale
rofi_cmd() {
	rofi -dmenu \
		-p "Get out :(" \
		-mesg "Uptime: $uptime" \
		-theme "${dir}/${theme}.rasi"
}

# Confirmation
confirm_cmd() {
	rofi -dmenu \
		-p 'Confirmation' \
		-mesg 'Are you sure?' \
		-theme "${dir}/shared/confirm.rasi"
}

# Confirmation yes/no
confirm_exit() {
	printf "%s\n%s\n" "$yes" "$no" | confirm_cmd
}

# Menu principal
run_rofi() {
	printf "%s\n%s\n%s\n%s\n%s\n" "$lock" "$suspend" "$logout" "$reboot" "$shutdown" | rofi_cmd
}

# Exécution des commandes système
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		case "$1" in
			--shutdown) systemctl poweroff ;;
			--reboot)   systemctl reboot ;;
			--suspend)
				command -v mpc >/dev/null && mpc -q pause
				command -v amixer >/dev/null && amixer set Master mute
				systemctl suspend ;;
			--logout)
				case "$DESKTOP_SESSION" in
					openbox) openbox --exit ;;
					bspwm)   bspc quit ;;
					i3)      i3-msg exit ;;
					plasma)  qdbus org.kde.ksmserver /KSMServer logout 0 0 0 ;;
				esac
				[[ "$XDG_CURRENT_DESKTOP" == "Hyprland" ]] && hyprctl dispatch exit
				;;
		esac
	else
		exit 0
	fi
}

# Actions selon le choix
chosen="$(run_rofi)"
case "$chosen" in
	"$shutdown") run_cmd --shutdown ;;
	"$reboot")   run_cmd --reboot ;;
	"$lock")
		if [[ -x /usr/bin/betterlockscreen ]]; then
			betterlockscreen -l
		elif [[ -x /usr/bin/i3lock ]]; then
			i3lock
		elif [[ -x /usr/bin/hyprlock ]]; then
			hyprlock
		fi
		;;
	"$suspend")  run_cmd --suspend ;;
	"$logout")   run_cmd --logout ;;
esac
