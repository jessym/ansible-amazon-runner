FROM python

RUN pip3 install ansible

RUN pip3 install boto3
RUN ansible-galaxy collection install amazon.aws

VOLUME ["/ansible"]
WORKDIR /ansible

ENTRYPOINT ["bash", "-c"]
