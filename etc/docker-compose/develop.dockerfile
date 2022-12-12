ARG WILDFLY_BASE_IMAGE

FROM $WILDFLY_BASE_IMAGE

RUN /opt/jboss/wildfly/bin/add-user.sh admin admin --silent

ARG COMMON_CLI_DIR=wildfly/cli/common

#service specifikus cli scriptek, alapértelmezetten noop
ARG SERVICE_CLI_DIR=wildfly/cli/noop

ARG TMP_DIR=$HOME/tmp

COPY $COMMON_CLI_DIR/*.* $TMP_DIR/common/
COPY $SERVICE_CLI_DIR/*.* $TMP_DIR/service/


RUN set -x; \
    echo "TMP_DIR=$TMP_DIR" >> $TMP_DIR/wf.properties && \
    /opt/jboss/wildfly/bin/jboss-cli.sh \
        --file=$TMP_DIR/service/embed-server.cli \
        --properties=$TMP_DIR/wf.properties \
    && rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current/*

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-P", "/sampler/wildfly.properties", "--debug", "*:8787", "--server-config=standalone-microprofile.xml"]
