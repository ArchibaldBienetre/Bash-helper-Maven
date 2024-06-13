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
  End
End
