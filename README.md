# Parking Lot
Solution attempted by Sue Zheng Hao for Gojek take-home test.

## Setup
Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) if it is not already installed. Then run `./bin/setup` to setup and run the test suite.  
If there are any problems, please check the [Known Issues](#known-issues).

## Commands

### Create the parking lot
Input: `create_parking_lot 6` - Create a parking lot with **6** slots

Success Response: `Created a parking lot with 6 slots`

Failure Response: `Invalid number of slots` - If argument was invalid (e.g. negative number or not a number)

Failure Response: `Parking lot already exists` - If parking lot was already created

### Park a car
Input: `park KA-01-HH-1234 White` - Attempt to park a **white** car with registration number **KA-01-HH-1234**.\
Assumptions: No duplicate registration numbers exist. Registration numbers do not contain whitespace characters.

Success Response: `Allocated slot number: 1` - Car allocated to an available slot **1**

Failure Response: `Sorry, parking lot is full` - Parking lot is fully occupied

### Leave the parking lot
Input: `leave 4` - Car parked in slot **4** leaves the parking lot

Success Response: `Slot number 4 is free` - Car has left the parking lot and slot **4** is now free

Failure Response: `No car in slot number 4` - There was no car in slot **4**

Failure Response: `Invalid slot number` - If argument was invalid (e.g. negative number or not a number)

### Check parking lot status
Input: `status`

Success Response:

    Slot No.    Registration No    Colour
    1           KA-01-HH-1234      White
    2           KA-01-HH-3141      Black
    3           KA-01-HH-9999      White

### Find registration numbers of all cars of a particular colour
Input: `registration_numbers_for_cars_with_colour White`

Success Response: `KA-01-HH-1234, KA-01-HH-9999`

Failure Response: `Not found`

### Find slot numbers of all slots where a car of a particular colour is parked.
Input: `slot_numbers_for_cars_with_colour White`

Success Response: `1, 3`

Failure Response: `Not found`

### Find slot number in which a car with a given registration number is parked.
Input: `slot_number_for_registration_number KA-01-HH-1234`

Success Response: `1`

Failure Response: `Not found`

### Exit the program
Input: `exit`

## Design Assumptions
- Car registration number & colour do not contain spaces
- Car registration number is case insensitive (e.g. 'ka-01' == 'KA-01')
- Car registration number has a max length of 18 characters (following given status output format)

## Possible Improvements
- The 3 find commands can be sped up by implementing a hashmap keyed by the car colour/registration number. Currently, they retrieve the result in linear time by checking every slot.
- The `park` command tries to park the car in the nearest free slot as defined in the question. Allowing the user to specify an alternative strategy may be useful.

## Known Issues
The test suite may fail on systems that use rbenv with an error like this:
`rbenv: bundle: command not found`.  
If you use rbenv, please run the following commands first:
```shell
cd functional_spec
rbenv versions
rbenv local <ruby version available in rbenv>
```