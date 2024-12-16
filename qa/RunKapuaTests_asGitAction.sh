#!/usr/bin/env bash

#THIS SCRIPT IS SIMILAR TO "RUNKAPUATESTS.SH' BUT EXECUTES TESTS IN THE SAME WAY AS THE GIT ACTION CI PROCESS DOES, AKA USING THE CATEGORY TAGS

#RUNS BOTH UNIT AND INTEGRATION TESTS AND FINALLY BUILDS THE PROJECT
#FIRT, JUNIT TESTS ARE LAUNCHED, IF THEY PASS CUCUMBER TESTS ARE THEN EXECUTED

cucumberTags=('@brokerAcl' '@tag' '@broker' '@device' '@deviceManagement' '@connection' '@datastore' '@user' '@userIntegrationBase' '@userIntegration' '@security' '@jobs' '@scheduler' '@jobService' '@triggerService' '@account' '@translator' '@jobEngineStepDefinitions' '@jobEngineStartOfflineDevice' '@jobEngineRestartOnlineDevice' '@jobEngineStartOnlineDevice' '@jobEngineRestartOfflineDevice' '@jobEngineRestartOnlineDeviceSecondPart' '@jobsIntegration' '@jobEngineServiceStop' '@endpoint' '@deviceRegistry' '@role' '@group')
exitCodesTests=() #will contain exit code for each batch of tests

#checks if the last build command exited normally and exits if necessary
checkErrorLastBuild() {
	if [ "$?" -ne 0 ]; then #retrieve exit code of last command
		echo "$1";
		exit "$?";
	fi
}

#print in tabular form the building phases for each batch of tests
printTestResults() {
  printf "Unit tests passed, build launched with cucumber tests results:\n";
  for i in "${!cucumberTags[@]}"
  do
    if [ "${exitCodesTests[$i]}" -ne 0 ]; then #error on this test
      printf "%s\t\t%s\n" "BUILD FAIL" "${cucumberTags[$i]}";
    else
      printf "%s\t\t%s\n" "BUILD SUCCESS" "${cucumberTags[$i]}";
    fi
  done
  printf "Be aware that the build may have been failed for various reasons and not just test failures!\n";
  printf "For this reason, inspect the logs of each individual batch of tests: see files under <%s>\n" "qa/integration/target/surefire-reports/";
  printf "Also, tests could be affected by random errors as well as resources limitations of your machine\n";
  printf "For this reason, consider the option to run the GitHub continuous integration process of Kapua, which executes these tests on powerful remote machines\n";
}

#this line verifies existence of the lookup for the message-broker alias used in integration tests
grep -q "127.0.0.1 message-broker" /etc/hosts || { echo "password required to change hosts file" && { echo "127.0.0.1 message-broker" | sudo tee -a /etc/hosts;} }

echo "Started junit tests";
mvn clean verify -Dcommons.settings.hotswap=true -Dgroups='org.eclipse.kapua.qa.markers.junit.JUnitTests' -DskipITs=true;
checkErrorLastBuild "error on junit tests. Execution terminated because it's pointless to proceed with cucumber tests";
for tag in "${cucumberTags[@]}"
do
	echo "cucumber tests tagged as $tag";
	bash -c 'mvn verify -Dcommons.db.schema=kapuadb -Dcommons.settings.hotswap=true -Dbroker.host=localhost -Dgroups="!org.eclipse.kapua.qa.markers.junit.JUnitTests" -Dcrypto.secret.key=kapuaTestsKey!!! -Duser.timezone=UTC -Dcucumber.filter.tags=$0' $tag;
	exitCodesTests+=($?);
done
mvn install -DskipTests=true #finally, build completely the project
printTestResults;

#mvn verify -Dcommons.db.schema=kapuadb -Dcommons.settings.hotswap=true -Dbroker.host=localhost -Dgroups='!org.eclipse.kapua.qa.markers.junit.JUnitTests' -Dcucumber.filter.tags=@env_docker -Duser.timezone=UTC