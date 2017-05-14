#!/usr/bin/env python3

import time
from collections import defaultdict

INTERFACES = [
    'enp2s0',
    'wlp3s0',
]


def sample_statistics(interface):
    t = {}

    t['rx_bytes_time'] = time.perf_counter()
    with open('/sys/class/net/{}/statistics/rx_bytes'.format(interface)) as f:
        t['rx_bytes'] = int(f.read())
    t['tx_bytes_time'] = time.perf_counter()
    with open('/sys/class/net/{}/statistics/tx_bytes'.format(interface)) as f:
        t['tx_bytes'] = int(f.read())

    return t


def compute(start, end):
    t = {}

    t['rx_kbytes_s'] = (end['rx_bytes'] - start['rx_bytes']) / (end['rx_bytes_time'] - start['rx_bytes_time']) / 131072
    t['tx_kbytes_s'] = (end['tx_bytes'] - start['tx_bytes']) / (end['tx_bytes_time'] - start['tx_bytes_time']) / 131072

    return t


def aggregate(statistics):
    t = defaultdict(float)

    for interface in INTERFACES:
        t['rx_kbytes_s'] += statistics[interface]['rx_kbytes_s']
        t['tx_kbytes_s'] += statistics[interface]['tx_kbytes_s']

    return dict(t)


def main():
    start = {}
    for interface in INTERFACES:
        start[interface] = sample_statistics(interface)

    time.sleep(1)

    end = {}
    for interface in INTERFACES:
        end[interface] = sample_statistics(interface)

    statistics = {}

    for interface in INTERFACES:
        statistics[interface] = compute(start[interface], end[interface])

    total = aggregate(statistics)

    print("OK - Total RX={0[rx_kbytes_s]:f}, Total TX={0[tx_kbytes_s]:f}".format(total), end='')
    print('|', end='')
    print('total_rx={0[rx_kbytes_s]:f}MB;;;; total_tx={0[tx_kbytes_s]:f}MB;;;; '.format(total), end='')

    for interface, interface_statistics in statistics.items():
        print('{0}_rx={1[rx_kbytes_s]:f}MB;;;; {0}_tx={1[tx_kbytes_s]:f}MB;;;; '.format(interface, interface_statistics), end='')

    print()

if __name__ == '__main__':
    main()
