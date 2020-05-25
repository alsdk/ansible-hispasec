
.. code-block::

    $ docker exec --user root -ti pretix_gunicorn_1 bash
    chown pretixuser:pretixuser /pretix/src/pretix/locale/es/LC_MESSAGES/*
    chown pretixuser:pretixuser /pretix/src/pretix/helpers/locale/es/LC_MESSAGES/*


    $ docker exec -ti pretix_gunicorn_1 bash
    cd /pretix/src
    export DJANGO_SETTINGS_MODULE=production_settings
    export DATA_DIR=/data/
    export HOME=/pretix
    export NUM_WORKERS=$((2 * $(nproc --all)))

    python -m pretix makemessages -l es
    python -m pretix compilemessages -l es
    python -m pretix compress
    python -m pretix collectstatic --noinput
    python -m pretix createsuperuser


pretix/presale/templates/pretixpresale/base_footer.html

pretixuser@cc00b75742e9:~/src$ grep -R "powered by" | grep -v jsi18n | grep -v locale | grep -v static.dist | grep -v bootstrap
pretix/base/templates/pretixbase/email/email_footer.html:        powered by <a {{ a_attr }}>pretix</a>
pretix/static/pretixpresale/js/widget/widget.js:        ' ticketing powered by pretix</a>'),
pretix/static/pretixpresale/pdf/powered_by_pretix_white.svg:           style="stroke-width:1.19167638px;fill:#ffffff;">ticketing powered by</tspan></text>
pretix/static/pretixpresale/pdf/powered_by_pretix_dark.svg:           style="stroke-width:1.19167638px">ticketing powered by</tspan></text>
pretix/control/templates/pretixcontrol/auth/base.html:                powered by <a {{ a_attr }}>pretix</a>
pretix/control/templates/pretixcontrol/base.html:                                powered by <a {{ a_attr }}>pretix</a>
setup.cfg:    ticketing powered by
setup.cfg:    powered by
