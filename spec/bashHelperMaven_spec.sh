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
  catDowngradeNonSemVerAndCallShowOnlyDownGradeLines() {
    catAndCallShowOnlyDownGradeLines "downgradeNonSemVer"
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
  catUpgradeNonSemVerAndCallShowOnlyDownGradeLines() {
    catAndCallShowOnlyDownGradeLines "upgradeNonSemVer"
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
      It "should ignore upgrade output lines for non-SemVer versions"
        When I call catUpgradeNonSemVerAndCallShowOnlyDownGradeLines
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
        # be careful, we are matching for the tab character, don't have your editor change it to spaces!
        The output should equal "net.bytebuddy:byte-buddy 	 downgraded from 1.14.16 to 1.14.12
net.bytebuddy:byte-buddy-agent 	 downgraded from 1.14.12 to 1.13.16
org.mockito:mockito-junit-jupiter 	 downgraded from 5.11.0 to 4.11.0"
      End
      It "should output downgrade output lines for non-SemVer versions"
        When I call catDowngradeNonSemVerAndCallShowOnlyDownGradeLines
        The status should be success
        The output should not equal ""
        # be careful, we are matching for the tab character, don't have your editor change it to spaces!
        The output should equal "org.ow2.asm:asm 	 downgraded from 9.6 to 9.4
org.example:example 	 downgraded from 1.2.3.5 to 1.2.3.4
commons-logging:commons-logging 	 downgraded from 1.3.3 to 1.3"
      End
    End
    Describe "full example"
      It "should output downgrade output lines"
        When I call catFullAndCallShowOnlyDownGradeLines
        The status should be success
        # be careful, we are matching for the tab character, don't have your editor change it to spaces!
        The output should equal "net.bytebuddy:byte-buddy 	 downgraded from 1.14.16 to 1.14.12
net.bytebuddy:byte-buddy-agent 	 downgraded from 1.14.12 to 1.13.16
org.mockito:mockito-junit-jupiter 	 downgraded from 5.11.0 to 4.11.0"
      End
    End
  End
End
