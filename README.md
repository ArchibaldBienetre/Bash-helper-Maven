# Bash helper: Maven

## What is this?

Just a helper [Bash](https://www.gnu.org/software/bash/) script I wrote in my spare time because I currently I'm currently investigating various [Apache Maven](https://maven.apache.org/) issues at work.

## Usage 

* Source the script to get the helper functions:  
`$ . bashHelperMaven.sh`
* Run the functions you want!

### Function _showOnlyDownGradeLines_

If you generate a maven dependency tree like so: ...  
`$ ./mvnw dependency:tree -Dverbose`

... it may show you that some dependencies were upgraded or downgraded - but it does not highlight those lines.

```
...
[INFO]    |  \- net.bytebuddy:byte-buddy:jar:1.14.11:test (version managed from 1.14.16)
...
```

This helper function is intended to highlight such lines in the output. 

Usage is like so: 

```
$ ./mvnw dependency:tree -Dverbose | showOnlyDownGradeLines
[INFO]    |  \- net.bytebuddy:byte-buddy:jar:1.14.11:test (version managed from 1.14.16)
```


