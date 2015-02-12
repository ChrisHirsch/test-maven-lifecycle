all: clean maven 

hg: clean
	./hg_repo_setup.sh hg.test

maven: clean
	./hg_repo_setup_maven.sh

clean:
	rm -fr hg.test my-app hg.deleteme
