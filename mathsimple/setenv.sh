#!/bin/bash

# run on port 8088
sed -Ei 's/Connector port="8080" protocol="HTTP\/1.1"/Connector port="8092" protocol="HTTP\/1.1"/' $CATALINA_HOME/conf/server.xml

# set EM host and port
sed -Ei "s/agentManager.url.1=.*/agentManager.url.1=${EM_HOST}:${EM_PORT}/" $WILY_HOME/core/config/IntroscopeAgent.profile

# agent properties
sed -Ei 's/introscope.agent.deep.instrumentation.level=low/introscope.agent.deep.instrumentation.level=high/' $WILY_HOME/core/config/IntroscopeAgent.profile
sed -Ei 's/introscope.agent.remoteagentdynamicinstrumentation.enabled=false/introscope.agent.remoteagentdynamicinstrumentation.enabled=true/' $WILY_HOME/core/config/IntroscopeAgent.profile

# set agent hostname
if [ -n "$AGENT_HOSTNAME" ]; then
    AGENT_HOSTNAME_ARG="-Dintroscope.agent.hostName=${AGENT_HOSTNAME}"
else
    AGENT_HOSTNAME_ARG=""
fi

# set mathapp properties
MATHAPP_ARGS="-DproxyHost=${PROXY_HOST} -DproxyPort=${PROXY_PORT} -DsimpleHost=${SIMPLE_HOST} -DsimplePort=${SIMPLE_PORT} -DcomplexHost=${COMPLEX_HOST} -DcomplexPort=${COMPLEX_PORT}"

# now add the APM agent to Tomcat startup parameters
export CATALINA_OPTS="$CATALINA_OPTS -Xmx$HEAP -javaagent:$WILY_HOME/Agent.jar -Dcom.wily.introscope.agentProfile=$WILY_HOME/core/config/IntroscopeAgent.profile -Dcom.wily.introscope.agent.agentName=$AGENT_NAME $AGENT_HOSTNAME_ARG $MATHAPP_ARGS"

echo $CATALINA_OPTS
