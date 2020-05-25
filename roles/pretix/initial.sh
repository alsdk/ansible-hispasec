#!/usr/bin/env bash
cd /pretix/src
export DJANGO_SETTINGS_MODULE=production_settings
export DATA_DIR=/data/
export HOME=/pretix
export NUM_WORKERS=$((2 * $(nproc --all)))

python -m pretix makemessages -l es
python -m pretix compilemessages -l es
python -m pretix collectstatic --noinput
python -m pretix compress
python -m pretix createsuperuser
