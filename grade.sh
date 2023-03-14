CPATH='".;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar"'
rm -rf student-submission
git clone $1 student-submission
echo 'Finished cloning'

cd student-submission

if [[ -f ListExamples.java ]]
then
  echo "student submission found"
else
  echo "wrong file submitted"
  echo "You're grade is 0%, try again!"
  exit 1
fi

cp ../TestListExamples.java ./
javac -cp ".;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar" *.java 2>compiler-error.txt

if [[ $? == 0 ]]
then
  echo "successfully compiled"
else
  echo "compiler error!!!"
  cat compiler-error.txt
  echo "You're grade is 0%, try again!"
  exit 1
fi

java -cp ".;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar" org.junit.runner.JUnitCore TestListExamples > results.txt 2>&1

if [[ $? == 0 ]]
then
  echo "tests passed"
  cat results.txt
  echo "You're grade is 100%, congratulations!"

else
  echo "tests failed"
  cat results.txt

  num_tests=$(grep 'Tests run: ' results.txt | cut -d' ' -f3 | grep -Eo '[0-9]{1,4}')
  failures=$(grep 'Failures: ' results.txt | cut -d' ' -f6 | grep -Eo '[0-9]{1,4}')
  successes=$(($num_tests-$failures))
  grade=$((($successes * 100) / ($num_tests)))

  echo "You're grade is" $grade"%. Try again!"
  exit 1
fi