FROM microsoft/powershell
COPY pks-cli /usr/local/bin/pks
COPY pks /usr/local/share/powershell/Modules/pks
RUN chmod +x /usr/local/bin/pks