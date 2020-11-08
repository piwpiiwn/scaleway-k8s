FROM hashicorp/terraform:0.13.5

RUN wget -o /bin/scw https://github.com/scaleway/scaleway-cli/releases/download/v2.2.2/scw-2.2.2-linux-x86_64 \
    && chmod +x /bin/scw
WORKDIR /app
COPY *.tf *.tfvars entrypoint.sh /app/

ENTRYPOINT ["/app/entrypoint.sh"]
