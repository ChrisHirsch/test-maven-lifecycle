#!/bin/bash  -x
cur=`pwd`
dir=`pwd`/my-app
hgrepo=`pwd`/hg.deleteme

echo "This script attempts to prove out the git branching model from here http://nvie.com/posts/a-successful-git-branching-model/ using Maven where possible"

if [ -d ${dir} ]; then
   echo "Dir already exists try again"
   exit 1
fi

echo "Initalizing pom file..."
mvn -B archetype:generate   -DarchetypeGroupId=org.apache.maven.archetypes   -DgroupId=com.mycompany.app   -DartifactId=my-app

echo "Creating project..."
cd ${dir}
hg init 
touch default
hg add default
hg commit -m "default"
cd ..
hg clone ${dir} ${hgrepo}
echo -e "[paths]\ndefault = ${hgrepo}" > ${dir}/.hg/hgrc

cd ${dir}

echo "Adding scm info to pom.xml.."
sed  -i -e "s/<\/project>//g" pom.xml
echo -e "<scm><connection>scm:hg:file:///${hgrepo}</connection></scm>\n</project>" >> pom.xml
hg addremove
hg commit -m "added pom.xml and default project files"

echo "Creating branch develop..."
hg up default
hg branch develop
touch develop
hg add develop
hg commit -m "develop"


echo "Creating branch release 1.0.0..."
cd ${dir}
hg up default
#mvn release:prepare
mvn release:clean release:branch -DbranchName=release-1.0.0 -DreleaseVersion=1.0.0 -DdevelopmentVersion=1.0.1-SNAPSHOT
#hg branch release-1.0.0
echo 1.0.0 > release
hg add release
hg commit -m "release 1.0.0"

echo "Creating Feature/chris1..."
hg up develop
mvn release:clean
mvn release:branch -DbranchName=Feature/chris1_RM2222 -DdevelopmentVersion=1.1.0-RM2222-SNAPSHOT -DreleaseVersion=1.1.0-RM2222 -DupdateBranchVersions=true -DupdateWorkingCopyVersions=false 
touch feature.chris1
hg add feature.chris1
hg commit -m "Feature/chris1_RM2222"
hg push --new-branch

echo "Creating Feature/chris2..."
hg up develop
mvn release:clean
mvn release:branch -DbranchName=Feature/chris2_RM2225 -DdevelopmentVersion=1.1.0-RM2225-SNAPSHOT -DreleaseVersion=1.1.0-RM2225 -DupdateBranchVersions=true -DupdateWorkingCopyVersions=false 
#hg branch Feature/chris2
touch feature.chris2
hg add feature.chris2
hg commit -m "Feature/chris2_RM2225"
hg push --new-branch

echo "Creating Feature/chris3..."
hg up develop
mvn release:clean
mvn release:branch -DbranchName=Feature/chris3_RM2224 -DdevelopmentVersion=1.1.0-RM2224-SNAPSHOT -DreleaseVersion=1.1.0-RM2224 -DupdateBranchVersions=true -DupdateWorkingCopyVersions=false 
hg branch Feature/chris3
touch feature.chris3
hg add feature.chris3
hg commit -m "Feature/chris3_RM2224"
hg push --new-branch

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"
hg push

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"
hg push

echo "Creating bug RM88343..."
hg up develop
mvn release:clean
mvn release:branch -DbranchName=RM88343 -DdevelopmentVersion=1.0.1-RM88343-SNAPSHOT -DreleaseVersion=1.0.1-RM88343 -DupdateBranchVersions=true -DupdateWorkingCopyVersions=false 
touch bugfix.88343
hg add bugfix.88343
hg commit -m "RM88343"
hg push --new-branch

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"

echo "Merging Feature/chris1 to develop"
hg up develop
hg merge Feature/chris1
hg commit -m "Merged Feature/chris1 into develop" 
echo "Closing Feature/chris1_RM2222"
hg up Feature/chris1
hg commit -m "Closed" --close-branch
hg push

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"

echo "Merging Feature/chris3 to develop"
hg up develop
hg merge Feature/chris3
hg commit -m "Merged Feature/chris3 into develop" 
echo "Closing Feature/chris3_RM2224"
hg up Feature/chris3 
hg commit -m "Closed" --close-branch
hg push

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"
hg push

echo "Merging RM88343 to develop"
hg up develop
hg merge RM88343
hg commit -m "Merged RM88343 into develop" 
echo "Closing RM88343"
hg up RM88343
hg commit -m "Closed" --close-branch
hg push

echo "Doing development on Feature/chris2..."
hg up Feature/chris2
date > feature.chris2
hg commit -m "work"
hg push


echo "Prepping for a release"
hg up develop
mvn release:branch -DbranchName=release-1.1.0 -DdevelopmentVersion=release-1.1.0-SNAPSHOT -DreleaseVersion=1.1.0 -DupdateBranchVersions=true -DupdateWorkingCopyVersions=false 
#mvn release:prepare 
#hg branch release-1.1.0
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
echo "Closing Feature/chris2_RM2225"
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

echo "Creating Feature/chris4..."
hg up develop
hg branch Feature/chris2
touch feature.chris2
hg add feature.chris2
hg commit -m "Feature/chris2_RM2225"


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
