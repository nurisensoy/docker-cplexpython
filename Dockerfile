ARG UBUNTU_VERS=18.04
FROM ubuntu:${UBUNTU_VERS}

ARG JAVA_VERS=8
ARG PYTHON_MAJOR_NUM=3
ARG PYTHON_MINOR_NUM=6
#
RUN set -e \
    && apt-get update && apt-get install -y --no-install-recommends \
    openjdk-${JAVA_VERS}-jre \
    python${PYTHON_MAJOR_NUM}.${PYTHON_MINOR_NUM} \
    && apt-get install -y --no-install-recommends python${PYTHON_MAJOR_NUM}-pip
#
COPY cplex_studio1210.linux-x86-64.bin /cplex/cplex_studio1210.linux-x86-64.bin

COPY response.properties /cplex/response.properties
#
RUN chmod u+x /cplex/cplex_studio1210.linux-x86-64.bin

RUN /cplex/cplex_studio1210.linux-x86-64.bin -f /cplex/response.properties

RUN rm -rf /cplex
#
RUN pip3 install --upgrade pip

RUN pip3 install --upgrade setuptools
#
COPY requirements.txt .

RUN pip3 install --no-cache-dir -r requirements.txt

RUN python3 opt/ibm/ILOG/CPLEX_Studio1210/python/setup.py install



ARG CENTOS_VERS=7
FROM centos:${CENTOS_VERS}
#
RUN yum install --nogpg -y https://centos7.iuscommunity.org/ius-release.rpm

RUN yum --enablerepo=ius-archive install --nogpg -y python36u-3.6.8-1.ius.el7 python36u-pip

RUN yum install -y java-1.8.0-openjdk

RUN yum clean all && rm -rf /var/cache/yum/
#
COPY cplex_studio1210.linux-x86-64.bin /cplex/cplex_studio1210.linux-x86-64.bin

COPY response.properties /cplex/response.properties
#
RUN chmod u+x /cplex/cplex_studio1210.linux-x86-64.bin

RUN /cplex/cplex_studio1210.linux-x86-64.bin -f /cplex/response.properties

RUN rm -rf /cplex
#

COPY requirements.txt .

RUN pip-3 install --no-cache-dir -r requirements.txt

RUN python3 opt/ibm/ILOG/CPLEX_Studio1210/python/setup.py install



