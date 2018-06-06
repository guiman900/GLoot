# G-Loot
Technical assignment for G-Loot.
The application is player management tool. The app show a list of players received from the server, the user have the options to add new players and view/update/delete existing ones.

## Prerequisites
Download the G-LOOT server (https://github.com/leoho/gloot-assignment/tree/ios)

## Installing
clone the development branch and run the project

## Built With
Almofire - Network Library

## Contributing
Please read CONTRIBUTING.md for details on our code of conduct, and the process for submitting pull requests to us.

RedGiant - Trial version of the trapcode Suite for the intro video
Icons : [Add user icon](https://www.flaticon.com/free-icon/new-user_72648#term=add%20user&page=1&position=4)
[Save user](https://www.flaticon.com/free-icon/floppy-disk_784304#term=save&page=2&position=50)
[Bin Icon](https://www.flaticon.com/free-icon/waste-bin_70388#term=bin&page=1&position=14)
[Cancel icon](https://www.flaticon.com/free-icon/cancel_128397#term=cancel&page=1&position=16)

## Versioning
I used GitHub for versioning. For the versions available, see the tags on this repository.

## Authors
Guillaume Manzano  - Developer

## License
This project is licensed under the MIT License - see the LICENSE.md file for details

## Documentation
To generate the documentation please use jazzy (https://github.com/realm/jazzy)

### G-Loot Documentation
```
cd GLoot
sudo jazzy --min-acl {private,internal,public}
cd doc
```
double click on index.html

### GLootNetwork Documentation
The GLootNetwork documentation is already available on the doc folder inside the GLootNetworkLibrary folder.
If you need to generate the documentation follow this steps.

```
cd GLoot/GLootNetworkLibrary
sudo jazzy
cd doc
```
double click on index.html

## Tests
The tests are available on the GLootNetworkLibrary project.
Open GLootNetworkLibrary project on XCode and open the file GLootNetworkLibraryTests.
Inside the GLootNetworkLibraryTests click on the button on the righ of the method testExample.
