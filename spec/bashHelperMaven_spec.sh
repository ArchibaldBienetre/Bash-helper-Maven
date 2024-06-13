Describe "bashHelperMaven.sh"
  Include ./bashHelperMaven.sh

  # these functions are workarounds, ShellSpec does not allow piped oparations in its When statements
  catAndCallShowOnlyDownGradeLines() {
      cat "${SHELLSPEC_PROJECT_ROOT}/spec/testdata/$1MavenDependencyTreeOutput.txt" | showOnlyDownGradeLines
      return $?
  }
  catDowngradeAndCallShowOnlyDownGradeLines() {
    catAndCallShowOnlyDownGradeLines "downgrade"
    return $?
  }
  catFullAndCallShowOnlyDownGradeLines() {
    catAndCallShowOnlyDownGradeLines "full"
    return $?
  }
  catSameVersionAndCallShowOnlyDownGradeLines() {
    catAndCallShowOnlyDownGradeLines "sameVersion"
    return $?
  }
  catUnrelatedAndCallShowOnlyDownGradeLines() {
    catAndCallShowOnlyDownGradeLines "unrelated"
    return $?
  }
  catUpgradeAndCallShowOnlyDownGradeLines() {
    catAndCallShowOnlyDownGradeLines "upgrade"
    return $?
  }

  Describe "showOnlyDownGradeLines"
    Describe "wrong usage"
      It "should print usage if not called in a pipe"
        When I call showOnlyDownGradeLines
        The status should be failure
        The output should include "Usage"
      End
    End
    Describe "ignored content"
      It "should ignore unrelated output lines"
        When I call catUnrelatedAndCallShowOnlyDownGradeLines
        The status should be success
        The output should equal ""
      End
      It "should ignore upgrade output lines"
        When I call catUpgradeAndCallShowOnlyDownGradeLines
        The status should be success
        The output should equal ""
      End
      It "should ignore same-version output lines"
        When I call catSameVersionAndCallShowOnlyDownGradeLines
        The status should be success
        The output should equal ""
      End
    End
    Describe "filtered content"
      It "should output downgrade output lines"
        When I call catDowngradeAndCallShowOnlyDownGradeLines
        The status should be success
        The output should not equal ""
        The output should equal "net.bytebuddy:byte-buddy \t downgraded from 1.14.16 to 1.14.12
net.bytebuddy:byte-buddy-agent \t downgraded from 1.14.12 to 1.13.16
org.mockito:mockito-junit-jupiter \t downgraded from 5.11.0 to 4.11.0"
      End
    End
    Describe "full example"
      It "should output downgrade output lines"
        When I call catFullAndCallShowOnlyDownGradeLines
        The status should be success
        The output should equal "net.bytebuddy:byte-buddy \t downgraded from 1.14.16 to 1.14.12
net.bytebuddy:byte-buddy-agent \t downgraded from 1.14.12 to 1.13.16
org.mockito:mockito-junit-jupiter \t downgraded from 5.11.0 to 4.11.0"
      End
    End
  End
End
