#!/usr/bin/env python
import subprocess

LOGS_FILE = 'data/nginx/log/nginx.access.log'
REQUIRED_CONTENT = 'GET /autorizar-ip/'
OUTPUT_FILE = 'conf/nginx/conf.d/ips_whitelist'


def get_ips(file, required_content):
    items = set()
    with open(file) as f:
        for line in filter(lambda x: required_content in x, f):
            if not line:
                continue
            ip, _ = line.split(' ', 1)
            if ip not in items:
                items.add(ip)
                yield ip


def write_ips_file(ips, output_file):
    with open(output_file, 'w') as f:
        for ip in ips:
            f.write('allow {};\n'.format(ip))


def main():
    ips = get_ips(LOGS_FILE, REQUIRED_CONTENT)
    write_ips_file(ips, OUTPUT_FILE)
    subprocess.call(['docker-compose', 'exec', 'nginx', 'nginx', '-s', 'reload'])


if __name__ == '__main__':
    main()
