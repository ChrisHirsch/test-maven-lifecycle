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
hg commit -m "release 1.0.0"


hg up default

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

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"

echo "Creating bug RM88343..."
hg up develop
hg branch RM88343
touch bugfix.88343
hg add bugfix.88343
hg commit -m "RM88343"

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"

echo "Merging Feature/chris1 to develop"
hg up develop
hg merge Feature/chris1
hg commit -m "Merged Feature/chris1 into develop" 
echo "Closing Feature/chris1"
hg up Feature/chris1
hg commit -m "Closed" --close-branch

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"

echo "Merging Feature/chris3 to develop"
hg up develop
hg merge Feature/chris3
hg commit -m "Merged Feature/chris3 into develop" 
echo "Closing Feature/chris3"
hg up Feature/chris3 
hg commit -m "Closed" --close-branch

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"

echo "Merging RM88343 to develop"
hg up develop
hg merge RM88343
hg commit -m "Merged RM88343 into develop" 
echo "Closing RM88343"
hg up RM88343
hg commit -m "Closed" --close-branch

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"


echo "Prepping for a release"
hg up develop
hg branch release-1.1.0
echo 1.1.0 > release
echo "This is our readme for 1.1.0" > readme
touch another.file
hg addremove
hg commit -m "1.1.0 is prepped!"

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"

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
hg up develop
hg merge release-1.1.0
hg commit -m "Merged 1.1.0 into develop"
echo "Should we close 1.1.0 now???"

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"

echo "Carrying on with life...."

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
echo "Some work" > feature.chris2
hg commit -m "Some work"
echo "MOre work" > feature.chris2
hg commit -m "More work"
echo "Another file" > another_file.chris2
hg add another_file.chris2
hg commit -m "Added a new file"
echo "Finally done with Feature/chris2..."

echo "Merging Feature/chris2 to develop"
hg up develop
hg merge Feature/chris2
hg commit -m "Merged Feature/chris2 into develop" 
echo "Closing Feature/chris2"
hg up Feature/chris2
hg commit -m "Closed" --close-branch

echo "Aww crap...QA found a bug with Feature/chris2...Assigned RM88444..."
echo "Creating bug RM88444..."
hg up develop
hg branch RM88444
touch bugfix.88444
hg add bugfix.88444
hg commit -m "RM88444"

echo "ALERT ALERT...SEV 1!!! RUN AROUND WITH HAIR ON FIRE!!!...Assigned RM88445..."
echo "Creating bug RM88445..."
hg up default
hg branch hotfix-1.1.1
touch bugfix.88445
hg add bugfix.88445
hg commit -m "RM88445 SEV1"
hg commit -m "Closed" --close-branch
echo "Merge the hotfix with develop..."
hg up develop
hg merge hotfix-1.1.1
hg commit -m "Merged hotfix-1.1.1"

echo "Let RM88444 set out there while we release RM88445...oh yeah..don't forget that Feature/chris2 shouldn't go out yet!!"
hg up default
hg merge hotfix-1.1.1
echo 1.1.1 > release
hg commit -m "1.1.1 is done"
hg tag 1.1.1 
hg up develop
hg merge release-1.1.1
hg commit -m "Merged 1.1.1 into develop"
echo "Should we close 1.1.1 now???"



echo "Summary of work..."
hg up default
hg sum
hg tags
hg branches
