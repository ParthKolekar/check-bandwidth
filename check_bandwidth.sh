#!/bin/bash

if [[ -n $DEBUG ]]; then
	set -x
fi

INTERFACES=(wlp3s0)

declare -A statistics

for interface in $INTERFACES; do
	if [[ -r /sys/class/net/$interface/statistics/rx_bytes ]]; then
		statistics[rx_bytes_start]=$(cat /sys/class/net/$interface/statistics/rx_bytes) && statistics[rx_bytes_start_time]="$(date +%s%N)"
	fi

	if [[ -r /sys/class/net/$interface/statistics/tx_bytes ]]; then
		statistics[tx_bytes_start]=$(cat /sys/class/net/$interface/statistics/tx_bytes) && statistics[tx_bytes_start_time]="$(date +%s%N)"
	fi

	if [[ -r /sys/class/net/$interface/statistics/rx_packets ]]; then
		statistics[rx_packets_start]=$(cat /sys/class/net/$interface/statistics/rx_packets) && statistics[rx_packets_start_time]="$(date +%s%N)"
	fi

	if [[ -r /sys/class/net/$interface/statistics/tx_packets ]]; then
		statistics[tx_packets_start]=$(cat /sys/class/net/$interface/statistics/tx_packets) && statistics[tx_packets_start_time]="$(date +%s%N)"
	fi
done

sleep 1

for interface in $INTERFACES; do
	if [[ -r /sys/class/net/$interface/statistics/rx_bytes ]]; then
		statistics[rx_bytes_end]=$(cat /sys/class/net/$interface/statistics/rx_bytes) && statistics[rx_bytes_end_time]="$(date +%s%N)"
	fi

	if [[ -r /sys/class/net/$interface/statistics/tx_bytes ]]; then
		statistics[tx_bytes_end]=$(cat /sys/class/net/$interface/statistics/tx_bytes) && statistics[tx_bytes_end_time]="$(date +%s%N)"
	fi

	if [[ -r /sys/class/net/$interface/statistics/rx_packets ]]; then
		statistics[rx_packets_end]=$(cat /sys/class/net/$interface/statistics/rx_packets) && statistics[rx_packets_end_time]="$(date +%s%N)"
	fi

	if [[ -r /sys/class/net/$interface/statistics/tx_packets ]]; then
		statistics[tx_packets_end]=$(cat /sys/class/net/$interface/statistics/tx_packets) && statistics[tx_packets_end_time]="$(date +%s%N)"
	fi
done

for interface in $INTERFACES; do
	statistics[rx_bytes]=$(( ${statistics[rx_bytes_end]} - ${statistics[rx_bytes_start]} ))
	statistics[rx_bytes_time]=$(( ${statistics[rx_bytes_end_time]} - ${statistics[rx_bytes_start_time]} ))

	statistics[tx_bytes]=$(( ${statistics[tx_bytes_end]} - ${statistics[tx_bytes_start]} ))
	statistics[tx_bytes_time]=$(( ${statistics[tx_bytes_end_time]} - ${statistics[tx_bytes_start_time]} ))

	statistics[rx_packets]=$(( ${statistics[rx_packets_end]} - ${statistics[rx_packets_start]} ))
	statistics[rx_packets_time]=$(( ${statistics[rx_packets_end_time]} - ${statistics[rx_packets_start_time]} ))

	statistics[tx_packets]=$(( ${statistics[tx_packets_end]} - ${statistics[tx_packets_start]} ))
	statistics[tx_packets_time]=$(( ${statistics[tx_packets_end_time]} - ${statistics[tx_packets_start_time]} ))

	echo $(echo \( ${statistics[rx_bytes]} / 131072 \)  / \( ${statistics[rx_bytes_time]} \* 0.000000001 \) | bc -l) in Megabytes / Seconds
	echo $(echo \( ${statistics[tx_bytes]} / 131072 \)  / \( ${statistics[tx_bytes_time]} \* 0.000000001 \) | bc -l) in Megabytes / Seconds

	echo $(echo ${statistics[rx_packets]} / \( ${statistics[rx_packets_time]} \* 0.000000001 \) | bc -l) in Packets / Seconds
	echo $(echo ${statistics[tx_packets]} / \( ${statistics[tx_packets_time]} \* 0.000000001 \) | bc -l) in Packets / Seconds
done
