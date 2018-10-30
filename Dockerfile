FROM jenkins/jenkins:lts
ENV JENKINS_REF /usr/share/jenkins/ref

USER root

# Install Git & Docker
RUN apt-get -y install git && \
    curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh

# Install Jenkins Plugins
COPY plugins.txt $JENKINS_REF/
RUN /usr/local/bin/install-plugins.sh < $JENKINS_REF/plugins.txt

# Configure jenkins as code
COPY jenkins.yaml /tmp/jenkins.yaml
ENV CASC_JENKINS_CONFIG=/tmp/jenkins.yaml

# Set Java options
ENV JAVA_OPTS -Dorg.eclipse.jetty.server.Request.maxFormContentSize=100000000 \
 			  -Dorg.apache.commons.jelly.tags.fmt.timeZone=America/New_York \
 			  -Dhudson.diyChunking=false \
 			  -Djenkins.install.runSetupWizard=false

# copy scripts and ressource files
# COPY jenkins-home/*.* $JENKINS_REF/
# COPY jenkins-home/jobs $JENKINS_REF/jobs/
# COPY jenkins-home/init.groovy.d/startup.groovy.override $JENKINS_REF/init.groovy.d/

CMD /usr/local/bin/jenkins.sh