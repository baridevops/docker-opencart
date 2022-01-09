#!/bin/bash

###
##
# expects branch or tag as first arg
# expects space separated list of images to push as second arg
##
###

export PATH=$PATH:/$HOME/.local/bin

echo
echo push for master branch onto odd numbered version
echo
docker images
echo

#for i in $2; do
#    aws ecr describe-repositories --repository-names kobai/${i}
#    if [ $? = 0 ] ; then
#	echo "repository $i exists"
#    else
#	aws ecr create-repository --repository-name kobai/${i}
#	aws ecr put-lifecycle-policy --repository-name kobai/${i} --lifecycle-policy-text file://repopolicy.json
#    fi
#done

eval $(docker login -u $DOCKER_USER -p $DOCKER_PASSWORD)

ver=$(git describe --tags --abbrev=0 ${TRAVIS_COMMIT})

for i in $2; do
    echo docker tag ${i} $DOCKER_USER/${i}:build-${ver}.$TRAVIS_BUILD_NUMBER
    docker tag ${i} $DOCKER_USER/${i}:build-${ver}.$TRAVIS_BUILD_NUMBER
    echo docker push $DOCKER_USER/${i}:build-${ver}.$TRAVIS_BUILD_NUMBER
    docker push $DOCKER_USER/${i}:build-${ver}.$TRAVIS_BUILD_NUMBER
#    ./build-tools/travis2discord.sh pushsuccess $DISCORD_WEBHOOK "${i}" "build-${ver}.$TRAVIS_BUILD_NUMBER"
done

if [ $1 = "tag" ] ; then
    echo
    echo push for tag $TRAVIS_TAG
    echo
    for i in $2; do
	echo docker tag ${i} $DOCKER_USER/${i}:rc-${TRAVIS_TAG}.${TRAVIS_BUILD_NUMBER}
	docker tag ${i} $DOCKER_USER/${i}:rc-${TRAVIS_TAG}.${TRAVIS_BUILD_NUMBER}
	echo docker push $DOCKER_USER/${i}:rc-${TRAVIS_TAG}.${TRAVIS_BUILD_NUMBER}
	docker push $DOCKER_USER/${i}:rc-${TRAVIS_TAG}.${TRAVIS_BUILD_NUMBER}
#	./build-tools/travis2discord.sh pushsuccess $DISCORD_WEBHOOK "${i}" "$TRAVIS_TAG"
    done
fi
