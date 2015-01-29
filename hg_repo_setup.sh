#!/bin/bash 

echo "This script attempts to prove out the git branching model from here http://nvie.com/posts/a-successful-git-branching-model/"

if [ -z $1 ]; then
   echo "supply the directory to play with"
   exit 1
fi

dir=$1

if [ -d ${dir} ]; then
   echo "Dir already exists try again"
   exit 1
fi

mkdir ${dir}
cd ${dir}
hg init 
touch default
hg add default
hg commit -m "default"

echo "Creating branch release 1.0.0..."
hg branch release-1.0.0
echo 1.0.0 > release
hg add release
hg commit -m "release"


echo "Creating branch develop..."
hg branch develop
touch develop
hg add develop
hg commit -m "develop"

echo "Creating Feature/chris1..."
hg up develop
hg branch Feature/chris1
touch feature.chris1
hg add feature.chris1
hg commit -m "Feature/chris1"

echo "Creating Feature/chris2..."
hg up develop
hg branch Feature/chris2
touch feature.chris2
hg add feature.chris2
hg commit -m "Feature/chris2"

echo "Creating Feature/chris3..."
hg up develop
hg branch Feature/chris3
touch feature.chris3
hg add feature.chris3
hg commit -m "Feature/chris3"

echo "Creating bug RM88343..."
hg up develop
hg branch RM88343
touch bugfix.88343
hg add bugfix.88343
hg commit -m "RM88343"

echo "Merging Feature/chris1 to develop"
hg up develop
hg merge Feature/chris1
hg commit -m "Merged Feature/chris1 into develop" 
echo "Closing Feature/chris1"
hg up Feature/chris1
hg commit -m "Closed" --close-branch

echo "Merging Feature/chris3 to develop"
hg up develop
hg merge Feature/chris3
hg commit -m "Merged Feature/chris3 into develop" 
echo "Closing Feature/chris3"
hg up Feature/chris3 
hg commit -m "Closed" --close-branch

echo "Merging RM88343 to develop"
hg up develop
hg merge RM88343
hg commit -m "Merged RM88343 into develop" 
echo "Closing RM88343"
hg up RM88343
hg commit -m "Closed" --close-branch

echo "Prepping for a release"
hg up develop
hg branch release-1.1.0
echo 1.1.0 > release
echo "This is our readme for 1.1.0" > readme
touch another.file
hg addremove
hg commit -m "1.1.0 is prepped!"

echo "Last minute  bug RM88345..."
hg up release-1.1.0
touch bugfix.88345
hg add bugfix.88345
hg commit -m "RM88345"

echo "Ready to merge 1.1.0 into our default..."
hg up default
hg merge release-1.1.0
hg commit -m "1.1.0 is done"
hg tag 1.1.0 

