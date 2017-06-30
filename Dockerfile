#Dockerfile for building applications image from a Dockerfile

FROM debian:jessie

MAINTAINER Vaibhav Swarnkar <vaibhavswarnkar@vostics.com> | Vostics

#Update all repositories and install curl
RUN apt-get -qq update && apt-get install -y curl \
												google-cloud-sdk

#Remove and old version of docker installed
RUN apt-get remove docker docker-engine docker.io

#Update repositories
RUN apt-get update 

#Install packages to allow apt to a repository over HTTPS
RUN apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common


#Add Docker’s official GPG key:
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

#Setup stable repository
RUN sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

RUN apt-get update

#Install Docker Community Edition
RUN apt-get install docker-ce   

#Make a new directory
RUN mkdir dockerdir

#Change the working directory
WORKDIR /dockerdir/


#Download the Dockerfile from URL recevied as the param
RUN curl $DOCKERFILE > ./Dockerfile

#Build the docker image
RUN docker build -t $IMAGE_NAME .

#Tag the image
RUN docker tag $IMAGE_NAME $REGISTRY_URL/$IMAGE_NAME:$IMAGE_VERSION

#Push the image 
RUN docker push $REGISTRY_URL/$IMAGE_NAME:$IMAGE_VERSION


