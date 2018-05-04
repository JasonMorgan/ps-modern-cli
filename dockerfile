FROM microsoft/powershell
COPY pks-cli /usr/local/bin/pks
COPY pks /usr/local/share/powershell/Modules/pks
RUN chmod +x /usr/local/bin/pks && \
  apt-get update && \
  apt-get install ruby g++ make ruby-dev -y && \
  gem install cf-uaac && \
  curl -o om https://github.com/pivotal-cf/om/releases/download/0.36.0/om-linux && \
  chmod +x om && \
  mv om /usr/local/bin