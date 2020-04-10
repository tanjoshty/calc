//
//  main.swift
//  calc
//
//  Created by Josh Tan on 6/4/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

var argCount: Int = Int(CommandLine.argc - 1) // count how many arguments minus name of program
var args = ProcessInfo.processInfo.arguments
args.removeFirst() // remove the name of the program

//Validate input

if (args.count % 2 == 0) {
    exit(1)
}
if (args.count == 1 && Int(args[0]) == nil)  {
    exit(2)
}
for index in stride(from: 0, to: args.count-2, by: 2) {
    if Int(args[index]) == nil {
        exit(3)
    }
}


// if there is only one argument, print it out.
if argCount == 1 {
    let number = args[0]
    var numberArray = Array(number)
    if numberArray[0] == "+"{
        numberArray.remove(at: 0)
        let charArr: [Character] = numberArray
        let numberString = String(charArr)
        print(numberString)
    } else {
        print(number)
    }
}

// if there are more than 3 arguments, initialise a new calculator object and calculate.
if argCount >= 3 {
    // Initialise Calculator object
    let calculator = try Calculator(args: &args);
    // Calculate the result
    let result = calculator.calculate(args: &args);
    // Print the result
    print (result)

}
