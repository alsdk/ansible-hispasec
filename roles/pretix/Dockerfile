FROM pretix/standalone:stable
COPY production_settings.py /pretix/src/
WORKDIR /pretix/src/
ENTRYPOINT ["gunicorn"]
RUN echo "UAD360" > /pretix/src/pretix/presale/templates/pretixpresale/base_footer.html
RUN echo "" > /pretix/src/pretix/base/templates/pretixbase/email/email_footer.html
RUN sed -i -e 's/powered by <a {{ a_attr }}>pretix<\/a>//g' /pretix/src/pretix/control/templates/pretixcontrol/auth/base.html
RUN sed -i -e 's/powered by <a {{ a_attr }}>pretix<\/a>//g' /pretix/src/pretix/control/templates/pretixcontrol/base.html
RUN sed -i -e 's/ticketing powered by pretix//g' /pretix/src/pretix/static/pretixpresale/js/widget/widget.js
RUN sed -i -e 's/pretix.eu/UAD360/g' /pretix/src/pretix/base/invoice.py
USER root
COPY *.po /pretix/src/pretix/locale/es/LC_MESSAGES/
COPY favicons/* /pretix/src/pretix/static/pretixbase/img/icons/
COPY favicons/favicon.ico /pretix/src/pretix/static/pretixbase/img/
COPY initial.sh /
RUN chmod +x /initial.sh
RUN /initial.sh
USER pretixuser
# RUN chown pretixuser:pretixuser /pretix/src/pretix/locale/es/LC_MESSAGES/*
CMD ["pretix.wsgi", "--name", "pretix", "--max-requests", "1200", "--max-requests-jitter", "50", "--bind", "0.0.0.0:8000"]
