# Steps

1. Update the permission of the build.sh Shell Script

```bash
chmod +x build.sh
```

2. Execute the build.sh script

```bash
.\build.sh
```

## Build Results

3. To view the scout results

```bash
docker scout quickview
```

Syntax
```bash
docker scout cves local://dev-environment:<tag>
```

Example
```bash
docker scout cves local://dev-environment:05.21.2024d
```

### 1. Software Versions Build #1
    
    A. Python=3.10
    
    B. .NET=6.0
    
    C. Java=11.0

    D. GoLang=1.20

    267 vulnerabilities found in 70 packages
    
    UNSPECIFIED  12   
    LOW          102  
    MEDIUM       112  
    HIGH         37   
    CRITICAL     4  

### 2. Software Versions Build #3
    
    A. Python=3.10
    
    B. .NET=7.0
    
    C. Java=11.0

    D. GoLang=1.23

### 3. Software Versions Build #3

    A. Python=3.11
    
    B. .NET=7.0
    
    C. Java=11.0

    D. GoLang=1.22.3

    230 vulnerabilities found in 58 packages
    UNSPECIFIED  5    
    LOW          102  
    MEDIUM       108  
    HIGH         15   
    CRITICAL     0   


## 4. Executing the container

``` code
docker run -it --rm -e USERNAME=devops -v user_data_devops:/home/devops dev-environment:05.29.2024b /bin/bash
```
