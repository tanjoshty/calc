//
//  Calculator.swift
//  calc
//
//  Created by Josh Tan on 6/4/20.
//  Copyright © 2020 UTS. All rights reserved.
//

import Foundation

class Calculator {
    let operatorList = ["+", "-", "x", "/", "%"]
    
    var operator1: String;                        // Which operator
    var num1: Int;                                // Number 1
    var num2: Int;                                // Number 2
    var numIndex: Int = 0;                        // Index for Number 1
    var argCount: Int = Int(CommandLine.argc - 1) // Argument Count minus program name
    let startArgCount: Int = Int(CommandLine.argc - 1) // Starting Argument Count minus program name
    var argIndex: Int = 0;                        // Argument Index
    
    
    // Initialise values above from arguments
    init(args: inout [String]) throws {
        // Initialising first number
        num1 = Int(args[argIndex])!
        // Initialise Operator
        operator1 = String(args[argIndex + 1])
        if !operatorList.contains(operator1){
            exit(1)
        }
        // Initialise Second Number
        num2 = Int(args[argIndex + 2])!
        // If there are more than 3 arguments, check for higher prority operator.
        if argCount > 3 {
            // Store the index of the first number
            numIndex = findHighPriority(args: &args)
        }
    }

    
    // Get high priority operator and numbers next to it. Store as current numbers and operator. remove from array
    func findHighPriority (args: inout [String]) -> Int {
        // Loop from first operator till the last
        for i in stride(from: 1, to: argCount, by: 2){
            // if any operator is a priority operator
            if args[i] == "x" || args[i] == "/" || args[i] == "%" {
                // Store number left of the first priority operator
                num1 = Int(args[i - 1])!
                // Store number right of the first priority operator
                num2 = Int(args[i + 1])!
                // Store first priority operator
                operator1 = args[i]
                // Remove number right of the first priority operator and priority operator out of the equation
                args.remove(at: i + 1)
                args.remove(at: i)
                // Update argCount
                argCount -= 2
                // return the index of number before operator
                return i - 1
            }
        }
        // Loop finished and did not find any priority operators. Update variables and remove number and operator.
        num1 = Int(args[0])!
        num2 = Int(args[2])!
        operator1 = args[1]
        args.remove(at: 2)
        args.remove(at: 1)
        argCount -= 2
        // return the index of number before operator
        return 0
    }
    
    // Calculate Multiple-step calculation
    func multiStepCalc (args: inout [String]) -> Int {
        var multiResult: Int = 0
        switch operator1{
        case "+":
            multiResult = num1 + num2;
        case "-":
            multiResult = num1 - num2;
        case "x":
            multiResult = num1 * num2;
        case "/":
            multiResult = num1 / num2;
        case "%":
            multiResult = num1 % num2;
        default:
            multiResult = 0;
        }
        // store the first result in the index of the left side number of the current pair in equation
        args[numIndex] = String(multiResult)
        
        // if the equation still has more than 3 arguments eg 3 + 4 + 5
        if argCount > 3{
            // variables get updated and arguments removed
            numIndex = findHighPriority(args: &args)
            // rerun the function as there are still more numbers to be calculated
            return multiStepCalc(args: &args)
        
        // if equation only has 3 arguments eg 3 + 4
        } else if argCount == 3 {
            // Update variables
            num1 = Int(args[0])!
            num2 = Int(args[2])!
            operator1 = args[1]
            // Run the last variables in calculateLast
            return calculateLast(args: &args)
        }
        return 99
    }
    
    // Calculate last two numbers
    func calculateLast (args: inout [String]) -> Int {
        var result: Int
        switch operator1{
        case "+":
            result = num1 + num2;
        case "-":
            result = num1 - num2;
        case "x":
            result = num1 * num2;
        case "/":
            result = num1 / num2;
        case "%":
            result = num1 % num2;
        default:
            result = 0;
        }
        return result
    }
    
    
    // Main Calculate Function
    func calculate (args: inout [String]) -> String {
        var result: Int
        if argCount % 2 == 0{
            return "Error"
        } else if startArgCount == 3 {
            switch operator1{
            case "+":
                result = num1 + num2;
            case "-":
                result = num1 - num2;
            case "x":
                result = num1 * num2;
            case "/":
                result = num1 / num2;
            case "%":
                result = num1 % num2;
            default:
                result = 0;
            }
            return String(result)
        } else if startArgCount > 3 {
            for index in stride(from: 0, to: args.count, by: 1) {  //check if calculation result is out of bounds
                if let integerSize = Int(args[index]) {
                    if integerSize > Int32.max || integerSize < Int32.min {
                        exit(1)
                    }
                }
            }
            return String (multiStepCalc(args: &args));
        }
        return "Hello"
    }
}
