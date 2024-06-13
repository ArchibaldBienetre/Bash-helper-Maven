Describe "bashHelperMaven.sh"
  Include ./bashHelperMaven.sh

  Describe "showOnlyDownGradeLines"
    It "should exist"
      When I call showOnlyDownGradeLines
      The status should be success
    End
  End
End
